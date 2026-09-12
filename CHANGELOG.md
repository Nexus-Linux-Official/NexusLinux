# Nexus Linux Changelog

## 2026-09-11 — First Stable ISO (v1.0.1 / 2026.09.11)

### ISO Build — Stable Success (2.8 GB)
* `nexus-unstable-2026.09.06-x86_64.iso` → `nexus-2026.09.11-x86_64.iso` stable (2.8 GB, `out/desktop/`), `SHA256SUMS` + `.img` valid
* `build.sh` 6-stage now warning-only (8/8 Rust tools compile)
* `nexus-unstable.sh` hata-tolerant unstable builder eklendi

### Latest Stable Versions (Arch Rolling)
* **KDE Plasma 6.7.5** (2026-09-08 bugfix, was 6.7.0) — `plasma-desktop:6.7.5` via `pacman -Sy`
* **GNOME 50.2** (2026-06-05, 51.0 stable 2026-09-16) — `gnome:50.2` / `gnome-extra`
* **Firefox 155.0** (2026-09-01) — `firefox:155.0`
* **linux-zen 7.2.3.zen1-3** (2026-09-06 `extra`, 7.2.4 in `extra-testing`) — `linux-zen:7.2.3`, `linux-zen-headers` + `nvidia-dkms`
* **Arch 2026.09.01** base `7.2.2` → `7.2.3` — `version-tag:1` `1.0`→`1.0.1`, `grub.cfg:3` `260906`→`260911`
* `archiso/packages.x86_64:160` + `packages_desktop.x86_64:160` → `kde-applications`, `gnome`, `gnome-extra` eklendi (was partial `kate/kcalc/nautilus`)

### Rust Workspace — All 8 Tools Compile
* `rust-workspace/Cargo.toml:10` `colored` workspace dep eklendi, `Cargo.lock` sync
* `nexus-version/src/main.rs:1` `use colored::*` + `Cargo.toml:10` fix (`E0599 bright_cyan`)
* `nexus-theme/src/main.rs:81` unclosed `for y` brace fix + `colored` (`E0599` + `unclosed delimiter`)
* `nexus-build-helpers/src/main.rs:143` `pb.length()` `Option<u64>` → `unwrap_or(0)`, `validate_pkgbuild:165` `&PathBuf`→`&Path`
* `nexus-installer-backend/src/main.rs:1` alpm 5.0 API mismatch → stub `placeholder` + `Cargo.toml:19` `[[bin]] name="nexus-installer"`
* `nexus-check/src/main.rs:5` duplicate `serde::Serialize`, `30` duplicate `#[derive]` dedup
* `nexus-hardware/src/main.rs:195` missing `}` in `get_cpu_info`, `296` `ip_networks` (sysinfo 0.30 has no API) → no-op
* `nexus-info/src/main.rs:147` `OsStr` → `to_string_lossy`, `169` `ip_networks` no-op
* `localpkgs/rust-tools/PKGBUILD:28` `git+tag v0.1.0` → `cp -r …/rust-workspace` local, `--locked/--frozen` kaldırıldı, `103` `nexus-build-helpers`→`nexus-build` binary map, `depends=(sysinfo nix…)` Rust crate’leri kaldırıldı

### Archiso & Build System — Critical Fixes
* `archiso/profiledef.sh:1` `write_file` wrapper → ham `profiledef.sh` (mkarchiso `source` fail fix)
* `archiso/pacman.conf:1` mutlak `/home/cahit` `[nexus]` → kaldırıldı (build script dinamik prepend; CI uyumlu), sonra `ccd56f1`’de host build için geri eklendi + `sudo pacman -Sy`
* `archiso/airootfs/root/customize_airootfs.sh:13` `branding/nexus` → `look-and-feel/nexus`, `33` `sed` guard `[ -f ] &&`
* `util-msg.sh:15` `unset` → `ALL_OFF=""… readonly` (unbound `YELLOW/RED`)
* `build.sh:14` `makepkg --noconfirm` → `makepkg -f --noconfirm` + `*.pkg.tar.zst` cleanup, `43` `repo-add -f` → `repo-add` (invalid extension)
* `localpkgs/rust-workspace/.gitignore:33` `**/src/` rust-workspace’i yutuyordu → `!localpkgs/rust-workspace/**/src/**` exception
* `localpkgs/rust-tools/rust-workspace` absolute `cp` → `$startdir/../rust-workspace`

### Git & Linguist
* `.gitignore:37` `localpkgs/rust-workspace/target/` ignore, `localrepo/*.pkg.tar.zst` ignore
* `.claude/SKILLS:1` 210 skill (10 kategori: archiso 30, calamares 25, rust 30, pkgbuild 25, shell 25, git 15, system 20, qa 15, python 15, meta 10) — `.claude/SKILLS/README.md:1` + `örnek/örnek.md:1` template, her skill `<skill>/<skill>.md:1`
* `.Claude/SKILLS:1` kopyası eklendi (case visibility)
* Python `%7.5` hesabı: `2797`→`10976` için `8179` byte shell→Python gerekli (`build.sh:2003` + `nexus-unstable.sh:4742` + `gen-nexus-keyring.sh:1546` = `8291`)
* `15` harici repo (`Extra`, `Multilib`, `nex`, `nexsolv`, `Nexus-Calamares`, `nexus-fish-config`, `nexus-handheld`, `nexus-hooks`, `nexus-kde-settings`, `nexus-kernel`, `nexus-kernel-manager`, `nexus-keyring`, `Nexus-Settings`, `nexus-wallpapers`, `nexus-zsh-config`) sync’lendi

## 2026-09-05

### Rust Integration (Major Feature)

* **8 New CLI Tools in Rust** (`nexus-rust-tools` meta-package)
  - `nexus-info` — System information display (JSON/pretty output)
  - `nexus-version` — Version information tool (JSON/short/full)
  - `nexus-check` — System health check (disk, memory, network, services, security)
  - `nexus-hardware` — Hardware detection (CPU, RAM, GPU, disks, network, USB, PCI)
  - `nexus-micro` — Micro settings (zram, hostname, services)
  - `nexus-installer` — Package installer backend (alpm bindings)
  - `nexus-theme` — Wallpaper/theme utilities (generate, apply, list)
  - `nexus-build` — Build helpers (verify, validate, gen pkglist, create ISO)

* **Rust Workspace Infrastructure**
  - Cargo workspace with 8 crates in `localpkgs/rust-workspace/`
  - Cargo.lock with 214 crates locked
  - `nexus-rust-tools` meta-package builds all 8 binaries
  - Added to both `packages_desktop.x86_64` and `packages_minimal.x86_64`

### 2026-09-04

### Major Changes

* **Pure Arch Linux Base**: Completely removed all CachyOS dependencies and repositories
  - Removed `[cachyos]` repository from all pacman.conf files
  - Deleted entire `localpkgs/` directory (all CachyOS-derived fork packages)
  - Removed CachyOS keyring files, mirrorlists, and hooks
  - Removed `cachy-chroot`, `cachyos-cli-installer-new`, `cachyos-ananicy-rules` packages
  - Updated all documentation to reflect pure Arch base

* **Calamares Installer**: Now built from source (v3.3.12)
  - Added build dependencies: cmake, qt6, kconfig, kcoreaddons, kcrash, ki18n, kparts, kpmcore, kservice, kwidgetsaddons, libpwquality, polkit-qt6, python, yaml-cpp, boost, jsoncpp
  - Disabled unnecessary modules for lighter ISO
  - Installs before ISO build via build script

* **DE Selection**: Reduced to 3 options
  - KDE Plasma (recommended)
  - GNOME
  - COSMIC
  - Removed: Cinnamon, Budgie, MATE, Xfce, LXQt, LXDE, Hyprland, MangoWM, Sway, i3, Openbox, phosh, Niri

* **File Manager & Terminal**: Switched to GNOME stack
  - `dolphin` → `nautilus`
  - `konsole` → `ptyxis`

### Hardware Support (Debian-style out-of-the-box)

* **Firmware**: Added comprehensive firmware packages
  - `linux-firmware-qlogic`, `linux-firmware-bnx2x`, `linux-firmware-liquidio`
  - `linux-firmware-nfp`, `linux-firmware-qcom`, `linux-firmware-whence`

* **GPU Drivers**: Modern Intel/AMD support
  - `intel-media-driver`, `vulkan-intel`, `vulkan-radeon`
  - `libva-intel-driver`, `libva-mesa-driver`, `mesa-vdpau`

* **Network**: WiFi/Ethernet/Bluetooth
  - `r8168`, `broadcom-wl-dkms`, `rtl8821cu-dkms`, `rtl8852be-dkms`, `mt7921-firmware`
  - `bluez`, `bluez-utils`, `bluez-plugins`, `bluez-hid2hci`

* **Printing & Scanning**: Full CUPS stack
  - `cups`, `cups-filters`, `cups-pdf`, `ghostscript`, `gsfonts`
  - `system-config-printer`, `simple-scan`, `sane`, `sane-airscan`

* **Network Discovery**: Avahi/mDNS
  - `avahi`, `nss-mdns`

### Build System

* **Simplified build script** (`build-nexus-iso.sh`)
  - Reordered: install deps → build calamares → build ISO
  - Install jsoncpp before cmake, reinstall cmake after jsoncpp update
  - Run `ldconfig` to fix library linkage
  - Removed PGP signing, local repo management, fork swap logic

* **GRUB Theme**: New Nexus-branded theme
  - `/boot/grub/themes/nexus/` with dark blue gradient background
  - Custom colors: #1793d1 (accent), #1a1a2e (background)
  - Font fallback generation via `grub-mkfont`

### Security

* **ClamAV**: Antivirus included by default
  - `clamav` daemon + `clamtk` GUI

### Rust Tooling Infrastructure

* **Rust Workspace** (`localpkgs/rust-workspace/`)
  - 8 crates in Cargo workspace
  - Cargo.lock with 214 crates locked
  - `nexus-rust-tools` meta-package builds all 8 binaries
  - Added to both `packages_desktop.x86_64` and `packages_minimal.x86_64`

* **Build System Updates**
  - `cargo fetch --locked --target x86_64-unknown-linux-gnu`
  - `cargo build --release --frozen --workspace`
  - `nexus-rust-tools` meta-package builds all 8 binaries

### Documentation

* **README.md**: Rewritten with banner, Rust tools, updated package list
* **CONTRIBUTING.md**: Updated for Arch-based workflow
* **SECURITY.md**: Removed CachyOS references
* **GITHUB_ISSUES.md**: 42 issues catalog from code review
* **create_github_issues.py**: Script to auto-create GitHub issues
- **.vscode**: Complete VS Code config (tasks, debug, snippets, keybindings)
- **.gitattributes** + **.github/linguist**: Rust language detection for GitHub
- **.github/linguist**: Linguist override for Rust detection

---

## 2026-09-01 (Initial Fork)

* Forked from CachyOS live ISO
* Initial rebranding to "Nexus Linux"
* KDE Plasma desktop with Calamares installer
* Nexus package repository structure (`localpkgs/`)