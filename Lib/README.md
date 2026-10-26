# Lib - Shared Library Framework

This directory contains the shared AutoHotkey v2.0 library files used across scripts in the
repository. The libraries provide common functionality for initialization and window management.

## Architecture

```
Lib/
├── AHK_Common.ahk               # v2 initialization utilities
└── WindowManager.ahk            # v2 window manipulation
```

Tests live in `tests/<Module>_Test.ahk` and use `tests/TestKit.ahk`.

## Library Files

### AHK_Common.ahk

**Purpose:** Core initialization and setup utilities

**Functions:**

- `InitScript(requireAdmin, optimize)` - One-call initialization for common requirements
- `RequireAdmin(host := "")` - Restarts script with administrator privileges; `host` is a test seam (see `SystemHost`)
- `SetOptimalPerformance()` - Applies performance optimizations

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

**Purpose:** Window placement (see `GLOSSARY.md`): fake fullscreen, snap, and restore, each on
the window's own monitor. The first placement remembers the window's geometry; restore returns
to it, so snap, fullscreen, restore lands back on the original window.

**Functions:**

- `ToggleFakeFullscreen(winTitle := "A")`
  - Strips borders and fills the window's monitor; a second call restores it
  - Returns true when the window is now fullscreen

- `SnapWindow(side, winTitle := "A")`
  - `side` is `"left"` or `"right"`; fills that part of the monitor's work area
  - Left width is 2/3 of the work area, capped at 1024px; right takes the rest
  - Non-resizable windows are moved, not resized

- `RestoreWindow(winTitle := "A")`
  - Returns the window to its remembered geometry; false when nothing is remembered

- `GetMonitorAtPos(x, y)`
  - Monitor index containing the point, or -1

- `WaitForWindow(winTitle, timeout)`
  - Safe window waiting with timeout
  - Returns true if found, false if timeout

- `WaitForProcess(processName, timeout)`
  - Safe process waiting with timeout
  - Returns true if found, false if timeout

**Usage:**

```autohotkey
#Include A_ScriptDir "\..\Lib\WindowManager.ahk"

; Toggle fake fullscreen, snap, restore
End::ToggleFakeFullscreen()
#Left::SnapWindow("left")
#Down::RestoreWindow()

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
