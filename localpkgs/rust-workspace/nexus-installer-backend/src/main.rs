use anyhow::Result;
use alpm::{Alpm, Database, Package, PackageReason, SigLevel};
use clap::{Parser, Subcommand};
use colored::*;
use indicatif::{ProgressBar, ProgressStyle};
use std::path::Path;

#[derive(Parser, Debug)]
#[command(name = "nexus-installer", version, about = "Nexus Linux package installer backend")]
struct Args {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand, Debug)]
enum Commands {
    /// Install packages
    Install {
        packages: Vec<String>,
        #[arg(short, long)]
        no_confirm: bool,
        #[arg(short, long)]
        needed: bool,
    },
    /// Remove packages
    Remove {
        packages: Vec<String>,
        #[arg(long)]
        recursive: bool,
        #[arg(long)]
        nosave: bool,
    },
    /// Update system
    Update {
        #[arg(short, long)]
        no_confirm: bool,
    },
    /// Search packages
    Search {
        query: String,
    },
    /// List installed packages
    List {
        #[arg(long)]
        explicit: bool,
        #[arg(long)]
        deps: bool,
    },
    /// Show package info
    Info {
        package: String,
    },
    /// Clean cache
    Clean {
        #[arg(long)]
        keep: Option<u32>,
    },
}

fn main() -> Result<()> {
    let args = Args::parse();
    let alpm = Alpm::new("/", "/var/lib/pacman")?;

    match args.command {
        Commands::Install { packages, no_confirm, needed } => {
            install_packages(&alpm, packages, no_confirm, needed)?;
        }
        Commands::Remove { packages, recursive, nosave } => {
            remove_packages(&alpm, packages, recursive, nosave)?;
        }
        Commands::Update { no_confirm } => {
            update_system(&alpm, no_confirm)?;
        }
        Commands::Search { query } => {
            search_packages(&alpm, &query)?;
        }
        Commands::List { explicit, deps } => {
            list_packages(&alpm, explicit, deps)?;
        }
        Commands::Info { package } => {
            show_info(&alpm, &package)?;
        }
        Commands::Clean { keep } => {
            clean_cache(keep)?;
        }
    }
    Ok(())
}

fn install_packages(alpm: &Alpm, packages: Vec<String>, no_confirm: bool, needed: bool) -> Result<()> {
    let db = alpm.localdb();
    let mut to_install = Vec::new();

    for pkg in packages {
        if db.get_pkg(&pkg).is_some() {
            println!("{} {}", "Already installed:".bright_yellow(), pkg.bright_cyan());
            continue;
        }
        to_install.push(pkg);
    }

    if to_install.is_empty() {
        println!("{}", "Nothing to install".bright_green());
        return Ok(());
    }

    let trans = alpm.trans_init(SigLevel::default())?;
    for pkg in &to_install {
        trans.add_pkg(pkg)?;
    }

    let _trans = trans.prepare()?;
    let trans = _trans.commit()?;

    println!("{} {}", "Installed:".bright_green(), to_install.join(", ").bright_cyan());
    Ok(())
}

fn remove_packages(alpm: &Alpm, packages: Vec<String>, recursive: bool, nosave: bool) -> Result<()> {
    let db = alpm.localdb();
    let mut to_remove = Vec::new();

    for pkg in packages {
        if db.get_pkg(&pkg).is_none() {
            println!("{} {}", "Not installed:".bright_yellow(), pkg.bright_cyan());
            continue;
        }
        to_remove.push(pkg);
    }

    if to_remove.is_empty() {
        println!("{}", "Nothing to remove".bright_green());
        return Ok(());
    }

    let mut trans = alpm.trans_init(SigLevel::default())?;
    for pkg in &to_remove {
        trans.remove_pkg(pkg)?;
    }

    let trans = trans.prepare()?;
    trans.commit()?;

    println!("{} {}", "Removed:".bright_green(), to_remove.join(", ").bright_cyan());
    Ok(())
}

fn update_system(alpm: &Alpm, no_confirm: bool) -> Result<()> {
    let mut trans = alpm.trans_init(SigLevel::default())?;
    trans.sys_upgrade(no_confirm)?;
    let trans = trans.prepare()?;
    trans.commit()?;
    println!("{}", "System updated".bright_green());
    Ok(())
}

fn search_packages(alpm: &Alpm, query: &str) -> Result<()> {
    let dbs = alpm.syncdbs();
    let mut found = Vec::new();

    for db in dbs {
        for pkg in db.pkgs() {
            if pkg.name().to_lowercase().contains(&query.to_lowercase()) {
                found.push(pkg);
            }
        }
    }

    if found.is_empty() {
        println!("{}", "No packages found".bright_yellow());
        return Ok(());
    }

    for pkg in found {
        let version = pkg.version();
        let desc = pkg.desc().unwrap_or("No description");
        println!("{} {} {}", pkg.name().bright_cyan(), version.bright_green(), desc.dimmed());
    }
    Ok(())
}

fn list_packages(alpm: &Alpm, explicit: bool, deps: bool) -> Result<()> {
    let db = alpm.localdb();
    let mut pkgs: Vec<_> = db.pkgcache().iter().collect();

    pkgs.sort_by(|a, b| a.name().cmp(b.name()));

    for pkg in pkgs {
        let reason = pkg.reason();
        if explicit && reason != PackageReason::Explicit {
            continue;
        }
        if deps && reason == PackageReason::Explicit {
            continue;
        }

        let reason_str = match reason {
            PackageReason::Explicit => "explicit".bright_green(),
            PackageReason::Dependency => "dependency".bright_yellow(),
        };

        println!("{} {} {}", pkg.name().bright_cyan(), pkg.version().bright_green(), reason_str);
    }
    Ok(())
}

fn show_info(alpm: &Alpm, package: &str) -> Result<()> {
    let syncdbs = alpm.syncdbs();
    let localdb = alpm.localdb();

    // Check local first
    if let Some(pkg) = localdb.get_pkg(package) {
        print_pkg_info(&pkg, true);
        return Ok(());
    }

    // Check sync dbs
    for db in syncdbs {
        if let Some(pkg) = db.get_pkg(package) {
            print_pkg_info(&pkg, false);
            return Ok(());
        }
    }

    anyhow::bail!("Package '{}' not found", package);
}

fn print_pkg_info(pkg: &Package, installed: bool) {
    println!("{}", "Package Information".bright_blue().bold());
    println!("  Name:        {}", pkg.name().bright_cyan());
    println!("  Version:     {}", pkg.version().bright_green());
    println!("  Description: {}", pkg.desc().unwrap_or("None").bright_white());
    println!("  Architecture: {}", pkg.arch().bright_white());
    println!("  URL:          {}", pkg.url().bright_blue());
    println!("  Licenses:     {}", pkg.licenses().join(", ").bright_white());
    println!("  Groups:       {}", pkg.groups().join(", ").bright_white());
    println!("  Provides:     {}", pkg.provides().join(", ").bright_white());
    println!("  Depends:      {}", pkg.depends().join(", ").bright_white());
    println!("  OptDepends:   {}", pkg.optdepends().join(", ").bright_white());
    println!("  Conflicts:    {}", pkg.conflicts().join(", ").bright_red());
    println!("  Replaces:     {}", pkg.replaces().join(", ").bright_yellow());
    println!("  Download Size: {}", format_size(pkg.download_size()));
    println!("  Install Size:  {}", format_size(pkg.install_size()));
    println!("  Installed:    {}", if installed { "Yes".bright_green() } else { "No".bright_red() });
}

fn format_size(bytes: i64) -> String {
    if bytes >= 1_073_741_824 {
        format!("{:.2} GB", bytes as f64 / 1_073_741_824.0)
    } else if bytes >= 1_048_576 {
        format!("{:.2} MB", bytes as f64 / 1_048_576.0)
    } else if bytes >= 1024 {
        format!("{:.2} KB", bytes as f64 / 1024.0)
    } else {
        format!("{} B", bytes)
    }
}

fn clean_cache(keep: Option<u32>) -> Result<()> {
    let cache_dir = Path::new("/var/cache/pacman/pkg");
    if !cache_dir.exists() {
        println!("{}", "Cache directory not found".bright_yellow());
        return Ok(());
    }

    let mut entries: Vec<_> = fs::read_dir(cache_dir)?
        .filter_map(|e| e.ok())
        .filter(|e| e.path().extension().map_or(false, |ext| ext == "pkg.tar.zst" || ext == "sig"))
        .collect();

    entries.sort_by_key(|e| e.metadata().unwrap().modified().unwrap());

    let keep = keep.unwrap_or(3);
    if entries.len() <= keep as usize {
        println!("{} {}", "Nothing to clean, keeping".bright_green(), keep);
        return Ok(());
    }

    let to_remove = entries.len() - keep as usize;
    for entry in entries.iter().take(to_remove) {
        fs::remove_file(entry.path())?;
        println!("{} {}", "Removed:".bright_green(), entry.file_name().to_string_lossy().bright_cyan());
    }

    println!("{}", format!("Cleaned {} packages, kept {}", to_remove, keep).bright_green());
    Ok(())
}