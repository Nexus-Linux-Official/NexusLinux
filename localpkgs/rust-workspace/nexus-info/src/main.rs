use anyhow::Result;
use clap::Parser;
use colored::*;
use serde::Serialize;
use std::process::Command;
use sysinfo::{Disks, Networks, System};

#[derive(Parser, Debug)]
#[command(name = "nexus-info", version, about = "Nexus Linux System Information")]
struct Args {
    /// Output as JSON
    #[arg(short, long)]
    json: bool,

    /// Show only specific section
    #[arg(short, long)]
    section: Option<String>,
}

#[derive(Serialize)]
struct SystemInfo {
    hostname: String,
    os: OsInfo,
    cpu: CpuInfo,
    memory: MemoryInfo,
    disks: Vec<DiskInfo>,
    network: NetworkInfo,
    gpu: Option<GpuInfo>,
}

#[derive(Serialize)]
struct OsInfo {
    name: String,
    version: String,
    kernel: String,
    arch: String,
}

#[derive(Serialize)]
struct CpuInfo {
    brand: String,
    cores: usize,
    threads: usize,
    frequency_mhz: u64,
}

#[derive(Serialize)]
struct MemoryInfo {
    total_mb: u64,
    available_mb: u64,
    used_mb: u64,
    swap_total_mb: u64,
    swap_used_mb: u64,
}

#[derive(Serialize)]
struct DiskInfo {
    mount_point: String,
    filesystem: String,
    total_gb: f64,
    available_gb: f64,
    used_percent: f64,
}

#[derive(Serialize)]
struct NetworkInfo {
    interfaces: Vec<NetworkInterface>,
}

#[derive(Serialize)]
struct NetworkInterface {
    name: String,
    mac: String,
    ipv4: Vec<String>,
    ipv6: Vec<String>,
    speed_mbps: Option<u64>,
}

#[derive(Serialize)]
struct GpuInfo {
    vendor: String,
    model: String,
    driver: String,
    vram_mb: Option<u64>,
}

fn main() -> Result<()> {
    let args = Args::parse();

    let mut sys = System::new_all();
    sys.refresh_all();

    let info = SystemInfo {
        hostname: System::host_name().unwrap_or_else(|| "unknown".to_string()),
        os: get_os_info(),
        cpu: get_cpu_info(&sys),
        memory: get_memory_info(&sys),
        disks: get_disk_info(),
        network: get_network_info(),
        gpu: get_gpu_info(),
    };

    if args.json {
        println!("{}", serde_json::to_string_pretty(&info)?);
    } else {
        print_pretty(&info);
    }

    Ok(())
}

fn get_os_info() -> OsInfo {
    let mut sys = System::new_all();
    sys.refresh_all();

    OsInfo {
        name: System::name().unwrap_or_else(|| "Nexus Linux".to_string()),
        version: System::os_version().unwrap_or_else(|| "rolling".to_string()),
        kernel: System::kernel_version().unwrap_or_else(|| "unknown".to_string()),
        arch: std::env::consts::ARCH.to_string(),
    }
}

fn get_cpu_info(sys: &System) -> CpuInfo {
    let cpus = sys.cpus();
    let first_cpu = cpus.first();

    CpuInfo {
        brand: first_cpu.map(|c| c.brand().to_string()).unwrap_or_else(|| "Unknown".to_string()),
        cores: cpus.len(),
        threads: cpus.len(), // Simplified - real thread count needs more work
        frequency_mhz: first_cpu.map(|c| c.frequency()).unwrap_or(0),
    }
}

fn get_memory_info(sys: &System) -> MemoryInfo {
    MemoryInfo {
        total_mb: sys.total_memory() / 1024 / 1024,
        available_mb: sys.available_memory() / 1024 / 1024,
        used_mb: (sys.total_memory() - sys.available_memory()) / 1024 / 1024,
        swap_total_mb: sys.total_swap() / 1024 / 1024,
        swap_used_mb: (sys.total_swap() - sys.free_swap()) / 1024 / 1024,
    }
}

fn get_disk_info() -> Vec<DiskInfo> {
    let disks = Disks::new_with_refreshed_list();
    disks
        .iter()
        .filter_map(|disk| {
            let total = disk.total_space();
            let available = disk.available_space();
            if total == 0 {
                return None;
            }
            let used = total - available;
            Some(DiskInfo {
                mount_point: disk.mount_point().to_string_lossy().to_string(),
                filesystem: disk.file_system().to_string_lossy().to_string(),
                total_gb: total as f64 / 1_073_741_824.0,
                available_gb: available as f64 / 1_073_741_824.0,
                used_percent: (used as f64 / total as f64) * 100.0,
            })
        })
        .collect()
}

fn get_network_info() -> NetworkInfo {
    let networks = Networks::new_with_refreshed_list();
    let mut interfaces = Vec::new();

    for (name, data) in networks.iter() {
        let mut ipv4 = Vec::new();
        let mut ipv6 = Vec::new();

        // sysinfo 0.30 has no IP networks API - leave empty
        let _ = &data;

        let mac = data.mac_address().to_string();

        interfaces.push(NetworkInterface {
            name: name.to_string(),
            mac,
            ipv4,
            ipv6,
            speed_mbps: None, // Would need ethtool or similar
        });
    }

    NetworkInfo { interfaces }
}

fn get_gpu_info() -> Option<GpuInfo> {
    // Try to get GPU info from lspci
    let output = Command::new("lspci").args(["-nn"]).output().ok()?;
    let output_str = String::from_utf8_lossy(&output.stdout);

    for line in output_str.lines() {
        if line.to_lowercase().contains("vga") || line.to_lowercase().contains("3d") || line.to_lowercase().contains("display") {
            return Some(GpuInfo {
                vendor: "Unknown".to_string(),
                model: line.trim().to_string(),
                driver: "Unknown".to_string(),
                vram_mb: None,
            });
        }
    }

    None
}

fn print_pretty(info: &SystemInfo) {
    println!("{}", "╔══════════════════════════════════════════╗".bright_blue());
    println!("{}", "║         Nexus Linux System Info           ║".bright_blue().bold());
    println!("{}", "╚══════════════════════════════════════════╝".bright_blue());

    println!("\n{}", "🖥️  System".bright_green().bold());
    println!("  Hostname: {}", info.hostname.bright_cyan());
    println!("  OS:       {} {}", info.os.name.bright_cyan(), info.os.version);
    println!("  Kernel:   {}", info.os.kernel.bright_cyan());
    println!("  Arch:     {}", info.os.arch.bright_cyan());

    println!("\n{}", "🧠 CPU".bright_green().bold());
    println!("  Model:    {}", info.cpu.brand.bright_cyan());
    println!("  Cores:    {}", info.cpu.cores.to_string().bright_cyan());
    println!("  Threads:  {}", info.cpu.threads.to_string().bright_cyan());
    println!("  Frequency: {} MHz", info.cpu.frequency_mhz.to_string().bright_cyan());

    println!("\n{}", "💾 Memory".bright_green().bold());
    println!("  Total:     {} MB", info.memory.total_mb.to_string().bright_cyan());
    println!("  Available: {} MB", info.memory.available_mb.to_string().bright_cyan());
    println!("  Used:      {} MB", info.memory.used_mb.to_string().bright_cyan());
    println!("  Swap:      {} MB / {} MB", info.memory.swap_used_mb, info.memory.swap_total_mb);

    println!("\n{}", "💽 Disks".bright_green().bold());
    for disk in &info.disks {
        println!("  {} ({})", disk.mount_point.bright_cyan(), disk.filesystem);
        println!("    Total: {:.1} GB  Available: {:.1} GB  Used: {:.1}%",
                 disk.total_gb, disk.available_gb, disk.used_percent);
    }

    println!("\n{}", "🌐 Network".bright_green().bold());
    for iface in &info.network.interfaces {
        println!("  {} ({})", iface.name.bright_cyan(), iface.mac);
        for ip in &iface.ipv4 {
            println!("    IPv4: {}", ip.bright_cyan());
        }
        for ip in &iface.ipv6 {
            println!("    IPv6: {}", ip.bright_cyan());
        }
    }

    if let Some(gpu) = &info.gpu {
        println!("\n{}", "🎮 GPU".bright_green().bold());
        println!("  Model:  {}", gpu.model.bright_cyan());
        println!("  Driver: {}", gpu.driver.bright_cyan());
        if let Some(vram) = gpu.vram_mb {
            println!("  VRAM:   {} MB", vram.to_string().bright_cyan());
        }
    }

    println!("\n{}", "Nexus Linux - Pure Arch Based".bright_blue());
}
