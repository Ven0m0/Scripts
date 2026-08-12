# Lib - Shared Library Framework

This directory contains the shared AutoHotkey v2.0 library files used across scripts in the
repository. The libraries provide common functionality for initialization and window management.

## Architecture

```
Lib/
├── AHK_Common.ahk               # v2 initialization utilities
├── WindowManager.ahk            # v2 window manipulation
└── test_RequireAdmin.ahk        # standalone test for RequireAdmin()
```

## Library Files

### AHK_Common.ahk

**Purpose:** Core initialization and setup utilities

**Functions:**

- `InitScript(requireAdmin, optimize)` - One-call initialization for common requirements
- `RequireAdmin(...)` - Restarts script with administrator privileges
- `SetOptimalPerformance()` - Applies performance optimizations
- `FindExe(name, fallbacks)` - Resolves an executable via direct path, `PATH`, then fallbacks
- `MustGetExe(name, fallbacks, ...)` - Same as `FindExe`, but shows an error and exits if not found

**Usage:**

```autohotkey
#Include A_ScriptDir "\..\Lib\AHK_Common.ahk"
InitScript(true, true)  ; Require Admin + Performance optimization
```

**Performance Optimizations Applied:**

- `SetKeyDelay -1, -1` - No key delays
- `SetMouseDelay -1` - No mouse delays
- `SetDefaultMouseSpeed 0` - Instant mouse movement
- `SetWinDelay -1` - No window operation delays
- `SetControlDelay -1` - No control operation delays
- `SendMode "Input"` - Fastest send mode

### WindowManager.ahk

**Purpose:** Window manipulation and multi-monitor management

**Functions:**

- `ToggleFakeFullscreenMultiMonitor(winTitle)` — most used
  - Multi-monitor aware borderless fullscreen toggle
  - Detects current monitor and calculates bounds
  - Saves/restores window state

- `ToggleFakeFullscreen(winTitle)`
  - Single-monitor borderless fullscreen toggle
  - Always uses primary monitor dimensions

- `SetWindowBorderless(winTitle)`
  - Removes window borders and title bar

- `MakeFullscreen(winTitle)`
  - Combined borderless + maximize operation

- `RestoreWindowBorders(winTitle)`
  - Restores window borders after borderless mode

- `MaximizeWindow(winTitle)`
  - Maximizes window to full screen

- `WaitForWindow(winTitle, timeout)`
  - Safe window waiting with timeout
  - Returns true if found, false if timeout

- `WaitForProcess(processName, timeout)`
  - Safe process waiting with timeout
  - Returns true if found, false if timeout

**Usage:**

```autohotkey
#Include A_ScriptDir "\..\Lib\WindowManager.ahk"

; Toggle borderless fullscreen
End::ToggleFakeFullscreenMultiMonitor("A")

; Wait for window with timeout
if !WaitForWindow("ahk_exe game.exe", 10) {
    MsgBox("Game window not found!")
    ExitApp
}
```

## Best Practices

### Including Libraries

**Always use relative paths from script directory:**

```autohotkey
; Good
#Include A_ScriptDir "\..\Lib\AHK_Common.ahk"

; Bad (hardcoded path)
#Include "C:\Scripts\Lib\AHK_Common.ahk"
```

### Timeout Handling

**Always use timeouts for window/process waits:**

```autohotkey
; Good
if !WaitForWindow("ahk_exe game.exe", 10) {
    MsgBox("Timeout waiting for game")
    ExitApp
}

; Bad (infinite wait)
WinWait("ahk_exe game.exe")
```

## Testing Library Changes

**CRITICAL:** Changes to library files affect ALL dependent scripts!

1. **Identify dependent scripts:**
   ```bash
   grep -r "AHK_Common.ahk" --include="*.ahk"
   grep -r "WindowManager.ahk" --include="*.ahk"
   ```
2. **Test the dependents that surface** — different categories, simple and complex use cases.
3. **Check for breaking changes** — function signatures, return values, new required parameters.
4. **Update documentation** — `AGENTS.md`, this README, inline comments.

## Additional Resources

- [AGENTS.md](../AGENTS.md) - developer guide
- [AutoHotkey v2 Documentation](https://www.autohotkey.com/docs/v2/)
