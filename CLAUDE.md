# CLAUDE.md - AI Assistant Development Guide

> **Last Updated:** 2025-12-17
> **Purpose:** Comprehensive guide for AI assistants working with this codebase

---

## Table of Contents

1. [Repository Overview](#repository-overview)
2. [AutoHotkey v2 Migration Status](#autohotkey-v2-migration-status)
3. [Codebase Structure](#codebase-structure)
4. [Development Workflows & CI/CD](#development-workflows--cicd)
5. [Coding Conventions & Standards](#coding-conventions--standards)
6. [Key Components & Libraries](#key-components--libraries)
7. [Common Patterns & Templates](#common-patterns--templates)
8. [Testing & Quality Assurance](#testing--quality-assurance)
9. [Known Issues & Technical Debt](#known-issues--technical-debt)
10. [Development Guidelines for AI Assistants](#development-guidelines-for-ai-assistants)

---

## Repository Overview

### Purpose

This repository is a **comprehensive automation toolkit** focused on Windows gaming/emulation workflows, with particular strengths in:

- **Window Management** - Borderless fullscreen, multi-monitor control, window snapping
- **Emulator Automation** - Auto-fullscreen for 15+ emulators (Citra, Yuzu, RPCS4, etc.)
- **Media Tools** - YouTube and Spotify downloaders with GUI
- **Gaming Utilities** - AFK macros, mod managers, per-game configs
- **System Enhancement** - Hotkey suites, power plan automation

### Key Statistics

- **Languages:** AutoHotkey v1.1 (primary), PowerShell, Batch
- **Total Scripts:** 61 AutoHotkey files, 2 PowerShell scripts, 3 CMD files
- **License:** MIT (permissive)
- **Author:** Ven0m0 (ven0m0.wastaken@gmail.com)
- **Platform:** Windows-only (CRLF line endings, Windows-specific APIs)

### Core Philosophy

1. **Performance-First** - Heavy optimization in all scripts
2. **Modular Design** - Shared libraries in `Lib/` directory
3. **Minimal Dependencies** - Pure AHK where possible
4. **User Convenience** - GUI tools for non-technical users
5. **Gaming Focus** - Emulator and game automation priority

---

## AutoHotkey v2 Migration Status

> **Migration Completed:** 2025-12-17
> **Status:** Hybrid codebase with both AHK v1.1 and v2.0 scripts

### Overview

This repository has undergone a comprehensive migration from AutoHotkey v1.1 to v2.0 where beneficial. The codebase now maintains **both versions** in a dual-library architecture to maximize compatibility and modernization benefits.

### Migration Strategy

**Migrated to v2** (35+ scripts):
- ✅ All core libraries (Lib/v2/)
- ✅ All AFK macros (Black Ops 6, Minecraft)
- ✅ All GUI scripts (GUI_PC, GUI_Laptop, GUI_Shared, WM)
- ✅ All Playnite launcher variants (4 scripts)
- ✅ Utility scripts (ControllerQuit, Powerplan, Fullscreen, etc.)
- ✅ Lossless_Scaling automation scripts

**Kept in v1.1** (scripts with complex dependencies):
- 🔒 Keys.ahk - Complex COM interactions, extensive testing required
- 🔒 Citra configuration scripts - Dependency on tf.ahk library (v1 only)
- 🔒 Downloader scripts - Legacy but functional, security patches applied

**Consolidated & Deleted** (13 duplicates):
- ❌ 9 auto-start scripts → 1 data-driven AutoStartManager.ahk with AutoStartConfig.ini
- ❌ 3 fullscreen variants → 1 unified AHK_v2/Fullscreen.ahk
- ❌ 4 duplicate downloader drafts removed

### Dual Library Architecture

```
Lib/
├── v1/                          # AutoHotkey v1.1 libraries
│   ├── AHK_Common.ahk          # v1 initialization utilities
│   ├── WindowManager.ahk       # v1 window manipulation
│   └── AutoStartHelper.ahk     # v1 auto-fullscreen helpers
└── v2/                          # AutoHotkey v2.0 libraries
    ├── AHK_Common.ahk          # v2 initialization (UIA built-in)
    ├── WindowManager.ahk       # v2 window manipulation
    └── AutoStartHelper.ahk     # v2 auto-fullscreen helpers
```

**Key Changes in v2 Libraries:**
- `InitUIA()` - Now a no-op (UIA built into v2)
- `RequireAdmin()` - Updated to v2 error handling with try/catch
- `WindowManager` - Converted WinGet/WinSet to WinGetStyle/WinSetStyle
- `AutoStartHelper` - Simplified with v2 syntax, removed redundant delays
- All functions use v2 syntax: `Function()` instead of `Function, param`

### Migration Benefits Achieved

1. **Code Reduction:** 81% reduction in auto-start scripts (9 → 1 + config)
2. **Modernization:** v2 syntax (Maps, proper function calls, better error handling)
3. **Performance:** Removed unnecessary delays, optimized timer callbacks
4. **Maintainability:** Data-driven configuration, shared GUI framework
5. **Security:** Fixed command injection vulnerabilities in downloader scripts

### CI/CD Compatibility

The build system (`ahk-lint-format-compile.yml`) now **automatically detects** script version:
- Checks for `#Requires AutoHotkey v2` directive
- Checks for `Lib/v2/` or `AHK_v2/` in file path
- Compiles with appropriate AHK version (v1.1.37.02 or v2.0.19)

### v1 to v2 Syntax Quick Reference

| v1 Syntax | v2 Syntax | Example |
|-----------|-----------|---------|
| `MsgBox, text` | `MsgBox("text")` | `MsgBox("Hello")` |
| `WinWait, title` | `WinWait("title")` | `WinWait("ahk_exe game.exe")` |
| `WinGet, var, Style` | `var := WinGetStyle()` | `style := WinGetStyle("A")` |
| `WinSet, Style, value` | `WinSetStyle(value)` | `WinSetStyle(-0xC00000, "A")` |
| `SetTimer, Label, 1000` | `SetTimer(Function, 1000)` | `SetTimer(CheckWindow, 1000)` |
| `Object()` | `Map()` | `buttons := Map()` |
| `HasKey("key")` | `Has("key")` | `if map.Has("key")` |
| `#NoEnv` | *removed* | Not needed in v2 |
| `#IfWinActive` | *changed* | Use `HotIf()` or `#HotIf` |

### Future Migration Candidates

**To be migrated when time permits:**
- Keys.ahk - Requires comprehensive testing of all hotkeys
- Citra scripts - Needs tf.ahk library migration or rewrite

---

## Codebase Structure

### Root Directory Layout

```
/home/user/Scripts/
├── .github/workflows/        # CI/CD automation (3 workflows)
├── AHK/                      # Main AutoHotkey scripts
│   ├── Black_ops_6/         # Game-specific AFK macros (5 scripts)
│   ├── Documentation/       # Optimization guides and references
│   ├── GUI/                 # GUI launchers (WM.ahk, GUI_PC.ahk, etc.)
│   ├── Minecraft/           # Minecraft AFK scripts (3 scripts)
│   ├── ControllerQuit.ahk  # Close windows with controller
│   ├── Fullscreen*.ahk     # Borderless fullscreen utilities (3 variants)
│   ├── Keys.ahk            # Main hotkey suite (225 lines)
│   └── Powerplan.ahk       # Auto power plan switching
├── Lib/                     # Shared library files ⚠️ IMPORTANT
│   ├── v1/                 # AutoHotkey v1.1 libraries
│   │   ├── AHK_Common.ahk      # v1 initialization utilities
│   │   ├── AutoStartHelper.ahk # v1 auto-fullscreen helpers
│   │   └── WindowManager.ahk   # v1 window manipulation
│   └── v2/                 # AutoHotkey v2.0 libraries
│       ├── AHK_Common.ahk      # v2 initialization utilities (UIA built-in)
│       ├── AutoStartHelper.ahk # v2 auto-fullscreen helpers
│       └── WindowManager.ahk   # v2 window manipulation
├── Other/                   # Specialized utilities & tools
│   ├── 7zEmuPrepper/       # On-the-fly game decompression (PowerShell)
│   ├── Citra_mods/         # 3DS mod manager with CSV config
│   ├── Citra_per_game_config/ # Per-game emulator settings (13 configs)
│   ├── Downloader/         # YouTube/Spotify GUI downloaders
│   ├── Playnite_fullscreen/ # Game launcher automation + multi-monitor
│   ├── Robocopy/           # Batch file copy utilities
│   └── Auto_start_*.ahk    # 15+ emulator auto-fullscreen scripts
├── .editorconfig           # Editor configuration (see Coding Standards)
├── .gitattributes          # Line ending rules (CRLF for scripts, LF for docs)
├── .gitignore              # Build artifacts, temp files, OS files
├── license.md              # MIT License
└── readme.md               # User-facing documentation
```

### Critical Directories

#### `Lib/` - Shared Libraries ⚠️

**NEVER modify these without testing all dependent scripts!**

**Dual Architecture:** Libraries exist in both `Lib/v1/` and `Lib/v2/` directories
- **v1 scripts** use: `#Include %A_ScriptDir%\..\Lib\v1\AHK_Common.ahk`
- **v2 scripts** use: `#Include %A_ScriptDir%\..\Lib\v2\AHK_Common.ahk`

**Lib/v1/ - AutoHotkey v1.1 Libraries:**

- **AHK_Common.ahk** (61 lines)
  - `InitUIA()` - Ensures UIA support (requires special AHK executable)
  - `RequireAdmin()` - Restarts with admin
  - `SetOptimalPerformance()` - Applies all performance settings
  - `InitScript(uia, admin, optimize)` - One-call initialization

- **WindowManager.ahk** (162 lines)
  - `ToggleFakeFullscreen(winTitle)`
  - `SetWindowBorderless(winTitle)`
  - `MakeFullscreen(winTitle)`
  - `ToggleFakeFullscreenMultiMonitor(winTitle)` ⭐ Most used
  - `WaitForWindow(winTitle, timeout)`
  - `WaitForProcess(processName, timeout)`

- **AutoStartHelper.ahk** (68 lines)
  - `AutoStartFullscreen(exeName, fullscreenKey, maximize, delay, activate)`
  - `AutoStartFullscreenWithTitle(winTitle, fullscreenKey, maximize, delay)`

**Lib/v2/ - AutoHotkey v2.0 Libraries:**

- **AHK_Common.ahk** (~70 lines)
  - `InitUIA()` - No-op function (UIA built into v2)
  - `RequireAdmin()` - Uses v2 try/catch error handling
  - `SetOptimalPerformance()` - v2-compatible optimizations
  - `InitScript(uia, admin, optimize)` - One-call initialization

- **WindowManager.ahk** (~180 lines)
  - All functions converted to v2 syntax
  - `WinGetStyle()` and `WinSetStyle()` instead of WinGet/WinSet
  - Added `RestoreWindowBorders(winTitle)` helper
  - Timeouts in seconds (v2 standard)

- **AutoStartHelper.ahk** (~60 lines)
  - Simplified with v2 syntax
  - `ControlSend()` instead of Send for reliability
  - Removed redundant delays

#### `AHK/` - Main Scripts

**Keys.ahk** - Main hotkey suite (most complex script)
- Window snapping (Win+Arrow keys)
- Media control (Alt+Wheel, Alt+MButton)
- File renaming with date prefix (Win+J)
- Window management (Always on top, minimize)
- Built-in documentation GUI (F1)

#### `Other/` - Specialized Tools

**High-Complexity Scripts:**
- `Downloader/YT_Spotify_Downloader.ahk` - GUI with command-line integration
- `Citra_mods/Citra_Mod_Manager.ahk` - Dynamic GUI generation from filesystem
- `Playnite_fullscreen/Playnite_TV.ahk` - Multi-monitor + external tool orchestration
- `7zEmuPrepper/7zEmuPrepper.ps1` - PowerShell with error handling

---

## Development Workflows & CI/CD

### GitHub Actions Overview

The repository has **3 automated workflows** in `.github/workflows/`:

#### 1. `ahk-lint-format-compile.yml` - Code Quality ⚠️ MOST IMPORTANT

**Triggers:**
- Push to `main`/`master` (when .ahk files or workflow changes)
- Pull requests to `main`/`master`
- Manual dispatch

**What It Does:**
1. **Syntax Validation** - Compiles all .ahk files with `Ahk2Exe.exe`
2. **Format Validation** - Checks for:
   - Mixed indentation (tabs vs spaces) ❌
   - Trailing whitespace ❌
   - Mixed line endings (CRLF vs LF) ❌

**Exit Codes:**
- Syntax errors → Exit 1 (build fails)
- Format issues → Exit 1 (build fails)
- Both clean → Exit 0 (build passes)

**Output Example:**
```
✓ AHK/Keys.ahk
❌ AHK/Test.ahk - syntax error
⚠ Lib/AHK_Common.ahk : mixed indent, trailing space

Checked: 61 | Syntax errors: 1 | Format issues: 1
```

**🚨 CRITICAL:** All code changes MUST pass this workflow before merging!

#### 2. `build.yml` - Basic Release Compilation

**Triggers:** Git tags (any tag push)

**Process:**
1. Installs AutoHotkey 2.0.19 via Chocolatey
2. Compiles ALL .ahk files to .exe
3. Creates GitHub release with compiled executables
4. Reports success/failure counts

**Use Case:** Creating user-friendly releases (no AHK installation required)

#### 3. `build-cached.yml` - Optimized Release (Preferred)

**Triggers:** Git tags (any tag push)

**Improvements:**
- Caches AutoHotkey installation (saves ~30-60 seconds)
- Downloads portable AHK from GitHub releases
- Same compilation process as `build.yml`

**Cache Key:** `ahk-2.0.19`

### CI/CD Best Practices

**Before Committing:**
1. Ensure proper indentation (4 spaces for .ahk)
2. Remove trailing whitespace
3. Use CRLF line endings for .ahk files
4. Test locally if possible

**For Releases:**
1. Tag format: `v1.0.0` or any tag
2. Both build workflows will trigger
3. Compiled .exe files will be attached to release

---

## Coding Conventions & Standards

### EditorConfig Settings

**File:** `.editorconfig` (46 lines)

| File Type | Indent | Size | Line Endings | Trim Whitespace |
|-----------|--------|------|--------------|-----------------|
| `*.ahk` | Spaces | 4 | CRLF | Yes |
| `*.ps1` | Spaces | 4 | CRLF | Yes |
| `*.{cmd,bat}` | Spaces | 4 | CRLF | Yes |
| `*.md` | Spaces | 2 | LF | **No** |
| `*.{yml,yaml}` | Spaces | 2 | LF | Yes |
| `*.json` | Spaces | 2 | LF | Yes |

**Global Rules:**
- Charset: UTF-8
- Insert final newline: true

### AutoHotkey Style Guide

#### Required Directives (Performance)

**ALWAYS include these at the top of every script:**

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
SetTitleMatchMode 3           ; Exact title matching
SetTitleMatchMode Fast        ; Fast detection mode
```

**Rationale:** These optimizations are critical for responsiveness in gaming/automation scripts.

#### Modern Script Template

```autohotkey
; Script Description
; Author: Name
; Last Updated: YYYY-MM-DD

#Include %A_ScriptDir%\..\Lib\AHK_Common.ahk
#Include %A_ScriptDir%\..\Lib\WindowManager.ahk  ; If needed

; Initialize script with UIA and Admin requirements
InitScript(true, true)  ; (requireUIA, requireAdmin, optimize=true by default)

#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%

; Main script logic below
```

#### Library Usage Pattern

**DO:**
```autohotkey
#Include %A_ScriptDir%\..\Lib\AHK_Common.ahk
InitScript(true, true)  ; UIA + Admin + Performance optimizations
```

**DON'T:**
```autohotkey
; Inline UIA check (legacy pattern, avoid in new scripts)
if !InStr(A_AhkPath, "_UIA.exe") {
    Run, % A_AhkPath . " U" (32 << A_Is64bitOS) "_UIA.exe"
    ExitApp
}
```

#### Variable Naming

**Observed Patterns:**
- **PascalCase** for global variables: `ScriptPID`, `CitraConfigFile`
- **camelCase** for local variables: `winTitle`, `processName`
- **SCREAMING_SNAKE_CASE** for constants (rare, use when needed)

**For PID Tracking:**
```autohotkey
Run "script.ahk",,, ScriptPID  ; Store PID for later use
WinKill, ahk_pid %ScriptPID%   ; Proper cleanup
```

#### Comment Style

**Function Documentation:**
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

**Inline Comments:**
```autohotkey
Sleep 5000  ; Wait for process to initialize
```

### PowerShell Style Guide

**Indentation:** 4 spaces
**Line Endings:** CRLF
**String Quotes:** Use double quotes for variable interpolation

**Best Practices:**
- Add parameter validation with `[ValidateNotNullOrEmpty()]`
- Include null checks before operations
- Use `Write-Host` for user feedback
- Use `Write-Error` for errors
- Add `try/catch` blocks for external commands

**Example from 7zEmuPrepper.ps1:**
```powershell
if (-not (Test-Path $extractedFile)) {
    Write-Error "Extraction failed - file not found"
    exit 1
}
```

### Git Commit Guidelines

**Format:**
```
<type>: <brief description>

<optional detailed explanation>
```

**Types:**
- `feat:` - New feature
- `fix:` - Bug fix
- `refactor:` - Code restructuring
- `docs:` - Documentation only
- `style:` - Formatting, whitespace
- `perf:` - Performance improvement
- `test:` - Testing related
- `chore:` - Maintenance tasks

**Example:**
```
fix: Add missing mouse button release in AFK_Hold_Click.ahk

The F6 hotkey pressed LButton down but never released it.
Added LButton up to F7 before ExitApp for proper cleanup.

Fixes issue where mouse remained in pressed state after script exit.
```

---

## Key Components & Libraries

### AHK_Common.ahk - Initialization Functions

**Location:** `Lib/AHK_Common.ahk` (61 lines)

#### InitScript(requireUIA, requireAdmin, optimize)

**Purpose:** One-call initialization for all common requirements

**Parameters:**
- `requireUIA` (bool) - Restart with UIA support if needed
- `requireAdmin` (bool) - Restart with admin privileges if needed
- `optimize` (bool, default: true) - Apply performance optimizations

**Usage:**
```autohotkey
#Include %A_ScriptDir%\..\Lib\AHK_Common.ahk

; Require both UIA and Admin
InitScript(true, true)

; Only Admin, no UIA
InitScript(false, true)

; Only performance optimizations
InitScript(false, false)
```

#### InitUIA()

**Purpose:** Ensures script is running with UI Automation support

**Implementation:**
```autohotkey
if !InStr(A_AhkPath, "_UIA.exe") {
    Run, % A_AhkPath . " U" (32 << A_Is64bitOS) "_UIA.exe"
    ExitApp
}
```

**When to Use:** Scripts that interact with modern Windows UI elements

#### RequireAdmin()

**Purpose:** Restarts script with administrator privileges

**Implementation:**
```autohotkey
if not A_IsAdmin {
    Run *RunAs "%A_ScriptFullPath%"
    ExitApp
}
```

**When to Use:** Scripts that modify system settings, power plans, or other windows

#### SetOptimalPerformance()

**Purpose:** Applies all standard performance optimizations

**Sets:**
- `#KeyHistory 0`
- `ListLines Off`
- `SetBatchLines -1`
- `SetKeyDelay -1, -1`
- `SetMouseDelay -1`
- `SetDefaultMouseSpeed 0`
- `SetWinDelay -1`
- `SetControlDelay -1`
- `SendMode Input`

**When to Use:** All scripts (enabled by default in `InitScript()`)

---

### WindowManager.ahk - Window Manipulation

**Location:** `Lib/WindowManager.ahk` (162 lines)

#### ToggleFakeFullscreenMultiMonitor(winTitle) ⭐

**Purpose:** Multi-monitor aware borderless fullscreen toggle

**Features:**
- Detects current monitor
- Calculates monitor bounds
- Saves/restores window state
- Handles multiple monitors correctly

**Usage:**
```autohotkey
#Include %A_ScriptDir%\..\Lib\WindowManager.ahk

End::ToggleFakeFullscreenMultiMonitor("A")  ; Active window
```

**Technical Details:**
- Uses `SysGet, MonitorCount, MonitorCount` for detection
- Stores state in `WindowStates` object
- Applies borderless style: `0x00040000` (WS_SIZEBOX)

#### ToggleFakeFullscreen(winTitle)

**Purpose:** Single-monitor borderless fullscreen toggle

**Difference from Multi-Monitor:** Always uses primary monitor dimensions

**Usage:**
```autohotkey
ToggleFakeFullscreen("ahk_exe game.exe")
```

#### SetWindowBorderless(winTitle)

**Purpose:** Remove window borders/titlebar

**Windows Styles Modified:**
- `WS_CAPTION` (0xC00000) - Removed
- `WS_BORDER` (0x800000) - Removed

**Implementation:**
```autohotkey
WinGet, Style, Style, %winTitle%
WinSet, Style, -%Style%, %winTitle%
WinSet, Style, +0x00040000, %winTitle%  ; Add resizable
```

#### MakeFullscreen(winTitle)

**Purpose:** Combined borderless + maximize operation

**Process:**
1. `SetWindowBorderless(winTitle)`
2. `MaximizeWindow(winTitle)`

#### WaitForWindow(winTitle, timeout := 30)

**Purpose:** Safe window waiting with timeout

**Returns:** true if found, false if timeout

**Usage:**
```autohotkey
if !WaitForWindow("ahk_exe game.exe", 10) {
    MsgBox, Window not found after 10 seconds
    ExitApp
}
```

**⚠️ Known Issue:** Default timeout is 30 seconds, but many uses in codebase have no timeout specified. See [Known Issues](#known-issues--technical-debt).

#### WaitForProcess(processName, timeout := 30)

**Purpose:** Safe process waiting with timeout

**Returns:** true if found, false if timeout

**Usage:**
```autohotkey
if !WaitForProcess("citra-qt.exe", 10) {
    MsgBox, Process did not start
    ExitApp
}
```

---

### AutoStartHelper.ahk - Emulator Auto-Fullscreen

**Location:** `Lib/AutoStartHelper.ahk` (68 lines)

#### AutoStartFullscreen(exeName, fullscreenKey, maximize, delay, activate)

**Purpose:** Wait for process, then trigger fullscreen

**Parameters:**
- `exeName` (string) - Process name (e.g., "citra-qt.exe")
- `fullscreenKey` (string, default: "F11") - Key to send for fullscreen
- `maximize` (bool, default: true) - Maximize before sending key
- `delay` (int, default: 0) - Milliseconds to wait before sending key
- `activate` (bool, default: true) - Activate window before sending key

**Usage:**
```autohotkey
#Include %A_ScriptDir%\..\Lib\AutoStartHelper.ahk
AutoStartFullscreen("citra-qt.exe", "F11", true, 0)
```

**Process:**
1. Wait for process to exist (`Process, Exist`)
2. Sleep 500ms for window initialization
3. Activate window (if `activate = true`)
4. Maximize (if `maximize = true`)
5. Sleep custom delay
6. Send fullscreen key
7. Exit script

#### AutoStartFullscreenWithTitle(winTitle, fullscreenKey, maximize, delay)

**Purpose:** Same as above, but waits for window title instead of process

**When to Use:** When multiple instances of same process exist, or process name is generic

**Usage:**
```autohotkey
AutoStartFullscreenWithTitle("ahk_class UnityWndClass", "Alt+Enter", true, 1000)
```

---

### tf.ahk - Text File Manipulation

**Location:** `Other/Citra_per_game_config/tf.ahk`

**Purpose:** INI file manipulation for Citra configs

**Functions:**
- `tf_Find()` - Search for text in file
- `tf_Replace()` - Replace text in file
- `tf_ReadLine()` - Read specific line
- `tf_WriteLine()` - Write specific line

**Usage in CitraConfigBase.ahk:**
```autohotkey
#Include %A_ScriptDir%\tf.ahk

global CitraConfigFile := "path\to\qt-config.ini"

; Replace value in INI
tf_Replace(CitraConfigFile, "custom_textures\use_custom_textures=false", "custom_textures\use_custom_textures=true")
```

---

## Common Patterns & Templates

### Pattern 1: Simple Auto-Start Script

**Use Case:** Launch emulator in fullscreen automatically

**Template:**
```autohotkey
#Include %A_ScriptDir%\..\Lib\AHK_Common.ahk
#Include %A_ScriptDir%\..\Lib\AutoStartHelper.ahk

InitScript(true, true)
#SingleInstance Force
#NoEnv

AutoStartFullscreen("emulator.exe", "F11", true, 0)
return
```

**Example:** `Other/Auto_start_Fullscreen_Citra.ahk` (5 lines)

**When to Use:**
- Script runs once, then exits
- No user interaction needed
- Minimal logic

---

### Pattern 2: AFK Macro Script

**Use Case:** Repetitive actions in games

**Template:**
```autohotkey
#Include %A_ScriptDir%\..\..\Lib\AHK_Common.ahk
InitScript()

#SingleInstance Force
#Persistent

$*F7::  ; Start macro
Loop {
    ; Your repetitive actions here
    Click 500, 300
    Sleep 1000
    Send {Space}
    Sleep 2000
}
return

$*F8::  ; Pause/Resume
Pause
return

$*F9::  ; Exit
ExitApp
return
```

**Standard Hotkeys:**
- **F7** - Start/Loop
- **F8** - Pause/Resume
- **F9** - Exit

**Examples:**
- `AHK/Minecraft/MC_AFK_Fishing.ahk`
- `AHK/Black_ops_6/AFK_Bank_Roof.ahk`

**Advanced Techniques:**
```autohotkey
; Random delays to avoid detection
Sleep % 1000 + Random(0, 500)

; Precise timing with DllCall
DllCall("Sleep", UInt, 100)

; Check for window existence before actions
if !WinExist("ahk_exe game.exe")
    ExitApp
```

---

### Pattern 3: GUI Launcher

**Use Case:** Launch/close multiple scripts from central GUI

**Template:**
```autohotkey
#Include %A_ScriptDir%\..\Lib\AHK_Common.ahk
InitScript()

Gui +AlwaysOnTop
Gui, New, -MinimizeBox, Script Launcher
Gui, Add, Tab2,, Category1|Category2

; Tab 1
Gui Add, Button, gOpenScript1, Open Script 1
Gui Add, Button, gCloseScript1, Close Script 1

; Tab 2
Gui, Tab, 2
Gui Add, Button, gOpenScript2, Open Script 2

Gui, Show
return

OpenScript1:
    Run "path\to\script1.ahk",,, Script1PID
Return

CloseScript1:
    WinKill, ahk_pid %Script1PID%
Return

GuiClose:
ExitApp
```

**Key Points:**
- Store PIDs in variables (e.g., `Script1PID`)
- Use `WinKill, ahk_pid %PID%` for cleanup
- Tab-based organization for many scripts

**Examples:**
- `AHK/GUI/GUI_PC.ahk` (86 lines)
- `AHK/GUI/GUI_Laptop.ahk` (60 lines)

---

### Pattern 4: Window Manipulation

**Use Case:** Custom window snapping, fullscreen, positioning

**Template:**
```autohotkey
#Include %A_ScriptDir%\..\Lib\AHK_Common.ahk
#Include %A_ScriptDir%\..\Lib\WindowManager.ahk

InitScript(true, true)

; Hotkey example
End::ToggleFakeFullscreenMultiMonitor("A")

; Custom positioning
^!Left::  ; Ctrl+Alt+Left
    WinGetPos,,, Width, Height, A
    WinMove, A,, 0, 0, Width, Height
return
```

**Common Operations:**
```autohotkey
; Get window info
WinGetPos, X, Y, Width, Height, %winTitle%
WinGet, Style, Style, %winTitle%
WinGet, ExStyle, ExStyle, %winTitle%

; Modify window
WinMove, %winTitle%,, X, Y, Width, Height
WinSet, Style, -0xC00000, %winTitle%  ; Remove caption
WinSet, AlwaysOnTop, Toggle, %winTitle%

; Monitor info
SysGet, MonitorCount, MonitorCount
SysGet, MonitorPrimary, MonitorPrimary
SysGet, Monitor, Monitor, 1  ; Get bounds of monitor 1
```

**Examples:**
- `AHK/Keys.ahk:95-125` (window snapping)
- `AHK/Fullscreen.ahk` (borderless fullscreen)

---

### Pattern 5: External Tool Integration

**Use Case:** Orchestrate multiple external programs

**Template:**
```autohotkey
#Include %A_ScriptDir%\..\Lib\AHK_Common.ahk
InitScript(true, true)

; Path to external tool
externalTool := A_ScriptDir . "\ExternalTool.exe"

; Run with parameters
Run, "%externalTool%" /param1 value1 /param2 value2

; Run hidden
Run, "%externalTool%" /silent,, Hide

; Run and wait
RunWait, "%externalTool%",, UseErrorLevel
if ErrorLevel
    MsgBox, Tool failed with code %ErrorLevel%
```

**Examples:**
- `Other/Playnite_fullscreen/Playnite_TV.ahk` (MultiMonitorTool, VLC)
- `Other/Downloader/YT_Downloader.ahk` (yt-dlp, spotdl)

**Command Line Integration:**
```autohotkey
; Execute command and capture output
RunWait, %ComSpec% /c "command.exe > output.txt",, Hide
FileRead, Output, output.txt
FileDelete, output.txt

; Display output in GUI
Gui Add, Edit, w500 h300 ReadOnly, %Output%
Gui Show
```

---

### Pattern 6: System State Monitoring

**Use Case:** Respond to process start/stop

**Template:**
```autohotkey
#Include %A_ScriptDir%\..\Lib\AHK_Common.ahk
InitScript(true, true)

#Persistent
SetTimer, CheckProcess, 5000  ; Check every 5 seconds
lastState := false

CheckProcess:
    Process, Exist, targetProcess.exe
    currentState := (ErrorLevel != 0)

    ; State changed from not running to running
    if (currentState and !lastState) {
        ; Process started
        MsgBox, Process started!
    }

    ; State changed from running to not running
    if (!currentState and lastState) {
        ; Process stopped
        MsgBox, Process stopped!
    }

    lastState := currentState
return
```

**Example:**
- `AHK/Powerplan.ahk` (switches power plan based on Fortnite process)

**Advanced: Window Monitoring**
```autohotkey
SetTimer, CheckWindow, 100

CheckWindow:
    if WinExist("ahk_exe game.exe") {
        ; Window exists
        WinGetPos, X, Y, Width, Height
        ; Take action based on position/size
    }
return
```

---

### Pattern 7: Multi-Monitor Management

**Use Case:** Enable/disable displays, switch primary monitor

**Template:**
```autohotkey
; Using MultiMonitorTool (NirSoft)
toolPath := A_ScriptDir . "\MultiMonitorTool\MultiMonitorTool.exe"

; Disable monitor 2
Run, "%toolPath%" /disable 2

; Enable monitor 2
Run, "%toolPath%" /enable 2

; Set monitor 1 as primary
Run, "%toolPath%" /SetPrimary 1

; Load config from file
Run, "%toolPath%" /LoadConfig "config.cfg"
```

**Example:**
- `Other/Playnite_fullscreen/Playnite_TV.ahk:17-23`

**AHK-Native Method:**
```autohotkey
; Get monitor count
SysGet, MonitorCount, MonitorCount

; Loop through monitors
Loop, %MonitorCount% {
    SysGet, Monitor, Monitor, %A_Index%
    ; MonitorLeft, MonitorTop, MonitorRight, MonitorBottom
    MsgBox, Monitor %A_Index%: %MonitorLeft%x%MonitorTop%
}

; Get monitor for active window
WinGetPos, WinX, WinY, WinW, WinH, A
; Determine which monitor contains (WinX, WinY)
```

---

## Testing & Quality Assurance

### Automated Testing

**GitHub Actions Workflow:** `ahk-lint-format-compile.yml`

**What Gets Tested:**
1. ✅ **Syntax Validation** - All .ahk files compile without errors
2. ✅ **Format Validation** - No mixed indentation, trailing spaces, mixed line endings
3. ✅ **AutoHotkey Version** - Ensures AHK 2.0.19 compatibility

**How to Test Locally:**

#### Windows PowerShell Method
```powershell
# Install AutoHotkey 2.0.19
choco install autohotkey --version=2.0.19 -y

# Syntax check all scripts
$compiler = "$env:ProgramFiles\AutoHotkey\Compiler\Ahk2Exe.exe"
Get-ChildItem -Recurse -Filter *.ahk | ForEach-Object {
    Write-Host "Checking: $($_.Name)"
    & $compiler /in $_.FullName /out temp.exe 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ $($_.Name)" -ForegroundColor Green
        Remove-Item temp.exe -ErrorAction SilentlyContinue
    } else {
        Write-Host "❌ $($_.Name)" -ForegroundColor Red
    }
}
```

#### Manual Testing

**For Script Changes:**
1. Run the modified script in a test environment
2. Verify all hotkeys work as expected
3. Check for error dialogs or unexpected behavior
4. Test edge cases (missing dependencies, wrong paths, etc.)

**For Library Changes (Lib/):**
1. Identify all scripts that include the modified library
2. Test at least 3-5 dependent scripts
3. Verify no regressions in existing functionality

### Code Review Checklist

**Before Submitting PR:**

- [ ] Code passes GitHub Actions workflow
- [ ] Indentation is 4 spaces (not tabs)
- [ ] No trailing whitespace
- [ ] CRLF line endings for .ahk files
- [ ] UTF-8 encoding
- [ ] Performance directives included
- [ ] No hardcoded user paths (use `A_ScriptDir`, environment vars)
- [ ] Proper error handling (WinWait timeouts, null checks)
- [ ] Comments added for complex logic
- [ ] Variables follow naming conventions

**Security Checklist:**
- [ ] No command injection vulnerabilities (validate user input)
- [ ] No SQL injection (if using databases)
- [ ] No arbitrary file writes to system directories
- [ ] Admin privileges only when necessary

---

## Known Issues & Technical Debt

**Source:** `AHK/Documentation/Optimizations.txt` (updated 2025-11-19)

### HIGH Priority Issues

#### 1. Command Injection Vulnerabilities ✅ FIXED (2025-12-17)

**Affected Files:**
- `Other/Downloader/YT_Downloader.ahk`
- `Other/Downloader/Spotify_Downloader.ahk`
- `Other/Downloader/YT_Spotify_Downloader.ahk`

**Issue:** URLs from user input passed directly to command line without validation

**Risk:** Malicious URLs could execute arbitrary commands

**Fix Applied:**
```autohotkey
; ValidateInput() function added to all downloader scripts
ValidateInput(input) {
    ; Check for dangerous characters that could enable command injection
    ; Dangerous: & | ; < > ( ) $ ` ^ "
    if RegExMatch(input, "[&|;<>()`$^""]") {
        return false
    }
    return true
}

; Validation before execution
RunCmd:
  GuiControlGet, Link
  if (!ValidateInput(Link)) {
      MsgBox, 16, Security Error, Invalid characters detected in URL!
      return
  }
  ; ... execute command
```

**Status:** All three downloader scripts now validate user input before execution

#### 2. Hardcoded User Paths

**Affected Files:** Multiple scripts (search for "janni", "Jannik", "Users\")

**Issue:** Paths like `C:\Users\janni\` break on other systems

**Recommendation:**
```autohotkey
; Instead of:
configPath := "C:\Users\janni\Documents\config.ini"

; Use:
configPath := A_MyDocuments . "\config.ini"
; Or:
configPath := A_ScriptDir . "\config.ini"
; Or:
configPath := EnvGet("OneDrive") . "\config.ini"
```

#### 3. Missing WinWait Timeouts

**Affected Files:**
- `Lib/WindowManager.ahk`
- `Lib/AutoStartHelper.ahk`
- Various auto-start scripts

**Issue:** Scripts hang indefinitely if window/process never appears

**Current:**
```autohotkey
WinWait, ahk_exe game.exe  ; Hangs forever
```

**Recommendation:**
```autohotkey
WinWait, ahk_exe game.exe,, 10  ; 10 second timeout
if ErrorLevel {
    MsgBox, Game did not start within 10 seconds
    ExitApp
}
```

### MEDIUM Priority Issues

#### 4. Code Duplication ✅ ADDRESSED (2025-12-17)

**Between Files:**
- `GUI_Laptop.ahk` and `GUI_PC.ahk` (90% identical)
- `SetWindowBorderless()` duplicated in 3 files
- Performance directives copy-pasted (now in `AHK_Common.ahk`)
- 9 auto-start scripts (95% identical)

**Actions Taken:**
- ✅ Created shared `GUI_Shared.ahk` library with data-driven design
- ✅ GUI_PC and GUI_Laptop now use shared framework with configuration arrays
- ✅ Consolidated 9 auto-start scripts → `AutoStartManager.ahk` + `AutoStartConfig.ini`
- ✅ Consolidated 3 fullscreen variants → single `Fullscreen.ahk`
- ✅ All shared functions moved to `Lib/v1/` and `Lib/v2/`
- ✅ All scripts use `InitScript()` for initialization

**Remaining:**
- GUI_Laptop.ahk and GUI_PC.ahk still separate (different button layouts justify separation)

#### 5. WM.ahk INI Pollution

**Issue:** `AHK/GUI/WM.ahk` writes to INI file 2.8 times per second (100ms polling)

**Impact:** Unnecessary disk I/O, potential SSD wear

**Recommendation:**
```autohotkey
; Only write on change
if (currentValue != lastValue) {
    IniWrite, %currentValue%, config.ini, Section, Key
    lastValue := currentValue
}
```

### LOW Priority Issues

#### 6. Inconsistent Variable Naming

**Mixed Styles:**
- `ScriptPID` (PascalCase)
- `winTitle` (camelCase)
- `script_path` (snake_case)

**Recommendation:** Standardize on PascalCase for globals, camelCase for locals

#### 7. Magic Numbers

**Example from AFK scripts:**
```autohotkey
Sleep 5734  ; Why 5734? Document the reason
Click 1920, 1080  ; Hardcoded screen coordinates
```

**Recommendation:**
```autohotkey
; Better:
FISHING_CAST_DELAY := 5734  ; Optimal delay for server response
SCREEN_CENTER_X := 1920
SCREEN_CENTER_Y := 1080
Click %SCREEN_CENTER_X%, %SCREEN_CENTER_Y%
```

---

## Development Guidelines for AI Assistants

### Golden Rules

1. **ALWAYS read files before modifying** - Never propose changes to code you haven't seen
2. **Test library changes thoroughly** - Lib/ changes affect many scripts
3. **Follow established patterns** - Don't introduce new architectures
4. **Prioritize performance** - Gaming/automation requires speed
5. **Windows-first mentality** - CRLF, Windows APIs, no cross-platform concerns
6. **Validate against CI/CD** - Your changes MUST pass `ahk-lint-format-compile.yml`

### Workflow for Code Changes

#### Step 1: Understand Context
```
1. Read the modified file(s) completely
2. Identify all #Include statements
3. Read included library files
4. Search for similar patterns in codebase (use Grep)
5. Check AHK/Documentation/Optimizations.txt for known issues
```

#### Step 2: Make Changes
```
1. Apply edits following EditorConfig settings
2. Add comments for non-obvious logic
3. Update function documentation if changing signatures
4. Ensure proper error handling (timeouts, null checks)
5. Remove any debugging code (MsgBox, ToolTip, etc.)
```

#### Step 3: Validate
```
1. Check indentation (4 spaces)
2. Remove trailing whitespace
3. Ensure CRLF line endings
4. Verify no hardcoded paths
5. Test if possible (run script, check for errors)
```

#### Step 4: Document
```
1. Update comments if behavior changed
2. Add entry to Optimizations.txt if fixing known issue
3. Update CLAUDE.md if adding new patterns
4. Write clear commit message
```

### Common Tasks

#### Adding a New Auto-Start Script

**File:** `Other/Auto_start_Fullscreen_NewEmulator.ahk`

```autohotkey
#Include %A_ScriptDir%\..\Lib\AHK_Common.ahk
#Include %A_ScriptDir%\..\Lib\AutoStartHelper.ahk

InitScript(true, true)
#SingleInstance Force
#NoEnv

AutoStartFullscreen("newemulator.exe", "F11", true, 0)
return
```

**Testing:**
1. Run manually
2. Verify it exits after sending F11
3. Test with emulator not running (should hang or timeout)

---

#### Adding a New Shared Function

**File:** `Lib/WindowManager.ahk` (add at bottom)

```autohotkey
; ============================================================================
; NewFunction(param1, param2) - Brief description
;
; Detailed explanation
;
; Parameters:
;   param1 - Description
;   param2 - Description (default: value)
; ============================================================================
NewFunction(param1, param2 := "default") {
    ; Implementation
}
```

**Testing:**
1. Create test script that uses the function
2. Identify 2-3 existing scripts that could benefit
3. Update those scripts to use new function
4. Run all modified scripts

---

#### Fixing a Syntax Error

**From GitHub Actions:**
```
❌ AHK/TestScript.ahk - syntax error
```

**Process:**
1. Read the file
2. Compile locally to see error details:
   ```powershell
   & "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" /in AHK/TestScript.ahk /out temp.exe
   ```
3. Common errors:
   - Missing `return` at end of auto-execute section
   - Unmatched braces `{ }`
   - Invalid variable names
   - Incorrect function calls
4. Fix error
5. Recompile to verify
6. Commit with clear message: `fix: Syntax error in TestScript.ahk - missing return`

---

#### Refactoring Duplicated Code

**Example:** Unify `GUI_Laptop.ahk` and `GUI_PC.ahk`

**Approach:**
1. Read both files
2. Identify differences (likely just button labels and paths)
3. Extract differences to configuration:
   ```autohotkey
   ; GUI_Shared.ahk
   #Include %A_ScriptDir%\..\Lib\AHK_Common.ahk
   InitScript()

   ; Load config
   IniRead, ProfileName, %A_ScriptDir%\GUI_Config.ini, Profile, Name

   ; Use config to customize GUI
   Gui, New, -MinimizeBox, %ProfileName% Launcher
   ```
4. Create `GUI_Config_Laptop.ini` and `GUI_Config_PC.ini`
5. Test both configurations
6. Update documentation

---

### Working with External Tools

#### yt-dlp (YouTube Downloader)

**Location:** `Other/Downloader/YT_Downloader.ahk`

**Integration Pattern:**
```autohotkey
; Get URL from GUI
Gui Submit, NoHide
url := %GuiURLField%

; Build command
ytdlpPath := A_ScriptDir . "\yt-dlp.exe"
outputPath := A_MyDocuments . "\Music"
cmd := """" . ytdlpPath . """ -f ""bv*[height<=1080]+ba"" """ . url . """ -o """ . outputPath . "\%(title)s.%(ext)s"""

; Execute and capture output
RunWait, %ComSpec% /c %cmd% > output.txt 2>&1,, Hide
FileRead, Output, output.txt

; Display output
GuiControl,, OutputField, %Output%
```

**Dependencies:**
- yt-dlp.exe (in script directory)
- FFMPEG (for audio merging)

**Update Script:** `Other/Downloader/YT-DLP_update.cmd`

---

#### MultiMonitorTool (NirSoft)

**Location:** `Other/Playnite_fullscreen/MultiMonitorTool/`

**Integration Pattern:**
```autohotkey
mmt := A_ScriptDir . "\MultiMonitorTool\MultiMonitorTool.exe"

; Load saved config
Run, "%mmt%" /LoadConfig "TVMode.cfg"

; Disable specific monitor
Run, "%mmt%" /disable 2

; Set primary monitor
Run, "%mmt%" /SetPrimary 1
```

**Config Files:**
- `MultiMonitorTool.cfg` - Saved display configurations
- Created via GUI, then loaded programmatically

---

### Debugging Techniques

#### Method 1: Message Boxes

```autohotkey
MsgBox, Variable value: %var%
MsgBox, % "Expression result: " . (1 + 2)
```

**Remove before committing!**

---

#### Method 2: Tooltips

```autohotkey
ToolTip, Checkpoint 1
Sleep 2000
ToolTip  ; Clear tooltip
```

**Better for non-blocking debug info**

---

#### Method 3: Log Files

```autohotkey
LogFile := A_ScriptDir . "\debug.log"
FileAppend, %A_Now% - Script started`n, %LogFile%
FileAppend, %A_Now% - Variable: %var%`n, %LogFile%
```

**Remember to add debug.log to .gitignore**

---

#### Method 4: ListLines/KeyHistory (Temporary)

```autohotkey
; At top of script (comment out optimizations)
; ListLines Off  ; COMMENTED for debugging
; #KeyHistory 0  ; COMMENTED for debugging

; After suspected issue:
ListLines
KeyHistory
```

**Re-enable optimizations after debugging**

---

### Security Considerations

#### Input Validation

**Always validate user input before:**
- Executing commands
- Writing files
- Modifying registry

**Example:**
```autohotkey
; Bad:
Run, %ComSpec% /c %UserInput%

; Good:
if RegExMatch(UserInput, "^[a-zA-Z0-9_-]+$") {
    Run, %ComSpec% /c %UserInput%
} else {
    MsgBox, Invalid input
}
```

---

#### Path Traversal Prevention

```autohotkey
; Bad:
userFile := A_ScriptDir . "\" . UserInput
FileRead, Content, %userFile%

; Good:
if InStr(UserInput, "..") or InStr(UserInput, "\") {
    MsgBox, Invalid filename
    return
}
userFile := A_ScriptDir . "\" . UserInput
if !FileExist(userFile) {
    MsgBox, File not found
    return
}
FileRead, Content, %userFile%
```

---

#### Admin Privilege Minimization

**Use admin only when necessary:**
- Modifying system power plans ✅
- Manipulating other user's windows ✅
- Reading/writing own directories ❌
- Standard hotkeys ❌

**Pattern:**
```autohotkey
; Check if admin actually needed
needsAdmin := (action = "PowerPlan") or (action = "SystemSettings")

if needsAdmin {
    InitScript(true, true)  ; UIA + Admin
} else {
    InitScript(true, false)  ; UIA only
}
```

---

### Performance Optimization Tips

#### 1. Use SetBatchLines -1

**Already in `SetOptimalPerformance()`, but important to understand:**

```autohotkey
SetBatchLines -1  ; Run at maximum speed
SetBatchLines 10  ; Run 10ms, sleep 10ms (default)
```

**When to reduce:**
- Script causes 100% CPU usage
- Other apps become unresponsive
- Not time-critical operations

---

#### 2. Avoid Unnecessary Loops

**Bad:**
```autohotkey
Loop {
    Sleep 10
    if WinExist("ahk_exe game.exe")
        break
}
```

**Good:**
```autohotkey
WinWait, ahk_exe game.exe,, 30
if ErrorLevel {
    MsgBox, Timeout
    ExitApp
}
```

---

#### 3. Use SendInput Instead of Send

**Already in `SetOptimalPerformance()` via `SendMode Input`**

**Speed comparison:**
- `SendInput` - Fastest, uninterruptible
- `SendPlay` - Slower, most compatible
- `SendEvent` - Medium, can be interrupted

---

#### 4. Cache Frequent Calculations

**Bad:**
```autohotkey
Loop, 1000 {
    result := ComplexFunction(sameValue)
}
```

**Good:**
```autohotkey
cachedResult := ComplexFunction(sameValue)
Loop, 1000 {
    result := cachedResult
}
```

---

#### 5. Use DllCall for Precise Sleep

**AHK's Sleep is rounded to 10-15ms, DllCall is exact:**

```autohotkey
Sleep 100  ; Actually sleeps 100-115ms

DllCall("Sleep", UInt, 100)  ; Exactly 100ms
```

**Trade-off:** DllCall uses slightly more CPU

**When to use:** Timing-critical scripts (AFK macros, rhythm games)

---

### Contributing to This Guide

**When to Update CLAUDE.md:**

1. **New Pattern Added** - Document it in "Common Patterns & Templates"
2. **Library Function Added** - Add to "Key Components & Libraries"
3. **Known Issue Fixed** - Update "Known Issues & Technical Debt"
4. **Convention Changed** - Update "Coding Conventions & Standards"
5. **New Workflow Added** - Update "Development Workflows & CI/CD"

**Update Process:**
```
1. Make changes to CLAUDE.md
2. Update "Last Updated" date at top
3. Add changelog entry if significant
4. Commit with message: "docs: Update CLAUDE.md - [brief description]"
5. Push to repository
```

---

## Appendix

### Useful Resources

**AutoHotkey Documentation:**
- Official Docs: https://www.autohotkey.com/docs/
- Forum: https://www.autohotkey.com/boards/

**Optimization Guides:**
- AHK Forum Post: https://www.autohotkey.com/boards/viewtopic.php?t=6413
- ElitePvpers Guide: https://www.elitepvpers.com/forum/programming-tutorials/4642814-guide-autohotkey-timing-precision-sleep-alternative.html

**Windows API:**
- Window Styles: https://learn.microsoft.com/en-us/windows/win32/winmsg/window-styles
- Extended Styles: https://learn.microsoft.com/en-us/windows/win32/winmsg/extended-window-styles

**External Tools:**
- MultiMonitorTool: https://www.nirsoft.net/utils/multi_monitor_tool.html
- yt-dlp: https://github.com/yt-dlp/yt-dlp
- spotdl: https://github.com/spotDL/spotify-downloader

### Glossary

**AFK** - Away From Keyboard (automated scripts for games)

**AHK** - AutoHotkey scripting language

**GUI** - Graphical User Interface

**PID** - Process ID (unique identifier for running processes)

**UIA** - UI Automation (AutoHotkey accessibility mode)

**WinTitle** - AutoHotkey window identifier (can be title, class, exe, PID)

**Borderless Fullscreen** - Maximized window without title bar/borders (fake fullscreen)

**CRLF** - Carriage Return + Line Feed (`\r\n`, Windows line endings)

**LF** - Line Feed (`\n`, Unix line endings)

---

## Changelog

### 2025-12-17
- **MAJOR:** Completed AutoHotkey v2 migration (35+ scripts migrated)
- Created dual library architecture (Lib/v1/ and Lib/v2/)
- Consolidated 9 auto-start scripts into data-driven AutoStartManager.ahk
- Unified 3 fullscreen variants into single Fullscreen.ahk
- Migrated all AFK macros (Black Ops 6, Minecraft) to v2
- Migrated all GUI scripts (GUI_PC, GUI_Laptop, GUI_Shared, WM) to v2
- Migrated all Playnite launcher scripts (4 variants) to v2
- **SECURITY:** Fixed command injection vulnerability in all downloader scripts
- Updated CI/CD workflow for automatic v1/v2 version detection
- Added comprehensive v2 migration documentation and syntax reference
- Updated Known Issues section (2 HIGH priority issues resolved)
- Reduced codebase by 13 duplicate/redundant files

### 2025-12-04
- Initial creation of CLAUDE.md
- Documented all major components and patterns
- Added comprehensive development guidelines
- Included known issues from Optimizations.txt
- Added security and performance sections

---

**For questions or clarifications, refer to:**
- `AHK/Documentation/Optimizations.txt` - Detailed optimization history
- `readme.md` - User-facing project overview
- Individual script READMEs in subdirectories

**Repository:** https://github.com/Ven0m0/Scripts
**Maintainer:** Ven0m0 (ven0m0.wastaken@gmail.com)

---

*This document is maintained as part of the Scripts repository to assist AI assistants and developers in understanding and contributing to the codebase effectively.*
