use anyhow::Result;
use clap::{Parser, Subcommand};
use colored::*;
use image::{Rgb, RgbImage};
use std::path::PathBuf;

#[derive(Parser, Debug)]
#[command(name = "nexus-theme", version, about = "Nexus Linux theme and wallpaper utilities")]
struct Args {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand, Debug)]
enum Commands {
    /// Set wallpaper
    SetWallpaper {
        path: PathBuf,
        #[arg(short, long)]
        monitor: Option<String>,
    },
    /// Generate default wallpaper
    Generate {
        #[arg(short, long)]
        output: PathBuf,
        #[arg(long)]
        width: u32,
        #[arg(long)]
        height: u32,
    },
    /// Apply theme
    Apply {
        #[arg(short, long)]
        theme: String,
    },
    /// List available themes
    List,
}

fn main() -> Result<()> {
    let args = Args::parse();

    match args.command {
        Commands::SetWallpaper { path, monitor } => {
            set_wallpaper(&path, monitor)?;
        }
        Commands::Generate { output, width, height } => {
            generate_wallpaper(&output, width, height)?;
        }
        Commands::Apply { theme } => {
            apply_theme(&theme)?;
        }
        Commands::List => {
            list_themes()?;
        }
    }
    Ok(())
}

fn set_wallpaper(path: &PathBuf, monitor: Option<String>) -> Result<()> {
    if !path.exists() {
        anyhow::bail!("Wallpaper file not found: {}", path.display());
    }

    // For KDE Plasma - use direct dbus-send invocation to avoid shell injection
    let script = if let Some(m) = monitor {
        format!("var wallpaper = \"{}\"; var monitors = [\"{}\"];", path.display(), m)
    } else {
        format!("var wallpaper = \"{}\";", path.display())
    };

    std::process::Command::new("dbus-send")
        .args([
            "--session",
            "--dest=org.kde.plasmashell",
            "--type=method_call",
            "/PlasmaShell",
            "org.kde.PlasmaShell.evaluateScript",
            &format!("string:{}", script),
        ])
        .status()?;

    println!("Wallpaper set to: {}", path.display());
    Ok(())
}

fn generate_wallpaper(output: &PathBuf, width: u32, height: u32) -> Result<()> {
    if width == 0 || height == 0 {
        anyhow::bail!("width and height must be non-zero");
    }
    let mut img = RgbImage::new(width, height);

    // Create gradient background
    for y in 0..height {
        for x in 0..width {
            let r = (0x1a as f32 + (0x0f as f32 - 0x1a as f32) * y as f32 / height as f32) as u8;
            let g = (0x1a as f32 + (0x0f as f32 - 0x1a as f32) * y as f32 / height as f32) as u8;
            let b = (0x2e as f32 + (0x1a as f32 - 0x2e as f32) * y as f32 / height as f32) as u8;
            img.put_pixel(x, y, Rgb([r, g, b]));
        }
    }

    // Draw circle
    let cx = width / 2;
    let cy = height / 2;
    let radius = (width.min(height) as f32 * 0.15) as u32;

    for y in cy.saturating_sub(radius)..=(cy + radius).min(height - 1) {
        for x in cx.saturating_sub(radius)..=(cx + radius).min(width - 1) {
            let dx = x as i32 - cx as i32;
            let dy = y as i32 - cy as i32;
            if (dx * dx + dy * dy) as u32 <= radius * radius {
                img.put_pixel(x, y, Rgb([0x17, 0x93, 0xd1]));
            }
        }
    }

    // Add text would require font rendering - simplified

    if let Some(parent) = output.parent() {
        std::fs::create_dir_all(parent)?;
    }
    img.save(output)?;
    println!("Wallpaper generated: {}", output.display());
    Ok(())
}

fn apply_theme(theme: &str) -> Result<()> {
    // Apply theme using lookandfeeltool
    let status = std::process::Command::new("lookandfeeltool")
        .args(["-a", theme])
        .status()?;

    if status.success() {
        println!("Theme '{}' applied", theme);
    } else {
        anyhow::bail!("Failed to apply theme '{}'", theme);
    }
    Ok(())
}

fn list_themes() -> Result<()> {
    let theme_dirs = [
        "/usr/share/plasma/look-and-feel/",
        "/usr/share/themes/",
        "/home/.local/share/plasma/look-and-feel/",
    ];

    for dir in theme_dirs {
        if let Ok(entries) = std::fs::read_dir(dir) {
            for entry in entries.flatten() {
                let name = entry.file_name().to_string_lossy().to_string();
                if name.starts_with(".") { continue; }
                println!("{} ({})", name.bright_cyan(), dir.dimmed());
            }
        }
    }
    Ok(())
}