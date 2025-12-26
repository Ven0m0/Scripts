# Scripts - Windows Gaming & Emulation Automation Toolkit

> **Comprehensive AutoHotkey automation suite for Windows gaming, emulation, and productivity**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![AutoHotkey](https://img.shields.io/badge/Language-AutoHotkey_v2.0-blue.svg)](https://www.autohotkey.com/)
[![Platform](https://img.shields.io/badge/Platform-Windows-lightgrey.svg)](https://www.microsoft.com/windows)

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [Key Scripts](#key-scripts)
- [AutoHotkey v2 Migration](#autohotkey-v2-migration)
- [Documentation](#documentation)
- [Requirements](#requirements)
- [Installation](#installation)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

This repository is a **comprehensive automation toolkit** focused on Windows gaming and emulation workflows. It provides a modular, performance-optimized collection of AutoHotkey scripts for window management, emulator automation, media downloading, and system enhancement.

### Core Strengths

- **Window Management** - Borderless fullscreen, multi-monitor control, window snapping
- **Emulator Automation** - Auto-fullscreen for 15+ emulators (Citra, Yuzu, RPCS4, Bluestacks, etc.)
- **Media Tools** - YouTube and Spotify downloaders with GUI
- **Gaming Utilities** - AFK macros, mod managers, per-game configurations
- **System Enhancement** - Hotkey suites, power plan automation

---

## Features

### 🎮 Emulator & Gaming Automation

- **AutoStartManager** - Data-driven auto-fullscreen launcher for all major emulators
- **Playnite Integration** - Multi-monitor setup automation with boot videos
- **Game-Specific Scripts** - Custom automation for Spider-Man, Shellshock Live, etc.
- **AFK Macros** - Black Ops 6, Minecraft fishing/farming automation
- **Controller Support** - Quit applications with gamepad button combinations

### 🖥️ Window Management

- **Borderless Fullscreen** - Toggle fake fullscreen on any window
- **Multi-Monitor Aware** - Automatic monitor detection and positioning
- **Window Snapping** - Win+Arrow key window positioning
- **Always On Top** - Quick window layer management

### 📥 Media Tools

- **YouTube Downloader** - GUI for yt-dlp with quality selection
- **Spotify Downloader** - Download Spotify playlists/tracks
- **Combined Downloader** - All-in-one media download GUI

### ⚡ System Utilities

- **Power Plan Switcher** - Auto-switch power plans based on running games
- **Lossless Scaling** - Auto-start/close for upscaling tools
- **Hotkey Suite** (Keys.ahk) - File renaming, media control, window operations

### 🎛️ Citra 3DS Emulation

- **Per-Game Configs** - 10+ game-specific configuration profiles
- **HD Texture Pack Manager** - GUI for enabling/disabling texture packs
- **Mod Manager** - CSV-driven mod activation system

---

## Quick Start

### Prerequisites

- **AutoHotkey v2.0.19+** - [Download](https://www.autohotkey.com/)
- **AutoHotkey v1.1.37.02+** - Required for legacy scripts ([Download UIA version](https://www.autohotkey.com/download/))
- **Windows 10/11** - Scripts are Windows-specific

### Running Scripts

1. **Clone the repository:**

   ```bash
   git clone https://github.com/Ven0m0/Scripts.git
   cd Scripts
   ```

2. **Run any script:**
   - **v2 scripts:** Double-click `.ahk` files with `#Requires AutoHotkey v2.0` directive
   - **v1 scripts:** Double-click `.ahk` files in `Other/Citra_*` or `Other/Downloader/`

3. **Launch GUI tools:**
   - `AHK/GUI/GUI_PC.ahk` - Desktop script launcher
   - `AHK/GUI/GUI_Laptop.ahk` - Laptop script launcher
   - `AHK/GUI/WM.ahk` - Window management controls

### Example: Auto-Fullscreen for Citra

```bash
# Using AutoStartManager (v2)
Other/AutoStartManager.ahk Citra

# Using legacy script (v1)
Other/Auto_start_Fullscreen_Citra.ahk
```

---

## Project Structure

```
Scripts/
├── AHK/                          # Main automation scripts
│   ├── Black_ops_6/             # CoD BO6 AFK macros (5 scripts)
│   ├── GUI/                     # Script launcher GUIs (3 scripts)
│   ├── Minecraft/               # Minecraft AFK automation (3 scripts)
│   ├── ControllerQuit.ahk      # Quit apps with controller
│   ├── Fullscreen.ahk          # Borderless fullscreen toggle
│   ├── Keys.ahk                # Main hotkey suite (v1)
│   └── Powerplan.ahk           # Auto power plan switching
│
├── ahk/                          # AutoHotkey v2 scripts
│   ├── Black_ops_6/             # CoD BO6 AFK macros
│   ├── GUI/                     # Script launcher GUIs
│   ├── Minecraft/               # Minecraft AFK automation
│   ├── ControllerQuit.ahk      # Quit apps with controller
│   ├── Fullscreen.ahk          # Borderless fullscreen toggle
│   ├── Keys.ahk                # Main hotkey suite
│   └── Powerplan.ahk           # Auto power plan switching
│
├── Lib/                          # Shared libraries
│   ├── v1/                      # AutoHotkey v1.1 libraries
│   │   ├── AHK_Common.ahk      # Initialization utilities
│   │   ├── AutoStartHelper.ahk # Auto-fullscreen helpers
│   │   └── WindowManager.ahk   # Window manipulation
│   └── v2/                      # AutoHotkey v2.0 libraries
│       ├── AHK_Common.ahk      # v2 initialization (UIA built-in)
│       ├── AutoStartHelper.ahk # v2 auto-fullscreen helpers
│       └── WindowManager.ahk   # v2 window manipulation
│
├── Other/                        # Specialized utilities
│   ├── 7zEmuPrepper/           # On-the-fly game decompression
│   ├── Citra_mods/             # 3DS mod manager
│   ├── Citra_per_game_config/  # Per-game emulator settings
│   ├── Downloader/             # YouTube/Spotify downloaders
│   ├── Playnite_fullscreen_v2/ # Game launcher automation
│   ├── AutoStartManager.ahk    # Unified auto-fullscreen launcher
│   └── AutoStartConfig.ini     # Emulator configurations
│
├── .github/workflows/            # CI/CD automation
│   ├── ahk-lint-format-compile.yml  # Syntax & format validation
│   └── build-cached.yml        # Release compilation
│
├── CLAUDE.md                     # AI assistant development guide
├── GEMINI.md                     # Additional AI documentation
└── license.md                    # MIT License
```

---

## Key Scripts

### Window Management

| Script                 | Description                                           | Version |
| ---------------------- | ----------------------------------------------------- | ------- |
| `ahk/Fullscreen.ahk`   | Toggle borderless fullscreen (multi-monitor)          | v2      |
| `ahk/Keys.ahk`         | Comprehensive hotkey suite (Win+Arrow snapping, etc.) | v2      |
| `ahk/GUI/WM.ahk`       | Window management GUI controls                        | v2      |

### Emulator Automation

| Script                                         | Description                      | Version |
| ---------------------------------------------- | -------------------------------- | ------- |
| `Other/AutoStartManager.ahk`                   | Unified auto-fullscreen launcher | v2      |
| `Other/Playnite_fullscreen_v2/Playnite_TV.ahk` | Multi-monitor Playnite setup     | v2      |
| `Other/Citra_per_game_config/*.ahk`            | Per-game Citra configurations    | v1      |

### Gaming Utilities

| Script                       | Description                     | Version |
| ---------------------------- | ------------------------------- | ------- |
| `ahk/Black_ops_6/bo6-afk.ahk`| Black Ops 6 AFK farming macros  | v2      |
| `ahk/Minecraft/MC_AFK*.ahk`  | Minecraft AFK automation        | v2      |
| `ahk/ControllerQuit.ahk`     | Quit apps with controller combo | v2      |
| `ahk/Powerplan.ahk`          | Auto power plan switching       | v2      |

### Media & Downloaders

| Script                                       | Description                     | Version |
| -------------------------------------------- | ------------------------------- | ------- |
| `Other/Downloader/YT_Spotify_Downloader.ahk` | Combined media downloader GUI   | v1      |
| `Other/Downloader/YT_Downloader.ahk`         | YouTube downloader (yt-dlp GUI) | v1      |
| `Other/Downloader/Spotify_Downloader.ahk`    | Spotify downloader (spotdl GUI) | v1      |

---

## AutoHotkey v2 Migration

> **Status:** 45+ scripts migrated to v2 | Hybrid codebase maintained

### Migration Overview

This repository has undergone a **comprehensive migration** to AutoHotkey v2.0 where beneficial, while maintaining backward compatibility for complex legacy scripts.

### Dual Library Architecture

- **Lib/v1/** - AutoHotkey v1.1 libraries for legacy scripts
- **Lib/v2/** - AutoHotkey v2.0 libraries with modern syntax

### Migrated to v2 (45+ scripts)

✅ **All core libraries** (Lib/v2/)
✅ **All AFK macros** (Black Ops 6, Minecraft)
✅ **All GUI scripts** (GUI_PC, GUI_Laptop, GUI_Shared, WM)
✅ **All Playnite launchers** (4 scripts)
✅ **Utility scripts** (ControllerQuit, Powerplan, Fullscreen, Lossless_Scaling)
✅ **Other/ scripts** (Spider-Man, Bluestacks rotation, Ryujinx, RemotePlay, 7zEmuPrepper)

### Kept in v1 (Legacy)

🔒 **Keys.ahk** - Complex COM interactions, needs extensive testing
🔒 **Citra scripts** - Depend on tf.ahk library (v1 only)
🔒 **Downloader scripts** - Functional with security patches applied

### Migration Benefits

- **81% reduction** in auto-start scripts (9 → 1 + config)
- **Modern syntax** - Maps, proper functions, better error handling
- **Performance** - Removed unnecessary delays, optimized callbacks
- **Maintainability** - Data-driven configurations, shared frameworks
- **Security** - Fixed command injection vulnerabilities

---

## Documentation

### For Users

- **[README.md](README.md)** (this file) - Quick start and overview
- **[EXAMPLES.md](EXAMPLES.md)** - Common usage patterns and practical examples
- **Script-specific READMEs** - See subdirectories:
  - [Other/Downloader/](Other/Downloader/README.md)
  - [Other/Citra_mods/](Other/Citra_mods/README.md)
  - [Other/Citra_per_game_config/](Other/Citra_per_game_config/README.md)
  - [ahk/](ahk/README.md)
  - [ahk/GUI/](ahk/GUI/README.md)
  - [Lib/](Lib/README.md)

### For Developers & AI Assistants

- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Contribution guidelines and standards
- **[CLAUDE.md](CLAUDE.md)** - Comprehensive development guide (1700+ lines)
  - Codebase structure and conventions
  - v2 migration strategy and syntax reference
  - Common patterns and templates
  - Known issues and technical debt
  - CI/CD workflows and testing
- **[GEMINI.md](GEMINI.md)** - Additional AI assistant documentation
- **[CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)** - Community guidelines
- **[CHANGELOG.md](CHANGELOG.md)** - Version history and release notes
- **[Links.md](Links.md)** - Useful resources and external links

---

## Requirements

### Software

- **AutoHotkey v2.0.19+** - For v2 scripts ([Download](https://www.autohotkey.com/))
- **AutoHotkey v1.1.37.02+** - For legacy scripts (UIA version recommended)
- **Windows 10/11** - Scripts use Windows-specific APIs

### Optional Dependencies

- **yt-dlp** - For YouTube downloader ([Download](https://github.com/yt-dlp/yt-dlp))
- **spotdl** - For Spotify downloader ([Download](https://github.com/spotDL/spotify-downloader))
- **MultiMonitorTool** - For Playnite multi-monitor setup (included)
- **7-Zip** - For 7zEmuPrepper decompression ([Download](https://www.7-zip.org/))

---

## Installation

### Quick Install (Windows)

1. **Install AutoHotkey v2:**

   ```powershell
   choco install autohotkey --version=2.0.19
   ```

2. **Install AutoHotkey v1 (for legacy scripts):**

   ```powershell
   choco install autohotkey --version=1.1.37.02
   ```

   _Or run:_ `Other/UIA Install.ahk` (requires admin)

3. **Clone repository:**

   ```bash
   git clone https://github.com/Ven0m0/Scripts.git
   ```

4. **Run scripts:**
   - Double-click any `.ahk` file
   - Scripts will auto-detect required AHK version

### Manual Install

1. Download AutoHotkey v2 from [autohotkey.com](https://www.autohotkey.com/)
2. Download AutoHotkey v1 UIA from [autohotkey.com/download](https://www.autohotkey.com/download/)
3. Clone or download this repository
4. Run scripts by double-clicking `.ahk` files

---

## Contributing

Contributions are welcome! Please follow these guidelines:

### Before Submitting

1. **Read [CLAUDE.md](CLAUDE.md)** - Development guide and conventions
2. **Test your changes** - Ensure scripts run without errors
3. **Follow coding standards:**
   - 4-space indentation
   - CRLF line endings for `.ahk` files
   - Include performance directives (`#SingleInstance`, `SetBatchLines -1`, etc.)
   - Use `#Requires AutoHotkey v2.0` for new scripts

### Pull Request Process

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-feature`)
3. Commit your changes (`git commit -m "feat: Add my feature"`)
4. Push to your fork (`git push origin feature/my-feature`)
5. Open a Pull Request

### Commit Message Format

```
<type>: <brief description>

<optional detailed explanation>
```

**Types:** `feat`, `fix`, `refactor`, `docs`, `style`, `perf`, `test`, `chore`

---

## CI/CD

### Automated Workflows

- **Syntax & Format Validation** - Runs on every push/PR
- **Compilation Tests** - Ensures all scripts compile correctly
- **Release Builds** - Auto-compiles `.exe` files on tag push

See `.github/workflows/` for details.

---

## License

This project is licensed under the **MIT License** - see [license.md](license.md) for details.

**In short:** You are free to use, modify, and distribute these scripts. Attribution appreciated but not required.

---

## Acknowledgments

- **AutoHotkey Community** - For extensive documentation and support
- **NirSoft** - MultiMonitorTool for multi-monitor management
- **yt-dlp & spotdl** - Media download backends

---

## Contact

**Author:** Ven0m0
**Email:** ven0m0.wastaken@gmail.com
**Repository:** [github.com/Ven0m0/Scripts](https://github.com/Ven0m0/Scripts)

---

## Changelog

### 2025-12-17 - Major v2 Migration

- Migrated 45+ scripts to AutoHotkey v2
- Created dual library architecture (v1/v2)
- Consolidated 24 duplicate/redundant files
- Fixed hardcoded paths using environment variables
- Security fixes for command injection vulnerabilities

See [CLAUDE.md - Changelog](CLAUDE.md#changelog) for detailed version history.

---

**⭐ Star this repository if you find it useful!**
