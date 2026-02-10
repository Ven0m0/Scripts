# GitHub Copilot Instructions

> **Project:** Windows Gaming & Emulation Automation Toolkit
> **Primary Language:** AutoHotkey v2.0 (hybrid v1/v2 codebase)
> **Platform:** Windows 10/11 (Windows-specific)

---

## Quick Context

This is a **high-performance automation toolkit** for Windows gaming, emulation, and window management. Code prioritizes **speed, reliability, and low latency** for gaming use cases.

### Tech Stack

- **AutoHotkey v2.0** - Primary (45+ scripts in `ahk/`)
- **AutoHotkey v1.1** - Legacy (scripts in `Other/` with complex dependencies)
- **PowerShell** - System utilities
- **Batch/CMD** - Simple launchers

### Dual-Version Architecture

**v2 Scripts** (`ahk/`, `Lib/v2/`):
- Modern syntax with proper functions, Maps, better error handling
- Use `#Requires AutoHotkey v2.0` directive
- Include from `Lib/v2/AHK_Common.ahk`

**v1 Scripts** (`Other/Citra_*`, `Other/Downloader/`, `Lib/v1/`):
- Legacy syntax kept for complex dependencies (tf.ahk, COM objects)
- No `#Requires` directive
- Include from `Lib/v1/AHK_Common.ahk`

---

## Critical Rules

### 1. File Formatting (STRICT)

```yaml
# From .editorconfig - these are enforced by CI/CD:
*.ahk:
  indent: 4 spaces (NEVER tabs)
  line_ending: CRLF (Windows)
  charset: UTF-8
  trailing_whitespace: remove
  final_newline: insert

*.ps1, *.cmd, *.bat:
  indent: 4 spaces
  line_ending: CRLF

*.md, *.yml, *.json:
  line_ending: LF (Unix)
```

**CI/CD will FAIL on:**
- Mixed indentation (tabs + spaces)
- Trailing whitespace
- Mixed line endings

### 2. Shared Libraries (DON'T DUPLICATE)

**ALWAYS use these instead of writing inline code:**

```autohotkey
#Include %A_ScriptDir%\..\Lib\v2\AHK_Common.ahk      ; or Lib\v1\ for v1 scripts
#Include %A_ScriptDir%\..\Lib\v2\WindowManager.ahk
#Include %A_ScriptDir%\..\Lib\v2\AutoStartHelper.ahk
```

**Available Functions:**
- `InitScript(uia, admin)` - One-call initialization (UIA + Admin + Performance)
- `ToggleFakeFullscreenMultiMonitor(winTitle)` - Multi-monitor borderless fullscreen
- `WaitForWindow(winTitle, timeout)` - Safe window waiting
- `AutoStartFullscreen(exeName, fullscreenKey, maximize, delay)` - Emulator auto-fullscreen

⚠️ **Modifying `Lib/` files affects 30+ scripts** - test thoroughly!

### 3. Performance Optimization

**v2 scripts** (use `InitScript()`):
```autohotkey
#Requires AutoHotkey v2.0
#Include %A_ScriptDir%\..\Lib\v2\AHK_Common.ahk
InitScript(true, true)  ; UIA + Admin + all optimizations
```

**v1 scripts** (manual directives):
```autohotkey
#SingleInstance Force
#NoEnv
#KeyHistory 0
ListLines Off
SetBatchLines -1           ; Max speed
SetKeyDelay -1, -1        ; No key delays
SetMouseDelay -1          ; No mouse delays
SetDefaultMouseSpeed 0    ; Instant
SetWinDelay -1            ; No window delays
SetControlDelay -1        ; No control delays
SendMode Input            ; Fastest send mode
```

Gaming/automation scripts **require zero-latency input** - these are non-negotiable.

---

## Code Patterns

### Pattern: Simple v2 Script

```autohotkey
#Requires AutoHotkey v2.0
#Include %A_ScriptDir%\..\Lib\v2\AHK_Common.ahk
#Include %A_ScriptDir%\..\Lib\v2\WindowManager.ahk

InitScript(true, true)  ; UIA + Admin

; Your code here
End::ToggleFakeFullscreenMultiMonitor("A")
```

### Pattern: AFK Macro (Standard Hotkeys)

```autohotkey
#Requires AutoHotkey v2.0
#Include %A_ScriptDir%\..\Lib\v2\AHK_Common.ahk
InitScript()

$*F7:: {      ; Start
    Loop {
        ; Repetitive actions
    }
}
$*F8:: Pause(-1)  ; Pause/Resume
$*F9:: ExitApp()  ; Exit
```

**Standard AFK hotkeys:** F7=Start, F8=Pause, F9=Exit

### Pattern: GUI Launcher

```autohotkey
#Requires AutoHotkey v2.0
#Include %A_ScriptDir%\..\Lib\v2\AHK_Common.ahk
InitScript()

myGui := Gui("+AlwaysOnTop -MinimizeBox", "Title")
myGui.Add("Button", "w200", "Label").OnEvent("Click", Handler)
myGui.Show()

Handler(*) {
    ; Action
}
```

---

## v1 to v2 Syntax Quick Reference

| v1 | v2 | Notes |
|----|----|----|
| `MsgBox, text` | `MsgBox("text")` | Function calls need parens |
| `WinWait, title` | `WinWait("title")` | All commands are functions |
| `Run, cmd,,, PID` | `Run(cmd,,, &PID)` | Output params use & |
| `WinGet, var, Style` | `var := WinGetStyle()` | Expression syntax |
| `SetTimer, Label, 1000` | `SetTimer(Function, 1000)` | Functions, not labels |
| `Object()` | `Map()` | New associative array type |
| `.HasKey("key")` | `.Has("key")` | Renamed method |
| `#NoEnv` | _removed_ | Not needed in v2 |

---

## Security Guidelines

**ALWAYS validate user input before:**
- Executing commands (`Run`, `RunWait`)
- Writing files (`FileAppend`, `FileWrite`)
- Modifying system settings

```autohotkey
ValidateInput(input) {
    ; Block command injection characters
    if RegExMatch(input, "[&|;<>()`$^""]") {
        return false
    }
    return true
}
```

**Never:**
- Hardcode user paths (use `A_ScriptDir`, `A_MyDocuments`, env vars)
- Skip admin checks when needed
- Leave debugging code (`MsgBox`, `ToolTip`, etc.)

---

## Common Tasks

### Adding New v2 Script

1. Create in `ahk/` directory
2. Add `#Requires AutoHotkey v2.0` directive
3. Include libraries from `Lib/v2/`
4. Call `InitScript()` for initialization
5. Use 4-space indentation, CRLF line endings
6. Test locally before committing

### Modifying Shared Libraries

1. **Read the library completely**
2. **Find ALL dependent scripts:**
   ```powershell
   Get-ChildItem -Recurse -Filter *.ahk | Select-String "Include.*LibraryName.ahk"
   ```
3. Make changes carefully
4. **Test 3-5 dependent scripts minimum**
5. Commit with detailed message

### Fixing CI/CD Failures

**Syntax errors:**
```powershell
# Compile locally to see details
& "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" /in script.ahk /out temp.exe
```

**Format errors:**
- Mixed indent → Use 4 spaces only (no tabs)
- Trailing space → Remove with editor
- Mixed line endings → Ensure CRLF for .ahk, .ps1, .cmd, .bat

---

## File Structure

```
ahk/                    # AutoHotkey v2 scripts (primary development)
├── GUI/               # Script launchers
├── Black_ops_6/       # CoD BO6 AFK macros
├── Minecraft/         # Minecraft AFK automation
├── Fullscreen.ahk    # Borderless fullscreen utility
├── Keys.ahk          # Main hotkey suite
└── Powerplan.ahk     # Auto power plan switching

Lib/
├── v2/                # v2 shared libraries (DON'T MODIFY LIGHTLY!)
│   ├── AHK_Common.ahk        # Used by ALL v2 scripts
│   ├── WindowManager.ahk     # Used by 30+ scripts
│   └── AutoStartHelper.ahk   # Used by 15+ emulator scripts
└── v1/                # v1 shared libraries (legacy)
    └── ...

Other/                 # Legacy v1 scripts & specialized tools
├── Citra_per_game_config/  # Per-game emulator settings
├── Downloader/             # YouTube/Spotify downloaders (security-patched)
├── AutoStartManager.ahk    # Unified emulator launcher (v2)
└── AutoStartConfig.ini     # Emulator configurations
```

---

## CI/CD Workflow

**Trigger:** Push to `main`/`master` or PR (when .ahk files change)

**Validation:**
1. **Version Detection** - Auto-detects v1 vs v2 by:
   - `#Requires AutoHotkey v2` directive
   - Path patterns (`Lib/v2/`, `ahk/`)
2. **Syntax Check** - Compiles with appropriate AHK version
3. **Format Check** - Validates indentation, whitespace, line endings

**Exit Codes:**
- `0` - All checks passed ✅
- `1` - Errors found ❌

See `.github/workflows/ahk-lint-format-compile.yml` for details.

---

## Naming Conventions

| Type | Convention | Example |
|------|-----------|---------|
| **v2 Scripts** | PascalCase.ahk | `Fullscreen.ahk`, `ControllerQuit.ahk` |
| **v1 Scripts** | snake_case.ahk | `Auto_start_Citra.ahk` |
| **Global Variables** | PascalCase | `ScriptPID`, `ConfigFile` |
| **Local Variables** | camelCase | `winTitle`, `processName` |
| **Functions** | PascalCase | `InitScript()`, `WaitForWindow()` |
| **Constants** | SCREAMING_SNAKE_CASE | `MAX_RETRIES`, `DEFAULT_TIMEOUT` |

---

## Additional Resources

- **Full Documentation:** `AGENTS.md` (comprehensive guide)
- **User Guide:** `README.md`
- **Contributing:** `CONTRIBUTING.md`
- **Changelog:** `CHANGELOG.md`

**AutoHotkey Docs:**
- v2: https://www.autohotkey.com/docs/v2/
- v1: https://www.autohotkey.com/docs/v1/

**Repository:** https://github.com/Ven0m0/Scripts
**License:** MIT

---

## When Suggesting Code

1. **Detect version** - Check for `#Requires AutoHotkey v2` or path (`ahk/` vs `Other/`)
2. **Use correct syntax** - v1 vs v2 have different syntax (see quick reference)
3. **Include libraries** - Don't duplicate shared code
4. **Follow formatting** - 4 spaces, CRLF, no trailing whitespace
5. **Optimize for performance** - Gaming scripts need zero latency
6. **Validate inputs** - Security is critical for user-facing scripts
7. **Test thoroughly** - Especially for library modifications

---

**Last Updated:** 2026-02-10
**Maintained by:** Ven0m0
