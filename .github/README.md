# Scripts - Windows Gaming & Automation Toolkit

> **Comprehensive AutoHotkey automation suite for Windows gaming, emulation, and productivity**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub Release](https://img.shields.io/github/v/release/Ven0m0/Scripts?label=Current%20Release)](https://github.com/Ven0m0/Scripts/releases)
[![GitHub Downloads](https://img.shields.io/github/downloads/Ven0m0/Scripts/total?logo=github&label=GitHub%20Downloads)](https://github.com/Ven0m0/Scripts/releases)
[![Commit activity](https://img.shields.io/github/last-commit/Ven0m0/Scripts?logo=github)](https://github.com/Ven0m0/Scripts/commits)

---

## Quick Links

- **[Main README](../README.md)** - Full project documentation
- **[CONTRIBUTING.md](../CONTRIBUTING.md)** - How to contribute
- **[CHANGELOG.md](../CHANGELOG.md)** - Version history
- **[CODE_OF_CONDUCT.md](../CODE_OF_CONDUCT.md)** - Community guidelines

---

## Featured Tools

### 🎮 Gaming & Emulation

#### [YouTube & Spotify Downloader](../Other/Downloader/)

<a href="../Other/Downloader/">
  <img src="../Other/Downloader/Downloader.avif" alt="Downloader GUI" width="600">
</a>

GUI-based media downloaders for YouTube videos/audio and Spotify playlists/tracks.

**Features:**
- Download videos or extract audio from YouTube
- Download songs from Spotify playlists
- Quality selection and format conversion
- User-friendly GUI interface

[View Documentation →](../Other/Downloader/README.md)

---

#### [Citra Mod Manager](../Other/Citra_mods/)

<a href="../Other/Citra_mods/">
  <img src="../Other/Citra_mods/Citra_Mod_Manager.avif" alt="Citra Mod Manager" width="600">
</a>

GUI for managing mods and HD texture packs for Citra 3DS emulator.

**Features:**
- Enable/disable mods per game
- HD texture pack management
- CSV-based game database
- Per-game settings

[View Documentation →](../Other/Citra_mods/README.md)

---

### 🖥️ Window Management

#### [Borderless Fullscreen](../ahk/Fullscreen.ahk)

Toggle borderless fullscreen on any window with multi-monitor support.

**Features:**
- Multi-monitor aware
- Saves and restores window state
- Works with games lacking native borderless mode

---

#### [Auto-Fullscreen Manager](../Other/AutoStartManager.ahk)

Unified data-driven auto-fullscreen launcher for all major emulators.

**Supported Emulators:**
- Citra, Yuzu, Ryujinx
- RPCS4, PCSX2
- Dolphin, Cemu
- And 10+ more!

---

### 🛠️ System Utilities

#### [Power Plan Automation](../ahk/Powerplan.ahk)

Automatically switch Windows power plan based on running applications.

#### [Controller Quit](../ahk/ControllerQuit.ahk)

Close applications using gamepad button combinations.

#### [GUI Launchers](../ahk/GUI/)

Centralized script launchers with graphical interface for easy management.

---

## Additional Tools

### [Playnite Auto-Fullscreen](../Other/Playnite_fullscreen_v2/)

Multi-monitor setup automation for Playnite with boot videos.

### [Citra Per-Game Config](../Other/Citra_per_game_config/)

Automatically apply per-game configuration settings to Citra emulator.

### [7zEmuPrepper](../Other/7zEmuPrepper/)

On-the-fly game decompression for emulation front-ends.

### [Robocopy Utilities](../Other/Robocopy/)

Batch script wrappers for Windows Robocopy with extension filtering.

---

## Project Statistics

- **61+ AutoHotkey scripts** (v1 and v2)
- **45+ scripts migrated** to AutoHotkey v2
- **15+ emulators supported** for auto-fullscreen
- **Dual library architecture** for v1/v2 compatibility
- **MIT Licensed** - Free and open source

---

## Quick Start

1. **Install AutoHotkey**
   - [AutoHotkey v2.0.19+](https://www.autohotkey.com/) for modern scripts
   - [AutoHotkey v1.1.37.02+](https://www.autohotkey.com/download/) for legacy scripts

2. **Clone the repository**
   ```bash
   git clone https://github.com/Ven0m0/Scripts.git
   cd Scripts
   ```

3. **Run any script**
   - Double-click `.ahk` files
   - Or run from command line: `autohotkey script.ahk`

---

## Documentation

- **[README.md](../README.md)** - Main project documentation
- **[CLAUDE.md](../CLAUDE.md)** - Comprehensive developer guide (1700+ lines)
- **[EXAMPLES.md](../EXAMPLES.md)** - Common usage patterns and examples
- **[CONTRIBUTING.md](../CONTRIBUTING.md)** - Contribution guidelines
- **[CHANGELOG.md](../CHANGELOG.md)** - Version history

---

## CI/CD & Workflows

This directory contains GitHub Actions workflows for:

- **Code Quality** - Syntax validation and formatting checks
- **Automated Builds** - Compilation of .exe releases
- **Version Detection** - Automatic v1/v2 script detection

See [workflows/](workflows/) for workflow definitions.

---

## Support

- **Issues:** [GitHub Issues](https://github.com/Ven0m0/Scripts/issues)
- **Email:** ven0m0.wastaken@gmail.com
- **License:** MIT

---

**⭐ Star this repository if you find it useful!**
