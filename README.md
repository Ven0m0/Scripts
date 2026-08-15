# Scripts - Windows Gaming Automation Toolkit

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![AutoHotkey](https://img.shields.io/badge/Language-AutoHotkey_v2.0-blue.svg)](https://www.autohotkey.com/)
[![Platform](https://img.shields.io/badge/Platform-Windows-lightgrey.svg)](https://www.microsoft.com/windows)

---

## Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [Key Scripts](#key-scripts)
- [Documentation](#documentation)
- [Requirements](#requirements)
- [Installation](#installation)
- [License](#license)

---

## Overview

AutoHotkey v2 automation scripts for Windows gaming and productivity: window management,
AFK macros, and a general hotkey suite.

---

## Quick Start

### Prerequisites

- **AutoHotkey v2.0.19+** - [Download](https://www.autohotkey.com/)
- **Windows 10/11** - Scripts are Windows-specific

### Running Scripts

```bash
git clone https://github.com/Ven0m0/Scripts.git
cd Scripts
```

Double-click any `.ahk` file, or run it from the command line:

```bash
"C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe" ahk\Fullscreen.ahk
```

---

## Project Structure

```
Scripts/
├── ahk/                          # AutoHotkey v2 scripts
│   ├── Black_ops_6/              # CoD BO6 AFK macros
│   ├── Minecraft/                # Minecraft AFK automation
│   ├── Robocopy/                 # Robocopy wrapper (PowerShell/cmd)
│   ├── ControllerQuit.ahk        # Quit apps with controller combo
│   ├── Fullscreen.ahk            # Borderless fullscreen toggle
│   ├── Keys.ahk                  # Main hotkey suite
│   └── test_Keys.ahk             # Unit test for Keys.ahk
│
├── Lib/                          # Shared AutoHotkey v2.0 libraries
│   ├── AHK_Common.ahk            # Init, elevation, exe resolution
│   ├── WindowManager.ahk         # Window/fullscreen manipulation
│   └── test_RequireAdmin.ahk     # Unit test for RequireAdmin
│
├── tests/                        # Standalone unit tests
│
├── .github/workflows/            # CI/CD automation
│   ├── ahk-lint-format-compile.yml  # Syntax & format validation
│   ├── build.yml                    # Release compilation
│   └── powershell.yml            # PSScriptAnalyzer
│
├── AGENTS.md                     # AI assistant development guide
├── CLAUDE.md                     # Symlink to AGENTS.md
├── EXAMPLES.md                   # Usage patterns and code examples
└── LICENSE                       # MIT License
```

---

## Key Scripts

| Script | Description |
| --- | --- |
| `ahk/Fullscreen.ahk` | Toggle borderless fullscreen (multi-monitor) |
| `ahk/Keys.ahk` | Hotkey suite (Win+Arrow snapping, media keys, etc.) |
| `ahk/ControllerQuit.ahk` | Quit active window with a controller button combo |
| `ahk/Black_ops_6/bo6-afk.ahk` | Black Ops 6 AFK farming macros |
| `ahk/Minecraft/MC_AFK.ahk`, `MC_AutoSprint.ahk` | Minecraft AFK automation |

See [ahk/README.md](ahk/README.md) for the full script list and hotkeys.

---

## Documentation

- **[EXAMPLES.md](EXAMPLES.md)** - usage patterns and code examples
- **[ahk/README.md](ahk/README.md)**, **[Lib/README.md](Lib/README.md)** - area-specific behavior
- **[AGENTS.md](AGENTS.md)** - development guide for AI assistants and contributors

---

## Requirements

- **AutoHotkey v2.0.19+** - [Download](https://www.autohotkey.com/)
- **Windows 10/11**

---

## Installation

```powershell
choco install autohotkey
```

Then clone the repository and run any `.ahk` script directly.

---

## License

This project is licensed under the **MIT License** - see [LICENSE](LICENSE) for details.

---

## Contact

**Author:** Ven0m0
**Repository:** [github.com/Ven0m0/Scripts](https://github.com/Ven0m0/Scripts)
