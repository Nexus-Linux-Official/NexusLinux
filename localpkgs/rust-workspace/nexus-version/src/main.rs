use anyhow::Result;
use clap::Parser;
use colored::*;
use serde::{Deserialize, Serialize};
use std::fs;
use std::process::Command;

#[derive(Parser, Debug)]
#[command(name = "nexus-version", version, about = "Nexus Linux version information")]
struct Args {
    /// Output as JSON
    #[arg(short, long)]
    json: bool,

    /// Show short version only
    #[arg(short, long)]
    short: bool,
}

#[derive(Serialize, Deserialize, Debug, Default)]
struct VersionInfo {
    version: String,
    build_date: String,
    git_commit: String,
    rust_version: String,
    profile: String,
    kernel: String,
}

fn main() -> Result<()> {
    let args = Args::parse();

    let info = VersionInfo {
        version: get_version()?,
        build_date: get_build_date()?,
        git_commit: get_git_commit()?,
        rust_version: get_rust_version()?,
        profile: get_profile()?,
        kernel: get_kernel_version()?,
    };

    if args.json {
        println!("{}", serde_json::to_string_pretty(&info)?);
    } else if args.short {
        println!("{}", info.version);
    } else {
        println!("Nexus Linux {}", info.version.bright_cyan().bold());
        println!("Build Date:  {}", info.build_date.bright_cyan());
        println!("Git Commit:  {}", info.git_commit.bright_cyan());
        println!("Rust Version: {}", info.rust_version.bright_cyan());
        println!("Profile:     {}", info.profile.bright_cyan());
        println!("Kernel:      {}", info.kernel.bright_cyan());
    }

    Ok(())
}

fn get_version() -> Result<String> {
    // Try to read from /etc/os-release first
    if let Ok(content) = fs::read_to_string("/etc/os-release") {
        for line in content.lines() {
            if line.starts_with("VERSION_ID=") {
                return Ok(line.trim_start_matches("VERSION_ID=").trim_matches('"').to_string());
            }
        }
    }

    // Fallback to version-tag file
    if let Ok(content) = fs::read_to_string("/etc/version-tag") {
        return Ok(content.trim().to_string());
    }

    Ok("unknown".to_string())
}

fn get_build_date() -> Result<String> {
    if let Ok(content) = fs::read_to_string("/etc/version-tag") {
        let date = content.trim();
        // Format: YYMMDD -> YYYY-MM-DD
        if date.len() == 6 {
            let year = format!("20{}", &date[0..2]);
            let month = &date[2..4];
            let day = &date[4..6];
            return Ok(format!("{}-{}-{}", year, month, day));
        }
    }
    Ok("unknown".to_string())
}

fn get_git_commit() -> Result<String> {
    let output = Command::new("git")
        .args(["rev-parse", "--short", "HEAD"])
        .output()?;
    Ok(String::from_utf8_lossy(&output.stdout).trim().to_string())
}

fn get_rust_version() -> Result<String> {
    let output = Command::new("rustc").args(["--version"]).output()?;
    Ok(String::from_utf8_lossy(&output.stdout).trim().to_string())
}

fn get_profile() -> Result<String> {
    if let Ok(content) = fs::read_to_string("/etc/edition-tag") {
        Ok(content.trim().to_string())
    } else {
        Ok("desktop".to_string())
    }
}

fn get_kernel_version() -> Result<String> {
    let output = Command::new("uname").args(["-r"]).output()?;
    Ok(String::from_utf8_lossy(&output.stdout).trim().to_string())
}