# AGENTS.md - AI Agent Development Guide

> **Last Updated:** 2026-02-10
> **Purpose:** Comprehensive guide for AI agents working with this codebase
> **Version:** 2.0 (Hybrid AHK v1/v2)

---

## Table of Contents

1. [Project Overview & Tech Stack](#project-overview--tech-stack)
2. [Repository Structure](#repository-structure)
3. [Development Workflows](#development-workflows)
4. [Coding Conventions](#coding-conventions)
5. [Dependencies](#dependencies)
6. [Common Tasks](#common-tasks)

---

## Project Overview & Tech Stack

### Purpose

**Windows Gaming & Emulation Automation Toolkit** - A comprehensive collection of AutoHotkey scripts for window management, emulator automation, media tools, and system enhancement.

### Tech Stack

| Component | Technology | Version | Notes |
|-----------|-----------|---------|-------|
| **Primary Language** | AutoHotkey | v2.0.19+ | Modern scripts (45+) |
| **Legacy Language** | AutoHotkey | v1.1.37.02+ | Legacy scripts with dependencies |
| **Scripting** | PowerShell | 5.1+ | System utilities |
| **Shell** | Batch/CMD | N/A | Simple launchers |
| **Platform** | Windows | 10/11 | Windows-specific APIs |
| **Line Endings** | CRLF | N/A | Required for .ahk, .ps1, .cmd, .bat |
| **Encoding** | UTF-8 | N/A | All text files |

### Core Features

- **Window Management** - Borderless fullscreen, multi-monitor control, window snapping
- **Emulator Automation** - Auto-fullscreen for 15+ emulators (Citra, Yuzu, RPCS4, etc.)
- **Media Tools** - YouTube/Spotify downloaders with GUI
- **Gaming Utilities** - AFK macros, mod managers, per-game configs
- **System Enhancement** - Hotkey suites, power plan automation

### Architecture

**Hybrid Dual-Version System:**
- **v2 Scripts** (`ahk/`, `Lib/v2/`) - Modern, optimized, primary development
- **v1 Scripts** (`Other/Citra_*`, `Other/Downloader/`, `Lib/v1/`) - Legacy with complex dependencies

---

## Repository Structure

### Directory Layout

```
@/home/user/Scripts/
├── ahk/                          # AutoHotkey v2 scripts (PRIMARY)
│   ├── Black_ops_6/             # CoD BO6 AFK macros (5 scripts)
│   ├── GUI/                     # Script launcher GUIs
│   │   @├── GUI_PC.ahk         # Desktop launcher (86 lines)
│   │   @├── GUI_Laptop.ahk     # Laptop launcher (60 lines)
│   │   @├── GUI_Shared.ahk     # Shared GUI framework
│   │   └── WM.ahk              # Window manager GUI
│   ├── Minecraft/               # Minecraft AFK automation
│   @├── ControllerQuit.ahk     # Quit apps with controller combo
│   @├── Fullscreen.ahk         # Borderless fullscreen toggle
│   @├── Keys.ahk               # Main hotkey suite (v2, 300+ lines)
│   └── Powerplan.ahk           # Auto power plan switching
│
├── Lib/                         # Shared libraries (CRITICAL)
│   ├── v1/                     # AutoHotkey v1.1 libraries
│   │   @├── AHK_Common.ahk    # v1 initialization (61 lines)
│   │   @├── AutoStartHelper.ahk # Auto-fullscreen helpers (68 lines)
│   │   @└── WindowManager.ahk  # Window manipulation (162 lines)
│   └── v2/                     # AutoHotkey v2.0 libraries
│       @├── AHK_Common.ahk    # v2 initialization (~70 lines)
│       @├── AutoStartHelper.ahk # v2 auto-fullscreen helpers (~60 lines)
│       @└── WindowManager.ahk  # v2 window manipulation (~180 lines)
│
├── Other/                       # Specialized utilities & legacy scripts
│   ├── 7zEmuPrepper/           # On-the-fly game decompression (PowerShell)
│   ├── Citra_mods/             # 3DS mod manager (v1)
│   ├── Citra_per_game_config/  # Per-game emulator settings (v1, 13 configs)
│   ├── Downloader/             # YouTube/Spotify GUI downloaders (v1, security-patched)
│   ├── Playnite_fullscreen_v2/ # Game launcher automation (v2)
│   @├── AutoStartManager.ahk   # Unified auto-fullscreen launcher (v2)
│   @└── AutoStartConfig.ini    # Emulator configurations (data-driven)
│
├── .github/                     # CI/CD automation
│   ├── workflows/
│   │   @├── ahk-lint-format-compile.yml # Syntax & format validation (PRIMARY)
│   │   @├── build-cached.yml   # Release compilation (optimized)
│   │   └── build.yml           # Release compilation (basic)
│   └── instructions/           # Language-specific instructions
│       ├── autohotkey.instructions.md
│       ├── powershell.instructions.md
│       └── cmd.instructions.md
│
@├── .editorconfig              # Editor configuration (46 lines)
@├── .gitattributes             # Line ending rules (58 lines)
@├── .gitignore                 # Build artifacts exclusions (64 lines)
@├── AGENTS.md                  # This file - AI agent guide
@├── CLAUDE.md                  # Claude-specific development guide (1700+ lines)
@├── README.md                  # User-facing documentation
@├── CONTRIBUTING.md            # Contribution guidelines
@├── CHANGELOG.md               # Version history
└── license.md                  # MIT License
```

### Critical Files

**Must-Read Before Modifications:**

| File | Purpose | Impact |
|------|---------|--------|
| @`Lib/v2/AHK_Common.ahk` | v2 initialization utilities | All v2 scripts |
| @`Lib/v2/WindowManager.ahk` | v2 window manipulation | 30+ scripts |
| @`Lib/v2/AutoStartHelper.ahk` | v2 auto-fullscreen logic | 15+ emulator scripts |
| @`Lib/v1/AHK_Common.ahk` | v1 initialization utilities | All v1 scripts |
| @`Lib/v1/WindowManager.ahk` | v1 window manipulation | Legacy scripts |
| @`.editorconfig` | Code formatting rules | All files |
| @`.github/workflows/ahk-lint-format-compile.yml` | CI/CD validation | Build process |

---

## Development Workflows

### Setup

#### Prerequisites

```bash
# Install AutoHotkey v2 (Chocolatey)
choco install autohotkey --version=2.0.19 -y

# Install AutoHotkey v1 (Chocolatey)
choco install autohotkey.portable --version=1.1.37.02 -y

# Clone repository
git clone https://github.com/Ven0m0/Scripts.git
cd Scripts
```

#### Environment Configuration

**Required:**
- Windows 10/11 (x64)
- AutoHotkey v2.0.19+ (for `ahk/` scripts)
- AutoHotkey v1.1.37.02+ UIA version (for `Other/` legacy scripts)

**Optional:**
- yt-dlp (for YouTube downloader)
- spotdl (for Spotify downloader)
- 7-Zip (for 7zEmuPrepper)
- MultiMonitorTool (included in `Other/Playnite_fullscreen_v2/`)

### Build

#### Local Testing

```powershell
# Syntax check single script (v2)
$ahkV2 = "$env:ProgramFiles\AutoHotkey\v2\AutoHotkey64.exe"
$compiler = "$env:ProgramFiles\AutoHotkey\Compiler\Ahk2Exe.exe"
& $compiler /in script.ahk /out temp.exe /base $ahkV2
if ($LASTEXITCODE -eq 0) { Write-Host "✓ Syntax OK"; Remove-Item temp.exe }

# Syntax check single script (v1)
$compiler = "C:\ProgramData\chocolatey\lib\autohotkey.portable\tools\Compiler\Ahk2Exe.exe"
& $compiler /in script.ahk /out temp.exe
if ($LASTEXITCODE -eq 0) { Write-Host "✓ Syntax OK"; Remove-Item temp.exe }

# Format validation
$content = Get-Content script.ahk -Raw
if ($content -match "^\t" -and $content -match "^    ") { Write-Host "❌ Mixed indent" }
if ($content -match "[ \t]+`r?`n") { Write-Host "❌ Trailing space" }
if ($content -match "`r`n" -and $content -match "(?<!`r)`n") { Write-Host "❌ Mixed line endings" }
```

#### CI/CD Pipeline

**Workflow:** `.github/workflows/ahk-lint-format-compile.yml`

**Triggers:**
- Push to `main`/`master` (when .ahk files change)
- Pull requests to `main`/`master`
- Manual dispatch

**Validation Steps:**
1. **Version Detection** - Auto-detects v1 vs v2 by:
   - `#Requires AutoHotkey v2` directive
   - Path patterns (`Lib/v2/`, `ahk/`)
2. **Syntax Check** - Compiles with appropriate AHK version
3. **Format Check** - Validates:
   - No mixed indentation (tabs vs spaces)
   - No trailing whitespace
   - No mixed line endings

**Exit Codes:**
- `0` - All checks passed ✅
- `1` - Syntax or format errors ❌

### Test

**Manual Testing Process:**

1. **For Script Changes:**
   ```bash
   # Run script directly
   "C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe" ahk/script.ahk

   # Test all hotkeys/functionality
   # Verify no error dialogs
   ```

2. **For Library Changes (`Lib/`):**
   ```bash
   # CRITICAL: Test dependent scripts!
   # Find all scripts that include the modified library
   Get-ChildItem -Recurse -Filter *.ahk | Select-String "Include.*LibraryName.ahk"

   # Test at least 3-5 dependent scripts
   ```

3. **Format Validation:**
   ```bash
   # Check indentation (4 spaces for .ahk)
   # Remove trailing whitespace
   # Ensure CRLF line endings for .ahk files
   ```

### Deploy

#### Release Process

1. **Tag Version:**
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. **Automated Build:**
   - Workflow: `.github/workflows/build-cached.yml`
   - Compiles all .ahk files to .exe
   - Creates GitHub release with binaries

3. **Manual Deployment:**
   ```bash
   # Users can run scripts directly (no compilation needed)
   # Or download compiled .exe from GitHub releases
   ```

---

## Coding Conventions

### File Organization

#### Naming Conventions

| Type | Convention | Example |
|------|-----------|---------|
| **v2 Scripts** | PascalCase.ahk | `Fullscreen.ahk`, `ControllerQuit.ahk` |
| **v1 Scripts** | snake_case.ahk or PascalCase.ahk | `Auto_start_Citra.ahk`, `Keys.ahk` |
| **Libraries** | PascalCase.ahk | `AHK_Common.ahk`, `WindowManager.ahk` |
| **Config Files** | PascalCase.ini | `AutoStartConfig.ini` |
| **Global Variables** | PascalCase | `ScriptPID`, `CitraConfigFile` |
| **Local Variables** | camelCase | `winTitle`, `processName` |
| **Constants** | SCREAMING_SNAKE_CASE | `FISHING_CAST_DELAY` |

#### File Headers

**v2 Scripts:**
```autohotkey
#Requires AutoHotkey v2.0
; Script Description
; Author: Ven0m0
; Last Updated: YYYY-MM-DD

#Include %A_ScriptDir%\..\Lib\v2\AHK_Common.ahk
#Include %A_ScriptDir%\..\Lib\v2\WindowManager.ahk

InitScript(true, true)  ; UIA + Admin + Performance
```

**v1 Scripts:**
```autohotkey
; Script Description
; Author: Ven0m0
; Last Updated: YYYY-MM-DD

#Include %A_ScriptDir%\..\Lib\v1\AHK_Common.ahk
#Include %A_ScriptDir%\..\Lib\v1\WindowManager.ahk

InitScript(true, true)  ; UIA + Admin + Performance

#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
```

### Code Style

#### Indentation & Formatting

**From `.editorconfig`:**
- **Indent Style:** Spaces (NEVER tabs)
- **Indent Size:** 4 spaces for .ahk, .ps1, .cmd, .bat
- **Line Endings:** CRLF for scripts, LF for docs/config
- **Charset:** UTF-8
- **Trailing Whitespace:** Remove always
- **Final Newline:** Insert always

#### Performance Directives

**ALWAYS include at top of v1 scripts:**
```autohotkey
#SingleInstance Force          ; Auto-replace old instance
#NoEnv                         ; Recommended for performance
#KeyHistory 0                  ; Disable key logging
ListLines Off                  ; Disable line logging
SetBatchLines -1               ; Maximum speed
SetKeyDelay -1, -1            ; No key delays
SetMouseDelay -1              ; No mouse delays
SetDefaultMouseSpeed 0        ; Instant mouse
SetWinDelay -1                ; No window delays
SetControlDelay -1            ; No control delays
SendMode Input                ; Fastest send mode
```

**v2 scripts:** Performance directives built into `InitScript()` call.

#### Function Documentation

```autohotkey
; ============================================================================
; FunctionName(param1, param2) - Brief description
;
; Detailed explanation of what the function does
;
; Parameters:
;   param1 - Description
;   param2 - Description (default: value)
;
; Returns:
;   Description of return value
; ============================================================================
FunctionName(param1, param2 := "default") {
    ; Implementation
}
```

### Version Detection Patterns

**CI/CD auto-detects v1 vs v2 by:**

1. **Directive Check:**
   ```autohotkey
   #Requires AutoHotkey v2.0
   ```

2. **Path Patterns:**
   - `Lib/v2/` → v2
   - `ahk/` → v2
   - `Other/**/v2/` → v2
   - Everything else → v1

### Common Patterns

#### 1. Simple Auto-Start Script (v2)

```autohotkey
#Requires AutoHotkey v2.0
#Include %A_ScriptDir%\..\Lib\v2\AHK_Common.ahk
#Include %A_ScriptDir%\..\Lib\v2\AutoStartHelper.ahk

InitScript(true, true)
AutoStartFullscreen("emulator.exe", "F11", true, 0)
```

#### 2. AFK Macro Script (v2)

```autohotkey
#Requires AutoHotkey v2.0
#Include %A_ScriptDir%\..\Lib\v2\AHK_Common.ahk
InitScript()

$*F7:: {  ; Start macro
    Loop {
        Click(500, 300)
        Sleep(1000)
        Send("{Space}")
        Sleep(2000)
    }
}

$*F8:: Pause(-1)  ; Pause/Resume
$*F9:: ExitApp()  ; Exit
```

#### 3. Window Management (v2)

```autohotkey
#Requires AutoHotkey v2.0
#Include %A_ScriptDir%\..\Lib\v2\AHK_Common.ahk
#Include %A_ScriptDir%\..\Lib\v2\WindowManager.ahk

InitScript(true, true)

; Toggle borderless fullscreen
End::ToggleFakeFullscreenMultiMonitor("A")

; Custom positioning
^!Left:: {
    WinGetPos(&X, &Y, &Width, &Height, "A")
    WinMove(0, 0, Width, Height, "A")
}
```

#### 4. GUI Launcher (v2)

```autohotkey
#Requires AutoHotkey v2.0
#Include %A_ScriptDir%\..\Lib\v2\AHK_Common.ahk
InitScript()

myGui := Gui("+AlwaysOnTop -MinimizeBox", "Script Launcher")
myGui.Add("Button", "w200", "Open Script 1").OnEvent("Click", OpenScript1)
myGui.Add("Button", "w200", "Close Script 1").OnEvent("Click", CloseScript1)
myGui.Show()

Script1PID := 0

OpenScript1(*) {
    global Script1PID
    Run("path\to\script1.ahk",,, &Script1PID)
}

CloseScript1(*) {
    global Script1PID
    if (Script1PID) {
        ProcessClose(Script1PID)
    }
}
```

### v1 to v2 Syntax Migration

| v1 Syntax | v2 Syntax | Example |
|-----------|-----------|---------|
| `MsgBox, text` | `MsgBox("text")` | `MsgBox("Hello")` |
| `WinWait, title` | `WinWait("title")` | `WinWait("ahk_exe game.exe")` |
| `WinGet, var, Style` | `var := WinGetStyle()` | `style := WinGetStyle("A")` |
| `WinSet, Style, value` | `WinSetStyle(value)` | `WinSetStyle(-0xC00000, "A")` |
| `SetTimer, Label, 1000` | `SetTimer(Function, 1000)` | `SetTimer(CheckWindow, 1000)` |
| `Object()` | `Map()` | `buttons := Map()` |
| `HasKey("key")` | `Has("key")` | `if map.Has("key")` |
| `#NoEnv` | _removed_ | Not needed in v2 |
| `Run, cmd,,, PID` | `Run(cmd,,, &PID)` | `Run("script.ahk",,, &PID)` |

---

## Dependencies

### Runtime Dependencies

| Dependency | Version | Required For | Install |
|------------|---------|--------------|---------|
| **AutoHotkey v2** | 2.0.19+ | v2 scripts | `choco install autohotkey` |
| **AutoHotkey v1 UIA** | 1.1.37.02+ | v1 scripts | `choco install autohotkey.portable` |
| **yt-dlp** | Latest | YouTube downloader | [Download](https://github.com/yt-dlp/yt-dlp) |
| **spotdl** | Latest | Spotify downloader | [Download](https://github.com/spotDL/spotify-downloader) |
| **7-Zip** | Latest | 7zEmuPrepper | `choco install 7zip` |
| **MultiMonitorTool** | Latest | Playnite multi-monitor | Included in repo |
| **FFMPEG** | Latest | Media conversion | Auto-downloaded by yt-dlp |

### Development Dependencies

| Dependency | Version | Purpose | Install |
|------------|---------|---------|---------|
| **Ahk2Exe** | Latest | Script compilation | Included with AutoHotkey |
| **PowerShell** | 5.1+ | CI/CD scripts | Built into Windows |
| **Git** | Latest | Version control | `choco install git` |

### Library Dependencies

**Shared Libraries (Lib/):**
- `AHK_Common.ahk` - All scripts use this
- `WindowManager.ahk` - 30+ scripts
- `AutoStartHelper.ahk` - 15+ emulator scripts
- `tf.ahk` (v1 only) - Citra config scripts

**Third-Party Libraries:**
- None (pure AutoHotkey implementation)

---

## Common Tasks

### 1. Adding a New v2 Script

```bash
# Create new script in ahk/ directory
# Use template:

#Requires AutoHotkey v2.0
#Include %A_ScriptDir%\..\Lib\v2\AHK_Common.ahk

InitScript(true, true)  ; UIA + Admin + Performance

; Your code here
```

**Checklist:**
- [ ] Include `#Requires AutoHotkey v2.0` directive
- [ ] Use `#Include` for shared libraries
- [ ] Call `InitScript()` for initialization
- [ ] Use 4-space indentation
- [ ] CRLF line endings
- [ ] No trailing whitespace
- [ ] Test locally before committing

### 2. Modifying Shared Libraries

**CRITICAL: High-impact changes!**

```bash
# 1. Read the library file
# 2. Identify ALL dependent scripts
Get-ChildItem -Recurse -Filter *.ahk | Select-String "Include.*LibraryName.ahk"

# 3. Make changes carefully
# 4. Test at least 3-5 dependent scripts
# 5. Run CI/CD validation locally
# 6. Commit with detailed message
```

**Libraries to be extra careful with:**
- `Lib/v2/AHK_Common.ahk` - Used by ALL v2 scripts
- `Lib/v2/WindowManager.ahk` - Used by 30+ scripts
- `Lib/v1/AHK_Common.ahk` - Used by ALL v1 scripts

### 3. Fixing CI/CD Failures

**Syntax Errors:**
```bash
# Read error output from GitHub Actions
# Compile locally to see details:
& "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" /in script.ahk /out temp.exe

# Common issues:
# - Missing return at end of auto-execute section
# - Unmatched braces { }
# - Invalid variable names
# - Incorrect function calls
```

**Format Errors:**
```bash
# Mixed indentation - Use 4 spaces only
# Trailing whitespace - Remove with editor
# Mixed line endings - Ensure CRLF for .ahk files

# Auto-fix in VS Code:
# 1. Set "files.eol": "\r\n"
# 2. Set "files.trimTrailingWhitespace": true
# 3. Set "editor.insertSpaces": true
# 4. Set "editor.tabSize": 4
```

### 4. Creating a Pull Request

```bash
# 1. Fork repository
git clone https://github.com/YOUR_USERNAME/Scripts.git
cd Scripts

# 2. Create feature branch
git checkout -b feature/my-feature

# 3. Make changes following conventions
# 4. Test locally
# 5. Commit with semantic message
git commit -m "feat: Add new feature"

# 6. Push to your fork
git push origin feature/my-feature

# 7. Open PR on GitHub
# 8. Wait for CI/CD to pass
# 9. Address review comments
```

**Commit Message Format:**
```
<type>: <brief description>

<optional detailed explanation>
```

**Types:** `feat`, `fix`, `refactor`, `docs`, `style`, `perf`, `test`, `chore`

### 5. Migrating v1 Script to v2

```bash
# 1. Read v1 script
# 2. Add #Requires AutoHotkey v2.0 directive
# 3. Change includes to Lib/v2/
# 4. Update syntax (see v1 to v2 table above)
# 5. Test thoroughly
# 6. Update documentation

# Key syntax changes:
# - MsgBox, text → MsgBox("text")
# - WinWait, title → WinWait("title")
# - SetTimer, Label, 1000 → SetTimer(Function, 1000)
# - Object() → Map()
# - Run, cmd,,, PID → Run(cmd,,, &PID)
```

### 6. Debugging Scripts

**Method 1: Message Boxes**
```autohotkey
MsgBox("Variable value: " . var)
```

**Method 2: Tooltips**
```autohotkey
ToolTip("Checkpoint 1")
Sleep(2000)
ToolTip()  ; Clear
```

**Method 3: Log Files**
```autohotkey
logFile := A_ScriptDir . "\debug.log"
FileAppend(A_Now . " - Script started`n", logFile)
FileAppend(A_Now . " - Variable: " . var . "`n", logFile)
```

**Remember:** Remove all debugging code before committing!

### 7. Security Review

**Before Committing:**
- [ ] No command injection vulnerabilities
- [ ] Validate all user input
- [ ] No hardcoded passwords/API keys
- [ ] No path traversal vulnerabilities
- [ ] Admin privileges only when necessary

**Input Validation Example:**
```autohotkey
ValidateInput(input) {
    ; Check for dangerous characters
    if RegExMatch(input, "[&|;<>()`$^""]") {
        return false
    }
    return true
}
```

---

## Additional Resources

### Documentation

- **@CLAUDE.md** - Comprehensive 1700+ line development guide
- **@README.md** - User-facing project overview
- **@CONTRIBUTING.md** - Contribution guidelines
- **@CHANGELOG.md** - Version history
- **@EXAMPLES.md** - Usage examples

### External Links

- **AutoHotkey v2 Docs:** https://www.autohotkey.com/docs/v2/
- **AutoHotkey v1 Docs:** https://www.autohotkey.com/docs/v1/
- **AutoHotkey Forum:** https://www.autohotkey.com/boards/
- **Repository:** https://github.com/Ven0m0/Scripts

### Key Contacts

- **Author:** Ven0m0
- **Email:** ven0m0.wastaken@gmail.com
- **Issues:** https://github.com/Ven0m0/Scripts/issues

---

## Quick Reference

### Essential Commands

```bash
# Run v2 script
"C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe" script.ahk

# Run v1 script
"C:\ProgramData\chocolatey\lib\autohotkey.portable\tools\AutoHotkey.exe" script.ahk

# Compile v2 script
$compiler = "$env:ProgramFiles\AutoHotkey\Compiler\Ahk2Exe.exe"
& $compiler /in script.ahk /out script.exe /base "$env:ProgramFiles\AutoHotkey\v2\AutoHotkey64.exe"

# Compile v1 script
$compiler = "C:\ProgramData\chocolatey\lib\autohotkey.portable\tools\Compiler\Ahk2Exe.exe"
& $compiler /in script.ahk /out script.exe
```

### File Encoding Standards

| File Type | Line Ending | Indent | Notes |
|-----------|-------------|--------|-------|
| `.ahk` | CRLF | 4 spaces | Windows scripts |
| `.ps1` | CRLF | 4 spaces | PowerShell |
| `.cmd`, `.bat` | CRLF | 4 spaces | Batch files |
| `.md` | LF | 2 spaces | Markdown docs |
| `.yml`, `.yaml` | LF | 2 spaces | YAML configs |
| `.json` | LF | 2 spaces | JSON configs |

### CI/CD Exit Codes

| Code | Meaning | Action |
|------|---------|--------|
| `0` | All checks passed | Merge allowed ✅ |
| `1` | Syntax errors | Fix compilation errors ❌ |
| `1` | Format errors | Fix indentation/whitespace ❌ |

---

**Last Updated:** 2026-02-10
**Maintained by:** Ven0m0
**License:** MIT

---

_This document is maintained as part of the Scripts repository to assist AI agents in understanding and contributing to the codebase effectively._
