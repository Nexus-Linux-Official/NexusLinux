use anyhow::Result;
use clap::Parser;
use colored::*;
use indicatif::{ProgressBar, ProgressStyle};
use serde::Serialize;
use std::process::Command;
use std::time::Duration;
use sysinfo::{Disks, System};

#[derive(Parser, Debug)]
#[command(name = "nexus-check", version, about = "Nexus Linux system health check")]
struct Args {
    /// Output as JSON
    #[arg(short, long)]
    json: bool,

    /// Verbose output
    #[arg(short, long)]
    verbose: bool,

    /// Skip network checks
    #[arg(long)]
    no_network: bool,

    /// Skip disk checks
    #[arg(long)]
    no_disk: bool,
}

#[derive(Debug, Clone, Serialize)]
enum CheckStatus {
    Pass,
    Warn(String),
    Fail(String),
}

#[derive(Debug, Clone, Serialize)]
struct CheckResult {
    name: String,
    status: CheckStatus,
    message: String,
}

fn main() -> Result<()> {
    let args = Args::parse();

    let pb = ProgressBar::new(8);
    pb.set_style(ProgressStyle::default_bar()
        .template("{spinner:.green} [{elapsed_precise}] [{bar:40.cyan/blue}] {pos}/{len} {msg}")
        .unwrap()
        .progress_chars("#>-"));

    let mut results = Vec::new();

    // System checks
    pb.set_message("Checking system health...");
    results.push(check_os());
    pb.inc(1);

    pb.set_message("Checking kernel...");
    results.push(check_kernel());
    pb.inc(1);

    pb.set_message("Checking memory...");
    results.push(check_memory());
    pb.inc(1);

    pb.set_message("Checking disk space...");
    if !args.no_disk {
        results.push(check_disk_space());
    } else {
        results.push(CheckResult { name: "Disk Space".into(), status: CheckStatus::Pass, message: "Skipped".into() });
    }
    pb.inc(1);

    pb.set_message("Checking network...");
    if !args.no_network {
        results.push(check_network());
    } else {
        results.push(CheckResult { name: "Network".into(), status: CheckStatus::Pass, message: "Skipped".into() });
    }
    pb.inc(1);

    pb.set_message("Checking services...");
    results.push(check_services());
    pb.inc(1);

    pb.set_message("Checking updates...");
    results.push(check_updates());
    pb.inc(1);

    pb.set_message("Checking security...");
    results.push(check_security());
    pb.inc(1);

    pb.finish_with_message("Health check complete!");

    // Output results
    if Args::parse().json {
        output_json(&results)?;
    } else {
        output_pretty(&results, args.verbose);
    }

    // Exit with error code if any failures
    if results.iter().any(|r| matches!(r.status, CheckStatus::Fail(_))) {
        std::process::exit(1);
    }

    Ok(())
}

fn check_os() -> CheckResult {
    let output = std::process::Command::new("cat").arg("/etc/os-release").output();
    match output {
        Ok(out) if out.status.success() => {
            let content = String::from_utf8_lossy(&out.stdout);
            if content.contains("Nexus Linux") {
                CheckResult { name: "OS".into(), status: CheckStatus::Pass, message: "Nexus Linux detected".into() }
            } else {
                CheckResult { name: "OS".into(), status: CheckStatus::Warn("Not Nexus Linux".into()), message: "Running on different distro".into() }
            }
        }
        _ => CheckResult { name: "OS".into(), status: CheckStatus::Fail("Cannot read /etc/os-release".into()), message: "Failed to read OS info".into() },
    }
}

fn check_kernel() -> CheckResult {
    let output = std::process::Command::new("uname").arg("-r").output();
    match output {
        Ok(out) if out.status.success() => {
            let kernel = String::from_utf8_lossy(&out.stdout).trim().to_string();
            // Check if it's a zen kernel
            if kernel.contains("zen") {
                CheckResult { name: "Kernel".into(), status: CheckStatus::Pass, message: format!("Linux {} (Zen)", kernel) }
            } else {
                CheckResult { name: "Kernel".into(), status: CheckStatus::Warn("Not Zen kernel".into()), message: format!("Running: {}", kernel) }
            }
        }
        _ => CheckResult { name: "Kernel".into(), status: CheckStatus::Fail("Cannot get kernel version".into()), message: "uname failed".into() },
    }
}

fn check_memory() -> CheckResult {
    let mut sys = System::new_all();
    sys.refresh_memory();

    let available = sys.available_memory();
    let total = sys.total_memory();
    let percent = (available as f64 / total as f64) * 100.0;

    if percent < 10.0 {
        CheckResult { name: "Memory".into(), status: CheckStatus::Fail("Low memory".into()), message: format!("{:.1}% available", percent) }
    } else if percent < 20.0 {
        CheckResult { name: "Memory".into(), status: CheckStatus::Warn("Low memory".into()), message: format!("{:.1}% available", percent) }
    } else {
        CheckResult { name: "Memory".into(), status: CheckStatus::Pass, message: format!("{:.1}% available", percent) }
    }
}

fn check_disk_space() -> CheckResult {
    let disks = Disks::new_with_refreshed_list();
    let mut worst = CheckStatus::Pass;
    let mut worst_msg = String::new();

    for disk in disks.iter() {
        let total = disk.total_space();
        let available = disk.available_space();
        if total > 0 {
            let used_percent = ((total - available) as f64 / total as f64) * 100.0;
            let mount = disk.mount_point().to_string_lossy();

            if used_percent > 95.0 {
                if matches!(worst, CheckStatus::Pass) || matches!(worst, CheckStatus::Warn(_)) {
                    worst = CheckStatus::Fail(format!("{} at {:.1}%", disk.mount_point().to_string_lossy(), used_percent));
                    worst_msg = format!("{} critically full ({:.1}%)", mount, used_percent);
                }
            } else if used_percent > 85.0 && matches!(worst, CheckStatus::Pass) {
                worst = CheckStatus::Warn(format!("{} at {:.1}%", disk.mount_point().to_string_lossy(), used_percent));
                worst_msg = format!("{} nearly full ({:.1}%)", mount, used_percent);
            }
        }
    }

    match worst {
        CheckStatus::Pass => CheckResult { name: "Disk Space".into(), status: CheckStatus::Pass, message: "All disks have sufficient space".into() },
        CheckStatus::Warn(msg) => CheckResult { name: "Disk Space".into(), status: CheckStatus::Warn(msg.clone()), message: msg },
        CheckStatus::Fail(msg) => CheckResult { name: "Disk Space".into(), status: CheckStatus::Fail(msg.clone()), message: msg },
    }
}

fn check_network() -> CheckResult {
    // Check if we have a default route
    let output = std::process::Command::new("ip").args(["route", "show", "default"]).output();
    match output {
        Ok(out) if out.status.success() && !out.stdout.is_empty() => {
            CheckResult { name: "Network".into(), status: CheckStatus::Pass, message: "Default route exists".into() }
        }
        _ => CheckResult { name: "Network".into(), status: CheckStatus::Fail("No default route".into()), message: "No internet connectivity".into() },
    }
}

fn check_services() -> CheckResult {
    // Check critical services
    let critical = ["systemd-journald", "systemd-logind", "NetworkManager", "dbus"];
    let mut failed = Vec::new();

    for svc in critical {
        let output = std::process::Command::new("systemctl").args(["is-active", svc]).output();
        if let Ok(out) = output {
            if !out.status.success() || String::from_utf8_lossy(&out.stdout).trim() != "active" {
                failed.push(svc);
            }
        }
    }

    if failed.is_empty() {
        CheckResult { name: "Services".into(), status: CheckStatus::Pass, message: "All critical services active".into() }
    } else {
        CheckResult { name: "Services".into(), status: CheckStatus::Fail("Inactive services".into()), message: format!("Inactive: {}", failed.join(", ")) }
    }
}

fn check_updates() -> CheckResult {
    let output = std::process::Command::new("checkupdates").output();
    match output {
        Ok(out) => {
            let count = String::from_utf8_lossy(&out.stdout).lines().count();
            if count == 0 {
                CheckResult { name: "Updates".into(), status: CheckStatus::Pass, message: "System is up to date".into() }
            } else if count < 50 {
                CheckResult { name: "Updates".into(), status: CheckStatus::Warn(format!("{} updates available", count)), message: format!("{} packages can be updated", count) }
            } else {
                CheckResult { name: "Updates".into(), status: CheckStatus::Warn(format!("{} updates available", count)), message: format!("Many updates ({})", count) }
            }
        }
        _ => CheckResult { name: "Updates".into(), status: CheckStatus::Warn("Cannot check".into()), message: "checkupdates failed".into() },
    }
}

fn check_security() -> CheckResult {
    // Check for basic security settings
    let mut issues = Vec::new();

    // Check if root login is disabled
    if let Ok(content) = std::fs::read_to_string("/etc/ssh/sshd_config") {
        if content.contains("PermitRootLogin yes") {
            issues.push("SSH root login enabled");
        }
    }

    // Check if firewall is active
    let output = std::process::Command::new("systemctl").args(["is-active", "ufw"]).output();
    if output.is_err() || !output.unwrap().status.success() {
        let output = std::process::Command::new("systemctl").args(["is-active", "firewalld"]).output();
        if output.is_err() || !output.unwrap().status.success() {
            issues.push("No firewall active (ufw/firewalld)");
        }
    }

    if issues.is_empty() {
        CheckResult { name: "Security".into(), status: CheckStatus::Pass, message: "Basic security checks passed".into() }
    } else {
        CheckResult { name: "Security".into(), status: CheckStatus::Warn("Security issues found".into()), message: issues.join("; ") }
    }
}

fn output_json(results: &[CheckResult]) -> Result<()> {
    let json = serde_json::to_string_pretty(results)?;
    println!("{}", json);
    Ok(())
}

fn output_pretty(results: &[CheckResult], verbose: bool) {
    println!("\n{}", "╔═══════════════════════════════════════════╗".bright_blue());
    println!("{}", "║       Nexus Linux Health Check            ║".bright_blue().bold());
    println!("{}", "╚══════════════════════════════════════════╝".bright_blue());

    let mut pass = 0;
    let mut warn = 0;
    let mut fail = 0;

    for result in results {
        match &result.status {
            CheckStatus::Pass => {
                println!("  {} {}", "✓".bright_green(), result.name.bright_cyan());
                if verbose {
                    println!("    {}", result.message.bright_green());
                }
                pass += 1;
            }
            CheckStatus::Warn(msg) => {
                println!("  {} {} ({})", "⚠".bright_yellow(), result.name.bright_cyan(), msg.bright_yellow());
                if verbose {
                    println!("    {}", result.message.bright_yellow());
                }
                warn += 1;
            }
            CheckStatus::Fail(msg) => {
                println!("  {} {} ({})", "✗".bright_red(), result.name.bright_cyan(), msg.bright_red());
                println!("    {}", result.message.bright_red());
                fail += 1;
            }
        }
    }

    println!("\n{}", "────────────────────────────────────────────".bright_blue());
    println!("  {} {}  {} {}  {} {}", 
        "✓".bright_green(), pass.to_string().bright_green(),
        "⚠".bright_yellow(), warn.to_string().bright_yellow(),
        "✗".bright_red(), fail.to_string().bright_red());

    if fail > 0 {
        println!("\n{}", "⚠ Some checks failed!".bright_red().bold());
    } else if warn > 0 {
        println!("\n{}", "⚠ Some warnings present".bright_yellow().bold());
    } else {
        println!("\n{}", "✓ All checks passed!".bright_green().bold());
    }
}
