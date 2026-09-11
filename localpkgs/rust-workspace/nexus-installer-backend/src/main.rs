use anyhow::Result;
use clap::{Parser, Subcommand};

#[derive(Parser, Debug)]
#[command(name = "nexus-installer", version, about = "Nexus Linux package installer backend")]
struct Args {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand, Debug)]
enum Commands {
    Install { packages: Vec<String> },
    Remove { packages: Vec<String> },
    Update,
    Search { query: String },
}

fn main() -> Result<()> {
    let _args = Args::parse();
    println!("nexus-installer backend placeholder - alpm API update pending");
    Ok(())
}
