# Lib - Shared Library Framework

This directory contains the shared AutoHotkey library files used across all scripts in the repository. The libraries provide common functionality for initialization, window management, and emulator automation.

## Architecture

The library uses a **dual-version architecture** to support both AutoHotkey v1.1 and v2.0:

```
Lib/
├── v1/                          # AutoHotkey v1.1 libraries
│   ├── AHK_Common.ahk          # v1 initialization utilities
│   ├── AutoStartHelper.ahk     # v1 auto-fullscreen helpers
│   └── WindowManager.ahk       # v1 window manipulation
└── v2/                          # AutoHotkey v2.0 libraries
    ├── AHK_Common.ahk          # v2 initialization utilities
    ├── AutoStartHelper.ahk     # v2 auto-fullscreen helpers
    └── WindowManager.ahk       # v2 window manipulation
```

## Library Files

### AHK_Common.ahk

**Purpose:** Core initialization and setup utilities

**Functions:**

- `InitScript(requireUIA, requireAdmin, optimize)` - One-call initialization for common requirements
- `InitUIA()` - Ensures UI Automation support (v1 only; no-op in v2)
- `RequireAdmin()` - Restarts script with administrator privileges
- `SetOptimalPerformance()` - Applies performance optimizations

**Usage:**

```autohotkey
; v1 script
#Include %A_ScriptDir%\..\Lib\v1\AHK_Common.ahk
InitScript(true, true)  ; Require UIA + Admin + Performance optimization

; v2 script
#Include A_ScriptDir "\..\Lib\v2\AHK_Common.ahk"
InitScript(true, true)  ; Require Admin + Performance optimization (UIA built-in)
```

**Performance Optimizations Applied:**

- `#KeyHistory 0` - Disable key logging
- `ListLines Off` - Disable line logging
- `SetBatchLines -1` - Maximum execution speed
- `SetKeyDelay -1, -1` - No key delays
- `SetMouseDelay -1` - No mouse delays
- `SetDefaultMouseSpeed 0` - Instant mouse movement
- `SetWinDelay -1` - No window operation delays
- `SetControlDelay -1` - No control operation delays
- `SendMode Input` - Fastest send mode (v1) / `SendMode "Input"` (v2)

### WindowManager.ahk

**Purpose:** Window manipulation and multi-monitor management

**Functions:**

- `ToggleFakeFullscreenMultiMonitor(winTitle)` ⭐ Most used
  - Multi-monitor aware borderless fullscreen toggle
  - Detects current monitor and calculates bounds
  - Saves/restores window state

- `ToggleFakeFullscreen(winTitle)`
  - Single-monitor borderless fullscreen toggle
  - Always uses primary monitor dimensions

- `SetWindowBorderless(winTitle)`
  - Removes window borders and title bar
  - Applies resizable style

- `MakeFullscreen(winTitle)`
  - Combined borderless + maximize operation

- `RestoreWindowBorders(winTitle)` (v2 only)
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
; v1 script
#Include %A_ScriptDir%\..\Lib\v1\WindowManager.ahk

; Toggle borderless fullscreen on active window
End::ToggleFakeFullscreenMultiMonitor("A")

; Wait for window with timeout
if !WaitForWindow("ahk_exe game.exe", 10) {
    MsgBox, Game window not found!
    ExitApp
}

; v2 script
#Include A_ScriptDir "\..\Lib\v2\WindowManager.ahk"

; Toggle borderless fullscreen
End::ToggleFakeFullscreenMultiMonitor("A")

; Wait for window with timeout
if !WaitForWindow("ahk_exe game.exe", 10) {
    MsgBox("Game window not found!")
    ExitApp
}
```

### AutoStartHelper.ahk

**Purpose:** Automated emulator and application fullscreen launching

**Functions:**

- `AutoStartFullscreen(exeName, fullscreenKey, maximize, delay, activate)`
  - Waits for process to start
  - Activates and maximizes window
  - Sends fullscreen key
  - Exits after operation

- `AutoStartFullscreenWithTitle(winTitle, fullscreenKey, maximize, delay)`
  - Same as above but waits for window title instead of process
  - Useful when multiple instances of same process exist

**Usage:**

```autohotkey
; v1 script
#Include %A_ScriptDir%\..\Lib\v1\AutoStartHelper.ahk

; Launch Citra in fullscreen
AutoStartFullscreen("citra-qt.exe", "F11", true, 0)

; v2 script
#Include A_ScriptDir "\..\Lib\v2\AutoStartHelper.ahk"

; Launch emulator with custom key
AutoStartFullscreen("emulator.exe", "{F11}", true, 1000)

; Wait for specific window title
AutoStartFullscreenWithTitle("Game Title", "{Alt down}{Enter}{Alt up}", true, 500)
```

## Version Differences

### Key Differences Between v1 and v2

| Feature | v1 | v2 |
|---------|----|----|
| Include syntax | `#Include %A_ScriptDir%\file.ahk` | `#Include A_ScriptDir "\file.ahk"` |
| Function calls | `MsgBox, text` | `MsgBox("text")` |
| WinGet/WinSet | `WinGet, var, Style` | `var := WinGetStyle()` |
| Timer callbacks | Label-based | Function-based |
| UIA support | External executable | Built-in |
| Error handling | ErrorLevel | try/catch |
| Maps/Objects | `Object()` | `Map()` |

### Migration Notes

- v2 has UIA built-in, so `InitUIA()` is a no-op
- v2 uses function syntax for all operations
- v2 has better error handling with try/catch
- v2 requires explicit parameter passing (no implicit parameters)

## Best Practices

### Choosing v1 vs v2

**Use v1 for:**
- Maintaining existing v1 scripts
- Scripts with complex COM interactions
- Dependencies on v1-only libraries (e.g., tf.ahk)

**Use v2 for:**
- All new scripts
- Scripts being migrated from v1
- Modern syntax and error handling
- Better performance in some scenarios

### Including Libraries

**Always use relative paths from script directory:**

```autohotkey
; v1 - Good
#Include %A_ScriptDir%\..\Lib\v1\AHK_Common.ahk

; v1 - Bad (hardcoded path)
#Include C:\Scripts\Lib\v1\AHK_Common.ahk

; v2 - Good
#Include A_ScriptDir "\..\Lib\v2\AHK_Common.ahk"

; v2 - Bad (hardcoded path)
#Include "C:\Scripts\Lib\v2\AHK_Common.ahk"
```

### Performance Optimization

**Always initialize scripts with performance optimizations:**

```autohotkey
; v1
InitScript(false, false)  ; Just performance optimization

; v2
InitScript(false, false)  ; Just performance optimization
```

**When to skip optimization:**
- Debugging scripts (want to see line execution)
- Scripts that need key/mouse history for troubleshooting

### Admin Privileges

**Only require admin when necessary:**

```autohotkey
; Requires admin (system settings, other windows)
InitScript(false, true)  ; (requireUIA, requireAdmin)

; No admin needed (own window management)
InitScript(false, false)
```

**Scripts that need admin:**
- Power plan switching (Powerplan.ahk)
- System-wide hotkeys affecting other apps
- Modifying registry or system files
- Interacting with elevated processes

### Timeout Handling

**Always use timeouts for window/process waits:**

```autohotkey
; v1 - Good
if !WaitForWindow("ahk_exe game.exe", 10) {
    MsgBox, Timeout waiting for game
    ExitApp
}

; v1 - Bad (infinite wait)
WinWait, ahk_exe game.exe

; v2 - Good
if !WaitForWindow("ahk_exe game.exe", 10) {
    MsgBox("Timeout waiting for game")
    ExitApp
}

; v2 - Bad (infinite wait)
WinWait("ahk_exe game.exe")
```

## Testing Library Changes

**⚠️ CRITICAL:** Changes to library files affect ALL dependent scripts!

### Testing Process

1. **Identify dependent scripts:**
   ```bash
   # From repository root
   grep -r "AHK_Common.ahk" --include="*.ahk"
   grep -r "WindowManager.ahk" --include="*.ahk"
   grep -r "AutoStartHelper.ahk" --include="*.ahk"
   ```

2. **Test at least 5 dependent scripts:**
   - Pick scripts from different categories
   - Test both simple and complex use cases
   - Verify no regressions

3. **Check for breaking changes:**
   - Function signature changes
   - Return value changes
   - Behavior changes
   - New required parameters

4. **Update documentation:**
   - CLAUDE.md
   - This README
   - Inline comments

## Common Issues

### Issue: Script not requesting admin

**Problem:** Script doesn't elevate when it should

**Solution:**
```autohotkey
; Ensure RequireAdmin is called
InitScript(false, true)  ; Second parameter = require admin

; Or call directly
RequireAdmin()
```

### Issue: Window operations failing

**Problem:** Window functions return errors or have no effect

**Solution:**
```autohotkey
; Add error checking
if !WaitForWindow("ahk_exe game.exe", 10) {
    MsgBox, Window not found!
    ExitApp
}

; Verify window title/exe matches exactly
; Use Window Spy (comes with AHK) to get exact title
```

### Issue: Performance slower than expected

**Problem:** Scripts feel sluggish

**Solution:**
```autohotkey
; Ensure optimizations are applied
InitScript(false, false, true)  ; Third parameter = optimize (default)

; Or call directly
SetOptimalPerformance()
```

### Issue: UIA not working (v1 only)

**Problem:** Cannot interact with modern Windows UI elements

**Solution:**
```autohotkey
; Ensure UIA initialization
InitScript(true, false)  ; First parameter = require UIA

; Make sure you're using AutoHotkey_H UIA build
; Run: Other/UIA Install.ahk
```

## Contributing

When modifying library files:

1. **Document all changes** in function headers
2. **Test thoroughly** with dependent scripts
3. **Update version-specific libraries** (v1 and v2)
4. **Update CLAUDE.md** with changes
5. **Add migration notes** if breaking changes

See [CONTRIBUTING.md](../CONTRIBUTING.md) for detailed guidelines.

## Additional Resources

- [CLAUDE.md](../CLAUDE.md) - Comprehensive developer guide
- [AutoHotkey v1 Documentation](https://www.autohotkey.com/docs/v1/)
- [AutoHotkey v2 Documentation](https://www.autohotkey.com/docs/v2/)
- [v1 to v2 Migration Guide](https://www.autohotkey.com/docs/v2/v2-changes.htm)

---

**Last Updated:** 2025-12-26
