use anyhow::Result;
use clap::{Parser, Subcommand};
use std::fs;
use std::process::Command;

#[derive(Parser, Debug)]
#[command(name = "nexus-micro", version, about = "Nexus Linux micro settings utilities")]
struct Args {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand, Debug)]
enum Commands {
    /// Configure zram
    Zram {
        #[arg(short, long)]
        enable: bool,
        #[arg(short, long)]
        size: Option<String>,
        #[arg(short, long)]
        algorithm: Option<String>,
    },
    /// Set hostname
    Hostname {
        name: String,
    },
    /// Service management
    Service {
        #[arg(short, long)]
        enable: bool,
        #[arg(short, long)]
        disable: bool,
        #[arg(short, long)]
        start: bool,
        #[arg(short, long)]
        stop: bool,
        #[arg(short, long)]
        restart: bool,
        #[arg(short, long)]
        status: bool,
        service: String,
    },
    /// Apply all micro settings
    ApplyAll,
}

fn main() -> Result<()> {
    let args = Args::parse();

    match args.command {
        Commands::Zram { enable, size, algorithm } => {
            if enable {
                setup_zram(size, algorithm)?;
            } else {
                disable_zram()?;
            }
        }
        Commands::Hostname { name } => {
            set_hostname(&name)?;
        }
        Commands::Service { enable, disable, start, stop, restart, status, service } => {
            manage_service(enable, disable, start, stop, restart, status, &service)?;
        }
        Commands::ApplyAll => {
            apply_all_micro_settings()?;
        }
    }
    Ok(())
}

fn setup_zram(size: Option<String>, algorithm: Option<String>) -> Result<()> {
    let size = size.unwrap_or_else(|| "50%".to_string());
    let algorithm = algorithm.unwrap_or_else(|| "zstd".to_string());

    // Write zram-generator config
    let config = format!(
        r#"[zram0]
zram-size = "{}"
compression-algorithm = "{}"
"#,
        size, algorithm
    );

    fs::write("/etc/systemd/zram-generator.conf", config)?;
    println!("ZRAM configured: size={}, algorithm={}", size, algorithm);

    // Reload and start
    Command::new("systemctl").args(["daemon-reload"]).status()?;
    Command::new("systemctl").args(["restart", "systemd-zram-setup@zram0.service"]).status()?;

    println!("ZRAM enabled");
    Ok(())
}

fn disable_zram() -> Result<()> {
    Command::new("systemctl").args(["stop", "systemd-zram-setup@zram0.service"]).status()?;
    let _ = fs::remove_file("/etc/systemd/zram-generator.conf");
    Command::new("systemctl").args(["daemon-reload"]).status()?;
    println!("ZRAM disabled");
    Ok(())
}

fn set_hostname(name: &str) -> Result<()> {
    // Validate hostname
    if name.is_empty() || name.len() > 64 {
        anyhow::bail!("Invalid hostname: must be 1-64 characters");
    }
    if !name.chars().all(|c| c.is_alphanumeric() || c == '-' || c == '.') {
        anyhow::bail!("Invalid hostname: only alphanumeric, hyphen, and dot allowed");
    }

    Command::new("hostnamectl").args(["set-hostname", name]).status()?;
    println!("Hostname set to: {}", name);
    Ok(())
}

fn manage_service(enable: bool, disable: bool, start: bool, stop: bool, restart: bool, status: bool, service: &str) -> Result<()> {
    let mut cmd = Command::new("systemctl");

    if enable {
        cmd.args(["enable", "--now", service]);
    } else if disable {
        cmd.args(["disable", "--now", service]);
    } else if start {
        cmd.args(["start", service]);
    } else if stop {
        cmd.args(["stop", service]);
    } else if restart {
        cmd.args(["restart", service]);
    } else if status {
        cmd.args(["status", service]);
    } else {
        anyhow::bail!("Specify an action: --enable, --disable, --start, --stop, --restart, or --status");
    }

    let status = cmd.status()?;
    if !status.success() {
        anyhow::bail!("systemctl command failed");
    }
    Ok(())
}

fn apply_all_micro_settings() -> Result<()> {
    println!("Applying all micro settings...");

    // Enable zram
    setup_zram(None, None)?;

    // Set hostname if not set
    let hostname = fs::read_to_string("/etc/hostname").unwrap_or_default().trim().to_string();
    if hostname.is_empty() || hostname == "archlinux" {
        let new_hostname = format!("nexus-{}", get_random_suffix());
        set_hostname(&new_hostname)?;
    }

    // Enable essential services
    for svc in ["systemd-timesyncd", "systemd-resolved", "fstrim.timer"] {
        Command::new("systemctl").args(["enable", "--now", svc]).status()?;
    }

    println!("All micro settings applied");
    Ok(())
}

fn get_random_suffix() -> String {
    use std::time::{SystemTime, UNIX_EPOCH};
    let timestamp = SystemTime::now().duration_since(UNIX_EPOCH).unwrap().as_secs();
    format!("{:x}", timestamp)[..8].to_string()
}