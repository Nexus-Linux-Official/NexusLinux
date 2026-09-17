<div align="center">

<img src="readme-banner.svg" alt="Nexus Linux" width="900">

# Nexus Linux

### A modern Linux distribution built on pure Arch Linux.

<p>
  <img src="https://img.shields.io/github/v/release/Nexus-Linux-Official/NexusLinux?style=for-the-badge&label=Release" alt="Release">
  <img src="https://img.shields.io/github/license/Nexus-Linux-Official/NexusLinux?style=for-the-badge" alt="License">
  <img src="https://img.shields.io/github/issues/Nexus-Linux-Official/NexusLinux?style=for-the-badge" alt="Issues">
  <img src="https://img.shields.io/github/commit-activity/m/Nexus-Linux-Official/NexusLinux?style=for-the-badge" alt="Commit Activity">
  <img src="https://img.shields.io/github/stars/Nexus-Linux-Official/NexusLinux?style=for-the-badge" alt="Stars">
  <img src="https://img.shields.io/github/forks/Nexus-Linux-Official/NexusLinux?style=for-the-badge" alt="Forks">
  <img src="https://img.shields.io/github/issues-pr/Nexus-Linux-Official/NexusLinux?style=for-the-badge" alt="Pull Requests">
  <img src="https://img.shields.io/github/last-commit/Nexus-Linux-Official/NexusLinux?style=for-the-badge" alt="Last Commit">
</p>

**Pure Arch · KDE Plasma · Calamares · Rust · Zig · Native Tools**

Nexus Linux is an independent Linux distribution built on the Arch Linux ecosystem,
designed around a clean desktop experience, straightforward installation,
native system tooling, and a maintainable distribution architecture.

</div>

---

## ✨ Overview

Nexus Linux is built directly on **Arch Linux** using the official `archiso`
infrastructure.

The project adds a complete Nexus-specific layer around the Arch foundation,
including:

* KDE Plasma desktop integration
* Nexus-branded system configuration
* Graphical Calamares installation
* Online and offline installation support
* A dedicated Nexus package repository
* Signed Nexus packages and repository metadata
* Native Rust system utilities
* Zig development support
* Hardware detection and system-health tooling
* Nexus KDE defaults
* Nexus wallpapers and branding
* Custom boot and installer integration
* Automated ISO and package build infrastructure

The repository contains the live ISO configuration, Nexus package sources,
Rust workspace, build tooling, testing infrastructure, and release tooling.

---

## 🎯 Project Goals

Nexus Linux focuses on a few core principles:

| Goal            | Nexus approach                              |
| --------------- | ------------------------------------------- |
| Base            | Arch Linux                                  |
| ISO builder     | `archiso`                                   |
| Package manager | `pacman`                                    |
| Nexus packages  | Dedicated `[nexus]` repository              |
| Desktop         | KDE Plasma                                  |
| Installer       | Calamares                                   |
| System tooling  | Rust + Zig                                  |
| Package signing | GPG                                         |
| Build system    | Bash + Arch packaging + Rust                |
| Security        | Signed packages and controlled repositories |
| Development     | Open-source and community-oriented          |

Nexus aims to keep the underlying Arch ecosystem familiar while providing
a more integrated distribution experience.

---

# 🖥️ Desktop Experience

## KDE Plasma

KDE Plasma is the primary Nexus Linux desktop environment.

Nexus provides its own Plasma configuration through:

```text
localpkgs/nexus-kde-settings/
```

This package provides Nexus-specific defaults for components such as:

* KDE global configuration
* Plasma configuration
* KWin configuration
* Desktop defaults
* Nexus visual integration

Nexus wallpapers are maintained separately through:

```text
localpkgs/nexus-wallpapers/
```

---

## Desktop Options

The installer currently supports multiple desktop configurations:

| Desktop        | Availability |
| -------------- | ------------ |
| **KDE Plasma** | Primary      |
| GNOME          | Available    |
| COSMIC         | Available    |
| Cinnamon       | Available    |

The desktop selection is integrated into the Nexus installation workflow.

---

# 💿 Installation

Nexus Linux uses **Calamares** as its graphical installer.

The project provides both online and offline installation paths.

```text
                 Nexus Linux ISO
                       │
                       ▼
                Live KDE Plasma
                       │
                       ▼
                  Calamares
                       │
              ┌────────┴────────┐
              │                 │
          Online             Offline
              │                 │
              └────────┬────────┘
                       ▼
                Install System
                       │
                       ▼
                Nexus Linux
```

The Nexus Calamares integration is maintained under:

```text
localpkgs/nexus-calamares/
```

The project also builds Calamares from source as part of the ISO build
process.

---

# 🏗️ Architecture

Nexus Linux can be viewed as several layers built on top of one another:

```text
┌─────────────────────────────────────────┐
│              Nexus Linux                │
├─────────────────────────────────────────┤
│ KDE Plasma · Calamares · Nexus Tools    │
├─────────────────────────────────────────┤
│ Nexus Packages · Nexus Repository       │
├─────────────────────────────────────────┤
│ pacman · Arch Packaging · systemd       │
├─────────────────────────────────────────┤
│              Arch Linux                  │
└─────────────────────────────────────────┘
```

The distribution itself is assembled using the Arch Linux packaging
ecosystem and `archiso`.

Archiso provides the ISO-generation infrastructure, while Nexus maintains
the distribution-specific profile, packages, configuration, and tooling.

---

# 📦 Nexus Package Repository

Nexus Linux maintains its own package repository:

```ini
[nexus]
```

The repository is used for Nexus-specific packages rather than replacing
the standard Arch package ecosystem.

The build system generates the repository database using `repo-add` and
integrates it into the ISO's package configuration.

Nexus packages include:

| Package              | Purpose                                       |
| -------------------- | --------------------------------------------- |
| `nexus-branding`     | Nexus OS identity and release information     |
| `nexus-wallpapers`   | Nexus wallpapers and desktop defaults         |
| `nexus-keyring`      | Nexus package signing keys                    |
| `nexus-calamares`    | Calamares modules, configuration and branding |
| `nexus-kde-settings` | KDE Plasma defaults                           |
| `nexus-rust-tools`   | Nexus native Rust utilities                   |

---

# 🦀 Rust System Tooling

Nexus includes a dedicated Rust workspace containing **8 native CLI tools**.

### Tools

| Binary            | Purpose                          |
| ----------------- | -------------------------------- |
| `nexus-info`      | System information               |
| `nexus-version`   | Nexus version information        |
| `nexus-check`     | System health checks             |
| `nexus-hardware`  | Hardware detection               |
| `nexus-micro`     | Lightweight system configuration |
| `nexus-installer` | Package installation backend     |
| `nexus-theme`     | Theme and wallpaper utilities    |
| `nexus-build`     | Build and ISO helpers            |

The workspace is located at:

```text
localpkgs/rust-workspace/
```

The workspace contains:

```text
nexus-info
nexus-version
nexus-check
nexus-hardware
nexus-micro
nexus-installer-backend
nexus-theme
nexus-build-helpers
```

It is built as a single workspace:

```bash
cargo build --release --frozen --workspace
```

and packaged through:

```text
nexus-rust-tools
```

---

# ⚡ Zig

Zig is also part of the Nexus Linux development toolchain.

Nexus includes Zig alongside Rust to provide a modern native systems-programming
environment.

Zig is intended for projects and components where:

* low-level systems programming is useful
* predictable native binaries are desired
* C interoperability is required
* simple cross-compilation is beneficial
* lightweight native utilities are being developed

The project therefore supports both:

```text
Rust
  +
Zig
  ↓
Native Nexus tooling
```

Rust currently powers the existing Nexus CLI workspace, while Zig is available
as an additional systems-development language for future Nexus components.

---

# 🔐 Security

Security is integrated into the distribution build and package infrastructure.

### Signed packages

Nexus packages can be cryptographically signed using the Nexus package
signing infrastructure.

### Nexus keyring

The signing keys are maintained by:

```text
localpkgs/nexus-keyring/
```

The package contains Nexus repository trust information including:

```text
nexus.gpg
nexus-trusted
nexus-revoked
```

### Repository verification

The Nexus repository is configured to verify package signatures.

### Controlled package sources

Nexus maintains its own package repository alongside the official Arch
repositories.

---

# 🧰 Hardware Support

Nexus provides a broad hardware-support base through the packages included
in its ISO profiles.

The project includes support for areas such as:

### Graphics

* Mesa
* Intel graphics
* AMD Radeon
* Vulkan
* VA-API
* VDPAU

### Wireless

* Intel firmware
* MediaTek firmware
* Realtek wireless hardware
* Broadcom wireless hardware

### Bluetooth

* BlueZ
* BlueZ utilities
* Bluetooth plugins

### Printing & Scanning

* CUPS
* CUPS filters
* SANE
* AirScan
* Simple Scan

### Firmware

Linux firmware packages are included to provide compatibility with a wide
range of modern and older hardware.

---

# 🔨 Building Nexus Linux

Nexus Linux is designed to be built from an **Arch Linux-based development
environment**.

The build system uses standard Arch tooling including:

* `pacman`
* `makepkg`
* `archiso`
* `mkarchiso`
* `repo-add`
* GPG
* Cargo
* Rust
* Zig
* Bash

The repository contains dedicated scripts for ISO, repository and release
operations.

## Requirements

Install the main ISO build dependency:

```bash
sudo pacman -S archiso --needed
```

The main build script handles additional build dependencies.

---

## Clone the Repository

```bash
git clone https://github.com/Nexus-Linux-Official/NexusLinux.git
cd NexusLinux
```

---

## Build an ISO

Default profile:

```bash
./build-nexus-iso.sh
```

Build a specific profile:

```bash
./build-nexus-iso.sh "desktop"
```

The build system performs the major stages automatically:

```text
Dependencies
     ↓
Calamares
     ↓
Nexus packages
     ↓
Local repository
     ↓
Package signing
     ↓
Archiso
     ↓
ISO
     ↓
Checksums + signatures
```

The build script currently handles dependency installation, Calamares
source compilation, local package builds, repository generation and ISO
generation.

---

# 📦 Building the Nexus Repository

The Nexus repository can be built independently:

```bash
./build-nexus-repo.sh
```

The generated package repository is used during ISO construction.

Conceptually:

```text
PKGBUILD
   │
   ▼
makepkg
   │
   ▼
Nexus package
   │
   ▼
repo-add
   │
   ▼
nexus.db
```

---

# 🧪 Testing

Nexus provides dedicated ISO testing and utility scripts.

Relevant tools include:

```text
testiso.sh
util-iso.sh
util-iso-mount.sh
util-msg.sh
```

ISO builds can be tested in virtualized environments before physical
deployment.

Recommended test environments include:

* QEMU / KVM
* VirtualBox
* VMware
* GNOME Boxes
* Hyper-V

Testing should cover:

* ISO boot
* UEFI
* installation
* desktop selection
* online installation
* offline installation
* package repository initialization
* first boot
* hardware detection
* networking
* graphics
* audio
* suspend/resume

---

# 📁 Repository Structure

```text
NexusLinux/
│
├── .github/
├── .vscode/
│
├── archiso/
│   ├── airootfs/
│   ├── package lists
│   └── ISO configuration
│
├── localpkgs/
│   ├── nexus-branding/
│   ├── nexus-wallpapers/
│   ├── nexus-keyring/
│   ├── nexus-calamares/
│   ├── nexus-kde-settings/
│   ├── nexus-rust-tools/
│   └── rust-workspace/
│
├── machines/
├── scripts/
├── testcases/
├── wallpapers/
│
├── build-nexus-iso.sh
├── build-nexus-repo.sh
├── build.sh
├── buildiso.sh
├── ci.build.sh
├── release-nexus.sh
├── testiso.sh
│
├── CHANGELOG.md
├── CONTRIBUTING.md
├── DEVELOPER_CALL.md
├── GITHUB_ISSUES.md
├── SECURITY.md
├── LICENSE
└── README.md
```

The current repository contains dedicated ISO, package, release, testing,
machine and package-source infrastructure.

---

# 🛠️ Development Stack

Nexus Linux combines several technologies:

| Technology         | Role                        |
| ------------------ | --------------------------- |
| **Arch Linux**     | Base distribution           |
| **Bash**           | Build and automation        |
| **Rust**           | Native Nexus tooling        |
| **Zig**            | Native systems development  |
| **Cargo**          | Rust workspace              |
| **CMake**          | Native dependency builds    |
| **Qt**             | Calamares / KDE ecosystem   |
| **Calamares**      | Graphical installer         |
| **archiso**        | ISO generation              |
| **makepkg**        | Arch package building       |
| **repo-add**       | Package repository creation |
| **GPG**            | Package signing             |
| **GitHub Actions** | CI infrastructure           |

---

# 🤝 Contributing

Nexus Linux is an open-source project and contributions are welcome.

The recommended workflow is:

```text
Fork
  ↓
Create a branch
  ↓
Make your changes
  ↓
Test your changes
  ↓
Commit
  ↓
Open Pull Request
  ↓
Review
  ↓
Merge
```

Before submitting changes, contributors should check the relevant scripts,
packages and documentation.

Useful project documentation:

* [`CONTRIBUTING.md`](CONTRIBUTING.md)
* [`SECURITY.md`](SECURITY.md)
* [`DEVELOPER_CALL.md`](DEVELOPER_CALL.md)
* [`GITHUB_ISSUES.md`](GITHUB_ISSUES.md)

---

# 🐛 Issues & Bug Reports

If you encounter a problem, please provide as much useful information as
possible.

Include:

* Nexus Linux version
* ISO build/version
* hardware information
* desktop environment
* reproduction steps
* relevant terminal output
* logs where applicable

For security vulnerabilities, please follow the instructions in
[`SECURITY.md`](SECURITY.md) instead of publicly exposing sensitive details.

---

# 🚀 Releases

Nexus Linux releases may contain:

* ISO images
* SHA256 checksums
* cryptographic signatures
* package lists
* package repository artifacts
* release metadata

Official releases:

**https://github.com/Nexus-Linux-Official/NexusLinux/releases**

---

# 📚 Documentation

| Document                                 | Description             |
| ---------------------------------------- | ----------------------- |
| [`CHANGELOG.md`](CHANGELOG.md)           | Version history         |
| [`CONTRIBUTING.md`](CONTRIBUTING.md)     | Contribution guidelines |
| [`SECURITY.md`](SECURITY.md)             | Security policy         |
| [`DEVELOPER_CALL.md`](DEVELOPER_CALL.md) | Development information |
| [`GITHUB_ISSUES.md`](GITHUB_ISSUES.md)   | Issue catalog           |

---

# 📊 Project Status

Nexus Linux is under active development.

Current areas of development include:

* ISO reliability
* Calamares integration
* Nexus package infrastructure
* Native system tooling
* Rust development
* Zig integration
* Hardware compatibility
* Desktop integration
* Security infrastructure
* Automated testing
* CI/CD
* Documentation

The repository currently contains the core components required to build
Nexus Linux, including its ArchISO configuration, Nexus packages, Rust
workspace, installer integration, package repository infrastructure and
release scripts.

---

# 📄 License

Nexus Linux and its individual components may be distributed under different
licenses depending on the component and its upstream source.

See [`LICENSE`](LICENSE) for the license applicable to this repository.

Upstream projects and packages retain their respective licenses.

Nexus branding, logos and other project assets may be subject to separate
terms where applicable.

---

<div align="center">

# Nexus Linux

**Pure Arch. Modern Desktop. Native Tooling.**

Rust · Zig · KDE Plasma · Calamares · Arch Linux

<br>

[GitHub](https://github.com/Nexus-Linux-Official/NexusLinux) ·
[Issues](https://github.com/Nexus-Linux-Official/NexusLinux/issues) ·
[Releases](https://github.com/Nexus-Linux-Official/NexusLinux/releases)

</div>
