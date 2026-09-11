use anyhow::Result;
use clap::{Parser, Subcommand};
use colored::*;
use indicatif::{ProgressBar, ProgressStyle};
use sha2::{Digest, Sha256};
use std::fs;
use std::path::PathBuf;
use walkdir::WalkDir;

#[derive(Parser, Debug)]
#[command(name = "nexus-build", version, about = "Nexus Linux build helpers")]
struct Args {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand, Debug)]
enum Commands {
    /// Verify ISO checksums
    VerifyChecksums {
        #[arg(short, long)]
        iso: PathBuf,
    },
    /// Generate package list
    GenPackageList {
        #[arg(short, long)]
        output: PathBuf,
        #[arg(short, long)]
        profile: String,
    },
    /// Validate PKGBUILDs
    ValidatePkgs {
        #[arg(short, long)]
        dir: PathBuf,
    },
    /// Create ISO
    CreateIso {
        #[arg(short, long)]
        profile: String,
        #[arg(long)]
        out_dir: PathBuf,
    },
}

fn main() -> Result<()> {
    let args = Args::parse();

    match args.command {
        Commands::VerifyChecksums { iso } => verify_checksums(&iso)?,
        Commands::GenPackageList { output, profile } => gen_package_list(&output, &profile)?,
        Commands::ValidatePkgs { dir } => validate_pkgs(&dir)?,
        Commands::CreateIso { profile, out_dir } => create_iso(&profile, &out_dir)?,
    }
    Ok(())
}

fn verify_checksums(iso: &PathBuf) -> Result<()> {
    println!("{} {}", "Verifying ISO:".bright_blue(), iso.display().to_string().bright_cyan());

    let mut file = fs::File::open(iso)?;
    let mut hasher = sha2::Sha256::new();
    let mut buffer = vec![0; 8192];

    let pb = ProgressBar::new(fs::metadata(iso)?.len());
    pb.set_style(ProgressStyle::default_bar()
        .template("{spinner:.green} [{elapsed_precise}] [{bar:40.cyan/blue}] {bytes}/{total_bytes} ({eta})")
        .unwrap()
        .progress_chars("#>-"));

    loop {
        let n = std::io::Read::read(&mut file, &mut buffer)?;
        if n == 0 { break; }
        hasher.update(&buffer[..n]);
        pb.inc(n as u64);
    }

    let hash = hasher.finalize();
    pb.finish_with_message("Checksum calculated");

    println!("SHA256: {}", format!("{:x}", hash).bright_cyan());

    // Check against .sha256 file if exists
    let sha256_file = iso.with_extension("sha256");
    if sha256_file.exists() {
        let expected = fs::read_to_string(&sha256_file)?;
        let expected = expected.trim().split_whitespace().next().unwrap_or("");
        if expected == format!("{:x}", hash) {
            println!("{}", "✓ Checksum matches!".bright_green().bold());
        } else {
            eprintln!("{}", "✗ Checksum mismatch!".bright_red().bold());
            std::process::exit(1);
        }
    }

    Ok(())
}

fn gen_package_list(output: &PathBuf, profile: &str) -> Result<()> {
    let mut packages = Vec::new();

    // Read from netinstall.yaml
    let netinstall_path = format!("archiso/airootfs/usr/share/nexus-calamares/modules/netinstall.yaml");
    if let Ok(content) = fs::read_to_string(&netinstall_path) {
        for line in content.lines() {
            let line = line.trim();
            if line.starts_with("- ") {
                let pkg = line[2..].trim();
                if !pkg.is_empty() && !pkg.starts_with('#') {
                    packages.push(pkg.to_string());
                }
            }
        }
    }

    // Read from packages file
    let pkg_file = format!("archiso/packages_{}.x86_64", profile);
    if let Ok(content) = fs::read_to_string(&pkg_file) {
        for line in content.lines() {
            let line = line.trim();
            if !line.is_empty() && !line.starts_with('#') {
                packages.push(line.to_string());
            }
        }
    }

    packages.sort();
    packages.dedup();

    fs::write(output, packages.join("\n"))?;
    println!("{} {} packages written to {}", "Generated".bright_green(), packages.len(), output.display());

    Ok(())
}

fn validate_pkgs(dir: &PathBuf) -> Result<()> {
    let pb = ProgressBar::new(0);
    pb.set_style(ProgressStyle::default_bar()
        .template("{spinner:.green} [{elapsed_precise}] [{bar:40.cyan/blue}] {pos}/{len} {msg}")
        .unwrap()
        .progress_chars("#>-"));

    let mut errors = 0;
    let mut warnings = 0;

    for entry in WalkDir::new(dir) {
        let entry = entry?;
        if entry.file_name() == "PKGBUILD" {
            pb.inc(1);
            if let Err(e) = validate_pkgbuild(entry.path()) {
                eprintln!("{} {}: {}", "ERROR".bright_red(), entry.path().display(), e);
                errors += 1;
            }
        }
    }

    pb.finish_with_message(format!("Validated {} packages, {} errors, {} warnings", 
        pb.length().unwrap_or(0), errors, warnings));

    if errors > 0 {
        std::process::exit(1);
    }
    Ok(())
}

fn validate_pkgbuild(path: &std::path::Path) -> Result<()> {
    let content = fs::read_to_string(path)?;

    // Check required fields
    let required = ["pkgname", "pkgver", "pkgrel", "pkgdesc", "arch", "license"];
    for field in required {
        if !content.contains(&format!("{}=", field)) {
            anyhow::bail!("Missing required field: {}", field);
        }
    }

    // Check for SKIP checksums
    if content.contains("sha256sums=('SKIP'") || content.contains("sha256sums=(\"SKIP\"") {
        eprintln!("{} {}: Using SKIP checksums", "WARN".bright_yellow(), path.display());
    }

    // Check for valid source URLs
    // ... more validation

    Ok(())
}

fn create_iso(profile: &str, out_dir: &PathBuf) -> Result<()> {
    println!("{} {} profile...", "Building ISO for".bright_blue(), profile.bright_cyan());

    let status = std::process::Command::new("./build-nexus-iso.sh")
        .arg(profile)
        .current_dir(std::env::current_dir()?)
        .status()?;

    if !status.success() {
        anyhow::bail!("Build failed with exit code: {}", status.code().unwrap_or(-1));
    }

    // Find ISO
    let out_profile_dir = out_dir.join(profile);
    let mut iso_path = None;
    for entry in fs::read_dir(&out_profile_dir)? {
        let entry = entry?;
        if entry.path().extension().map_or(false, |ext| ext == "iso") {
            iso_path = Some(entry.path());
            break;
        }
    }

    if let Some(iso) = iso_path {
        println!("{} {}", "ISO created:".bright_green(), iso.display());
    } else {
        anyhow::bail!("ISO not found in output directory");
    }

    Ok(())
}