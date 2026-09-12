# Nexus Linux — Developer Call

> **This project is currently being developed in a simple development environment.**  
> Once build issues are resolved and GitHub Actions / CI/CD is set up, development will move there.

---

## 🎯 Vision

**Nexus Linux** — *Web-app based, lightweight, security-focused, Pure Arch-based distribution.*

| Feature | Plan |
|---------|------|
| **Base** | Pure Arch (core/extra/multilib only) |
| **Desktop** | KDE Plasma (default), GNOME, COSMIC options |
| **Installation** | Calamares (built from source) |
| **Package Management** | `pacman` + Flatpak (for web-apps) |
| **Security** | ClamAV, hardened kernel options, AppArmor/SELinux profiles |
| **Web-App Focus** | Flatpak/WebApp Manager integration, PWA support |
| **Lightweight** | Minimal ISO ~1.5GB, only essential services |

---

## 📍 Current Status (2026-09)

| Component | Status |
|---------|-------|
| Pure Arch base | ✅ Completed |
| CachyOS remnants | ✅ Fully cleaned |
| Calamares (from source) | 🔄 In build phase |
| localpkgs (branding/keyring/wallpaper/calamares-config) | ✅ Added |
| GRUB theme | ✅ Added |
| Hardware drivers (firmware/GPU/WiFi/Bluetooth/Printer) | ✅ Added to package lists |
| ClamAV + ClamTK | ✅ Added |
| Build script | 🔄 `libjsoncpp.so.26` error — being fixed |
| CI/CD (GitHub Actions) | ❌ Not yet |

> **Note:** The `build-nexus-iso.sh` script is currently run manually. The build error (`cmake: libjsoncpp.so.26`) is being fixed.

---

## 🛠 How Can You Help as a Developer?

| Area | What's Needed |
|------|--------------|
| **CI/CD** | GitHub Actions workflow: `makepkg`, `mkarchiso`, artifact upload |
| **Calamares** | Module optimization, adding web-app installation option |
| **Security** | AppArmor profiles, hardened kernel package, sbom signing |
| **Web-App** | Flatpak repo integration, PWA installer, WebApp Manager |
| **Branding** | Wallpapers, SDDM/Plymouth themes, icon set |
| **Test** | Virtual machine / bare metal tests, hardware compatibility reports |
| **Documentation** | Wiki, installation guide, developer manual |

---

## 🚀 Quick Start (For Developers)

```bash
# Repo
git clone https://github.com/nexuslinux-os/NexusLinux
cd NexusLinux

# Dependencies (Arch/Arch-based)
sudo pacman -S archiso base-devel git cmake qt6-base qt6-declarative \
    kconfig kcoreaddons ki18n kparts yaml-cpp jsoncpp

# Build local packages
for p in localpkgs/*/; do
    (cd "$p" && makepkg -sf --noconfirm --skippgpcheck)
done

# Build Calamares (one-time)
git clone --depth 1 --branch v3.3.12 https://github.com/calamares/calamares
cd calamares && mkdir build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DINSTALL_CONFIG=ON
make -j$(nproc) && sudo make install

# ISO build
./build-nexus-iso.sh desktop
```

---

## 📁 Structure

```
NexusLinux/
├── archiso/                 # archiso profile (airootfs, packages, grub, syslinux)
│   ├── airootfs/            # Live system overlay
│   │   ├── etc/             # os-release, pacman.conf, calamares modules
│   │   ├── usr/share/nexus-calamares/  # Branding, modules, scripts
│   │   └── boot/grub/themes/nexus/     # GRUB theme
│   ├── packages*.x86_64     # Package lists (x86_64, desktop, minimal)
│   └── buildiso.sh          # Upstream archiso build driver
├── localpkgs/               # Nexus custom packages (makepkg)
│   ├── nexus-branding/      # os-release, lsb-release
│   ├── nexus-wallpapers/    # Wallpapers
│   ├── nexus-keyring/       # Signing keys
│   └── nexus-calamares/     # Calamares modules, branding, config
├── build-nexus-iso.sh       # Main build script
├── build-nexus-repo.sh      # (Legacy — for local repo, not used)
├── CHANGELOG.md             # Changelog
├── README.md                # Project description
├── CONTRIBUTING.md          # Contribution guide
└── SECURITY.md              # Security policy
```

---

## 💬 Contact

- **Issues:** [GitHub Issues](https://github.com/nexuslinux-os/NexusLinux/issues)
- **Discussions:** [GitHub Discussions](https://github.com/nexuslinux-os/NexusLinux/discussions)
- **Email:** `nexuslinux@proton.me`
- **Social Networks:** Not yet

---

## ⚖️ License

- **Code:** GPL-3.0-or-later
- **Branding/Assets:** CC-BY-SA-4.0
- **Pure Arch based** — Arch Linux packages come with their own licenses.

---

> **"Start simple, grow securely, focus on the web."**  
> Nexus Linux — Pure Arch. Web-first. Security-by-default.

> **Want to contribute:** Fork → Branch → PR. Every contribution is valuable.
