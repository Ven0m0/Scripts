# Lib - Shared Library Framework

This directory contains the shared AutoHotkey v2.0 library files used across all scripts in the repository. The libraries provide common functionality for initialization, window management, and emulator automation.

## Architecture

```
Lib/
├── AHK_Common.ahk               # v2 initialization utilities
├── AutoStartHelper.ahk          # v2 auto-fullscreen helpers
├── WindowManager.ahk            # v2 window manipulation
├── test_RequireAdmin.ahk        # standalone test for RequireAdmin()
└── Tests/                       # additional library test scripts
```

## Library Files

### AHK_Common.ahk

**Purpose:** Core initialization and setup utilities

**Functions:**

- `InitScript(requireUIA, requireAdmin, optimize)` - One-call initialization for common requirements
- `InitUIA()` - No-op in v2 (UIA is built-in); kept for signature compatibility
- `RequireAdmin()` - Restarts script with administrator privileges
- `SetOptimalPerformance()` - Applies performance optimizations

**Usage:**

```autohotkey
#Include A_ScriptDir "\..\Lib\AHK_Common.ahk"
InitScript(true, true)  ; Require Admin + Performance optimization (UIA built-in)
```

**Performance Optimizations Applied:**

- `#KeyHistory 0` - Disable key logging
- `ListLines Off` - Disable line logging
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
  - Applies resizable style

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
#Include A_ScriptDir "\..\Lib\AutoStartHelper.ahk"

; Launch emulator with custom key
AutoStartFullscreen("emulator.exe", "{F11}", true, 1000)

; Wait for specific window title
AutoStartFullscreenWithTitle("Game Title", "{Alt down}{Enter}{Alt up}", true, 500)
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

### Performance Optimization

**Always initialize scripts with performance optimizations:**

```autohotkey
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
   - AGENTS.md
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
    MsgBox("Window not found!")
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

## Contributing

When modifying library files:

1. **Document all changes** in function headers
2. **Test thoroughly** with dependent scripts
3. **Update AGENTS.md** with changes
4. **Add migration notes** if breaking changes

## Additional Resources

- [AGENTS.md](../AGENTS.md) - developer guide
- [AutoHotkey v2 Documentation](https://www.autohotkey.com/docs/v2/)

---

**Last Updated:** 2026-08-10
