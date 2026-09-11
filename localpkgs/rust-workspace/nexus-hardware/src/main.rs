use anyhow::Result;
use clap::Parser;
use serde::{Deserialize, Serialize};
use serde_json;
use std::process::Command;
use sysinfo::{Disks, Networks, System};

#[derive(Parser, Debug)]
#[command(name = "nexus-hardware", version, about = "Nexus Linux hardware detection")]
struct Args {
    /// Output as JSON
    #[arg(short, long)]
    json: bool,

    /// Show only specific component
    #[arg(short, long)]
    component: Option<String>,
}

#[derive(Serialize, Deserialize, Debug)]
struct HardwareInfo {
    cpu: CpuInfo,
    memory: MemoryInfo,
    disks: Vec<DiskInfo>,
    network: NetworkInfo,
    gpu: Option<GpuInfo>,
    audio: Option<AudioInfo>,
    usb: Vec<UsbDevice>,
    pci: Vec<PciDevice>,
}

#[derive(Serialize, Deserialize, Debug)]
struct CpuInfo {
    vendor: String,
    model: String,
    cores: usize,
    threads: usize,
    frequency_mhz: u64,
    cache_kb: Option<u64>,
    features: Vec<String>,
    temperature_celsius: Option<f32>,
}

#[derive(Serialize, Deserialize, Debug)]
struct MemoryInfo {
    total_mb: u64,
    available_mb: u64,
    speed_mhz: Option<u32>,
    modules: Vec<MemoryModule>,
}

#[derive(Serialize, Deserialize, Debug)]
struct MemoryModule {
    size_mb: u64,
    speed_mhz: Option<u32>,
    type_: String,
    manufacturer: String,
    part_number: String,
}

#[derive(Serialize, Deserialize, Debug)]
struct DiskInfo {
    name: String,
    model: String,
    serial: String,
    size_gb: f64,
    type_: String, // SSD, HDD, NVMe
    interface: String,
    smart_health: Option<String>,
    temperature_celsius: Option<u32>,
    partitions: Vec<PartitionInfo>,
}

#[derive(Serialize, Deserialize, Debug)]
struct PartitionInfo {
    name: String,
    mount_point: Option<String>,
    size_gb: f64,
    filesystem: String,
    label: Option<String>,
    uuid: Option<String>,
}

#[derive(Serialize, Deserialize, Debug)]
struct NetworkInfo {
    interfaces: Vec<NetworkInterface>,
}

#[derive(Serialize, Deserialize, Debug)]
struct NetworkInterface {
    name: String,
    mac: String,
    driver: String,
    speed_mbps: Option<u32>,
    duplex: Option<String>,
    ipv4: Vec<String>,
    ipv6: Vec<String>,
    state: String,
    mtu: u32,
}

#[derive(Serialize, Deserialize, Debug)]
struct GpuInfo {
    vendor: String,
    model: String,
    driver: String,
    vram_mb: Option<u64>,
    temperature_celsius: Option<u32>,
    utilization_percent: Option<u32>,
}

#[derive(Serialize, Deserialize, Debug)]
struct AudioInfo {
    cards: Vec<AudioCard>,
}

#[derive(Serialize, Deserialize, Debug)]
struct AudioCard {
    id: String,
    name: String,
    driver: String,
    outputs: Vec<AudioOutput>,
    inputs: Vec<AudioInput>,
}

#[derive(Serialize, Deserialize, Debug)]
struct AudioOutput {
    name: String,
    ports: Vec<String>,
}

#[derive(Serialize, Deserialize, Debug)]
struct AudioInput {
    name: String,
    ports: Vec<String>,
}

#[derive(Serialize, Deserialize, Debug)]
struct UsbDevice {
    bus: String,
    device: String,
    id: String,
    vendor: String,
    product: String,
    class: String,
    speed: String,
}

#[derive(Serialize, Deserialize, Debug)]
struct PciDevice {
    slot: String,
    class: String,
    vendor: String,
    device: String,
    driver: Option<String>,
}

fn main() -> Result<()> {
    let args = Args::parse();

    let mut sys = System::new_all();
    sys.refresh_all();

    let info = HardwareInfo {
        cpu: get_cpu_info(&sys),
        memory: get_memory_info(&sys),
        disks: get_disk_info(),
        network: get_network_info(),
        gpu: get_gpu_info(),
        audio: get_audio_info(),
        usb: get_usb_devices(),
        pci: get_pci_devices(),
    };

    if args.json {
        if let Some(comp) = args.component {
            match comp.as_str() {
                "cpu" => println!("{}", serde_json::to_string_pretty(&get_cpu_info(&System::new_all()))?),
                "memory" => println!("{}", serde_json::to_string_pretty(&get_memory_info(&System::new_all()))?),
                "disks" => println!("{}", serde_json::to_string_pretty(&get_disk_info())?),
                "network" => println!("{}", serde_json::to_string_pretty(&get_network_info())?),
                "gpu" => println!("{}", serde_json::to_string_pretty(&get_gpu_info())?),
                _ => println!("{}", serde_json::to_string_pretty(&info)?),
            }
        } else {
            println!("{}", serde_json::to_string_pretty(&info)?);
        }
    } else {
        print_pretty(&info);
    }

    Ok(())
}

fn get_cpu_info(sys: &System) -> CpuInfo {
    let cpus = sys.cpus();
    let first = cpus.first();

    let mut features = Vec::new();
    if let Ok(output) = Command::new("lscpu").output() {
        let out = String::from_utf8_lossy(&output.stdout);
        for line in out.lines() {
            if line.starts_with("Flags:") {
                features = line.split(':').nth(1).unwrap_or("").split_whitespace().map(|s| s.to_string()).collect();
                break;
            }
        }
    }

    CpuInfo {
        vendor: first.map(|c| c.vendor_id().to_string()).unwrap_or_else(|| "Unknown".to_string()),
        model: first.map(|c| c.brand().to_string()).unwrap_or_else(|| "Unknown".to_string()),
        cores: cpus.len(),
        threads: cpus.len(),
        frequency_mhz: first.map(|c| c.frequency()).unwrap_or(0),
        cache_kb: None,
        features,
        temperature_celsius: get_cpu_temp(),
    }
}

fn get_cpu_temp() -> Option<f32> {
    // Try to read from thermal zone
    for i in 0..10 {
        let path = format!("/sys/class/thermal/thermal_zone{}/temp", i);
        if let Ok(content) = std::fs::read_to_string(&path) {
            if let Ok(temp) = content.trim().parse::<i32>() {
                return Some(temp as f32 / 1000.0);
            }
        }
    }
    None
}

fn get_memory_info(sys: &System) -> MemoryInfo {
    let mut modules = Vec::new();
    // Try to read from dmidecode
    if let Ok(output) = Command::new("dmidecode").args(["-t", "memory"]).output() {
        let output_str = String::from_utf8_lossy(&output.stdout);
        // Parse dmidecode output for memory modules
        // Simplified parsing
    }

    MemoryInfo {
        total_mb: sys.total_memory() / 1024 / 1024,
        available_mb: sys.available_memory() / 1024 / 1024,
        speed_mhz: None,
        modules,
    }
}

fn get_disk_info() -> Vec<DiskInfo> {
    let disks = Disks::new_with_refreshed_list();
    disks.iter().filter_map(|disk| {
        let total = disk.total_space();
        if total == 0 { return None; }

        let name = disk.name().to_string_lossy().to_string();
        let model = String::new(); // Would need lsblk or smartctl
        let serial = String::new();
        let available = disk.available_space();

        // Determine type
        let is_rotational = is_rotational(&disk);
        let type_ = if is_rotational { "HDD" } else { "SSD" }.to_string();

        Some(DiskInfo {
            name,
            model,
            serial,
            size_gb: total as f64 / 1_073_741_824.0,
            type_,
            interface: String::new(),
            smart_health: None,
            temperature_celsius: None,
            partitions: get_partitions(&disk),
        })
    }).collect()
}

fn is_rotational(_disk: &sysinfo::Disk) -> bool {
    // Try to determine if rotational
    false
}

fn get_partitions(_disk: &sysinfo::Disk) -> Vec<PartitionInfo> {
    // Would need to parse /proc/partitions or use lsblk
    Vec::new()
}

fn get_network_info() -> NetworkInfo {
    let networks = Networks::new_with_refreshed_list();
    let mut interfaces = Vec::new();

    for (name, data) in networks.iter() {
        let mut ipv4 = Vec::new();
        let mut ipv6 = Vec::new();

        // sysinfo 0.30 has no IP networks API - leave empty
        let _ = &data;
        interfaces.push(NetworkInterface {
            name: name.to_string(),
            mac: data.mac_address().to_string(),
            driver: String::new(),
            speed_mbps: None,
            duplex: None,
            ipv4,
            ipv6,
            state: if data.received() > 0 || data.transmitted() > 0 { "up" } else { "down" }.to_string(),
            mtu: 1500,
        });
    }

    NetworkInfo { interfaces }
}

fn get_gpu_info() -> Option<GpuInfo> {
    let output = Command::new("lspci").args(["-nn"]).output().ok()?;
    let output_str = String::from_utf8_lossy(&output.stdout);

    for line in output_str.lines() {
        let lower = line.to_lowercase();
        if lower.contains("vga") || lower.contains("3d") || lower.contains("display") {
            return Some(GpuInfo {
                vendor: extract_vendor(&line),
                model: line.trim().to_string(),
                driver: get_gpu_driver(&line),
                vram_mb: None,
                temperature_celsius: None,
                utilization_percent: None,
            });
        }
    }
    None
}

fn extract_vendor(line: &str) -> String {
    if line.contains("[10de:]") { "NVIDIA".to_string() }
    else if line.contains("[1002:]") { "AMD".to_string() }
    else if line.contains("[8086:]") { "Intel".to_string() }
    else { "Unknown".to_string() }
}

fn get_gpu_driver(_line: &str) -> String {
    // Would need to check kernel modules
    "Unknown".to_string()
}

fn get_audio_info() -> Option<AudioInfo> {
    // Would need to parse /proc/asound/cards
    None
}

fn get_usb_devices() -> Vec<UsbDevice> {
    let mut devices = Vec::new();
    if let Ok(output) = Command::new("lsusb").output() {
        let output_str = String::from_utf8_lossy(&output.stdout);
        for line in output_str.lines() {
            // Parse lsusb output
            // Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
            let parts: Vec<&str> = line.split_whitespace().collect();
            if parts.len() >= 6 {
                devices.push(UsbDevice {
                    bus: parts[1].trim_end_matches(':').to_string(),
                    device: parts[3].trim_end_matches(':').to_string(),
                    id: parts[5].to_string(),
                    vendor: parts[6..].join(" "),
                    product: String::new(),
                    class: String::new(),
                    speed: String::new(),
                });
            }
        }
    }
    devices
}

fn get_pci_devices() -> Vec<PciDevice> {
    let mut devices = Vec::new();
    if let Ok(output) = Command::new("lspci").args(["-nn"]).output() {
        let output_str = String::from_utf8_lossy(&output.stdout);
        for line in output_str.lines() {
            // Parse lspci output
            // 00:00.0 Host bridge [0600]: Intel Corporation [8086:1234]
            if let Some(idx) = line.find('[') {
                let class = &line[idx+1..idx+5];
                let rest = &line[idx+6..];
                let parts: Vec<&str> = rest.split(']').collect();
                if parts.len() >= 2 {
                    let vendor_device = parts[0].trim();
                    let _desc = parts[1].trim();
                    let slot = &line[..7];

                    devices.push(PciDevice {
                        slot: slot.to_string(),
                        class: class.to_string(),
                        vendor: vendor_device.split(':').next().unwrap_or("").to_string(),
                        device: vendor_device.split(':').nth(1).unwrap_or("").to_string(),
                        driver: None,
                    });
                }
            }
        }
    }
    devices
}

fn print_pretty(info: &HardwareInfo) {
    println!("\n=== Nexus Linux Hardware Info ===");
    println!("\nCPU:");
    println!("  Vendor: {}", info.cpu.vendor);
    println!("  Model:  {}", info.cpu.model);
    println!("  Cores:  {}", info.cpu.cores);
    println!("  Threads: {}", info.cpu.threads);
    println!("  Freq:   {} MHz", info.cpu.frequency_mhz);
    if let Some(temp) = info.cpu.temperature_celsius {
        println!("  Temp:   {:.1}°C", temp);
    }

    println!("\nMemory:");
    println!("  Total:     {} MB", info.memory.total_mb);
    println!("  Available: {} MB", info.memory.available_mb);

    println!("\nDisks:");
    for disk in &info.disks {
        println!("  {}: {:.1} GB ({})", disk.name, disk.size_gb, disk.type_);
    }

    println!("\nNetwork:");
    for iface in &info.network.interfaces {
        println!("  {}: {}", iface.name, iface.mac);
        for ip in &iface.ipv4 {
            println!("    IPv4: {}", ip);
        }
        for ip in &iface.ipv6 {
            println!("    IPv6: {}", ip);
        }
    }

    if let Some(gpu) = &info.gpu {
        println!("\nGPU:");
        println!("  Vendor: {}", gpu.vendor);
        println!("  Model:  {}", gpu.model);
    }
}
