# AHK_v2 - AutoHotkey v2 Scripts

This directory contains AutoHotkey v2.0 scripts for gaming automation, window management, and system utilities. All scripts in this directory use the modern v2 syntax and require AutoHotkey v2.0.19+.

## Directory Structure

```
AHK_v2/
├── Black_ops_6/         # Call of Duty Black Ops 6 AFK macros
├── Minecraft/           # Minecraft AFK farming scripts
├── GUI/                 # GUI launcher applications
├── ControllerQuit.ahk   # Quit apps with controller button combo
├── Fullscreen.ahk       # Borderless fullscreen toggle
├── Keys.ahk             # Comprehensive hotkey suite
└── Powerplan.ahk        # Automatic power plan switching
```

## Scripts Overview

### Window Management

#### Fullscreen.ahk

**Purpose:** Toggle borderless fullscreen on any window with multi-monitor support

**Hotkeys:**
- `End` - Toggle borderless fullscreen on active window

**Features:**
- Multi-monitor aware (detects current monitor)
- Saves and restores window state
- Works with games that don't have native borderless mode

**Usage:**
```bash
# Run the script
Fullscreen.ahk

# Press End key while a game window is active
# Press End again to restore original state
```

**Requirements:**
- AutoHotkey v2.0.19+
- Admin privileges (for some applications)

---

### System Utilities

#### Powerplan.ahk

**Purpose:** Automatically switch Windows power plan based on running applications

**Features:**
- Monitors for specific game processes
- Switches to High Performance when game is running
- Reverts to Balanced when game closes
- Runs silently in system tray

**Default Configuration:**
- Monitors for: Fortnite
- High Performance: When game running
- Balanced: When game not running

**Customization:**
```autohotkey
; Edit the script to monitor different processes
processName := "YourGame.exe"

; Change power plans
highPerfGUID := "{8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c}"
balancedGUID := "{381b4222-f694-41f0-9685-ff5bb260df2e}"
```

**Usage:**
```bash
# Run the script (starts in system tray)
Powerplan.ahk

# Right-click tray icon to exit
```

**Requirements:**
- AutoHotkey v2.0.19+
- Admin privileges (required for power plan changes)

---

#### ControllerQuit.ahk

**Purpose:** Close applications using gamepad button combinations

**Hotkeys:**
- `Guide + Start + B` - Close active window

**Features:**
- Works with Xbox controllers
- Customizable button combinations
- Useful for controller-only setups (couch gaming)

**Usage:**
```bash
# Run the script
ControllerQuit.ahk

# Hold Guide + Start + B to close active window
```

**Requirements:**
- AutoHotkey v2.0.19+
- Xbox-compatible controller

---

#### Keys.ahk

**Purpose:** Comprehensive hotkey suite for productivity and window management

**Hotkeys:**
- `Win+Arrow Keys` - Snap windows to screen edges
- `Win+J` - Rename file with date prefix
- `Alt+Wheel` - Adjust system volume
- `Alt+MButton` - Mute/unmute
- `Win+T` - Always on top toggle
- See script for complete list

**Features:**
- Window snapping and positioning
- File management shortcuts
- Media control integration
- System-wide hotkeys

**Usage:**
```bash
# Run the script
Keys.ahk

# Use hotkeys as needed
# Press F1 for built-in help (if available)
```

**Requirements:**
- AutoHotkey v2.0.19+
- Some features may require admin privileges

---

### Gaming Automation

#### Black_ops_6/

Black Ops 6 AFK farming macros for XP and camo grinding.

See [Black_ops_6/README.md](Black_ops_6/README.md) for details.

**Scripts:**
- `bo6-afk.ahk` - Main AFK macro

**Features:**
- Automated movement and actions
- Customizable timing and patterns
- Pause/resume functionality

---

#### Minecraft/

Minecraft AFK automation for farming and resource gathering.

See [Minecraft/README.md](Minecraft/README.md) for details.

**Scripts:**
- `MC_AFK.ahk` - General AFK script
- `MC_Bedrock.ahk` - Bedrock Edition specific

**Features:**
- AFK fishing
- Auto-farming
- Mob grinder automation

---

### GUI Applications

#### GUI/

Centralized script launchers with graphical interface.

See [GUI/README.md](GUI/README.md) for details.

**Scripts:**
- `GUI.ahk` - Main launcher
- `GUI_Shared.ahk` - Shared framework
- `WM.ahk` - Window management GUI

**Features:**
- Launch multiple scripts from one interface
- Monitor script status
- Quick access to common tasks

---

## Common Features

### All v2 Scripts Include:

1. **Modern Syntax**
   - Function-based syntax: `MsgBox("text")`
   - Proper parameter passing
   - Try/catch error handling

2. **Performance Optimization**
   - Automatic via `InitScript()` from Lib/v2/AHK_Common.ahk
   - Maximum execution speed
   - Minimal overhead

3. **Multi-Monitor Support**
   - Most window management scripts detect monitor configuration
   - Proper positioning on secondary displays

4. **Error Handling**
   - Timeouts for window/process waits
   - User-friendly error messages
   - Graceful failure modes

## Usage Tips

### Running Scripts

**Method 1: Double-click**
```bash
# Simply double-click any .ahk file
Fullscreen.ahk
```

**Method 2: Command line**
```bash
# From AutoHotkey installation
"C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe" Fullscreen.ahk

# If AutoHotkey is in PATH
autohotkey Fullscreen.ahk
```

**Method 3: Compiled executable**
```bash
# Compile to .exe first (optional)
Ahk2Exe /in Fullscreen.ahk /out Fullscreen.exe

# Then run
Fullscreen.exe
```

### Hotkey Conflicts

If hotkeys conflict with other applications:

1. **Edit the script** and change the hotkey
2. **Use context-specific hotkeys:**
   ```autohotkey
   #HotIf WinActive("ahk_exe game.exe")
   End::ToggleFullscreen()
   #HotIf
   ```

3. **Disable conflicting scripts**

### Debugging

If a script isn't working:

1. **Check AutoHotkey version:**
   ```bash
   autohotkey --version
   # Should be v2.0.19 or higher
   ```

2. **Run from command line to see errors:**
   ```bash
   autohotkey script.ahk
   ```

3. **Check for admin privileges:**
   ```ahk
   ; Add to script for debugging
   if !A_IsAdmin {
       MsgBox("Script needs admin privileges")
   }
   ```

4. **Enable debugging output:**
   ```ahk
   ; Temporarily add at top of script
   #Warn All
   MsgBox("Script started")
   ```

## Migration from v1

If you're familiar with AutoHotkey v1:

### Key Syntax Changes

| v1 | v2 |
|----|-----|
| `MsgBox, text` | `MsgBox("text")` |
| `WinWait, title` | `WinWait("title")` |
| `WinGet, var, Style` | `var := WinGetStyle()` |
| `SetTimer, Label, 1000` | `SetTimer(Function, 1000)` |
| `Object()` | `Map()` |
| `%var%` in strings | Just `var` |

### Migration Guide

See [CLAUDE.md](../CLAUDE.md#autohotkey-v2-migration-status) for comprehensive migration information.

## Development

### Creating New Scripts

**Template for new v2 scripts:**

```autohotkey
; =============================================================================
; Script Name: MyScript.ahk
; Description: What the script does
; Author: Your Name
; Version: 1.0.0
; Last Updated: YYYY-MM-DD
; 
; Requirements:
;   - AutoHotkey v2.0.19+
;   - Admin privileges (if needed)
; 
; Usage:
;   Brief usage instructions
; 
; Hotkeys:
;   F1 - Action description
; =============================================================================

#Requires AutoHotkey v2.0
#SingleInstance Force
SendMode "Input"
SetWorkingDir A_ScriptDir

; Include shared libraries
#Include A_ScriptDir "\..\Lib\v2\AHK_Common.ahk"

; Initialize script (UIA not needed in v2, admin if needed, optimize=true)
InitScript(false, false, true)

; Your code here

; Hotkeys
F1::MyFunction()

; Functions
MyFunction() {
  MsgBox("Hello from v2!")
}
```

### Best Practices

1. **Use shared libraries:** Include from `Lib/v2/` instead of duplicating code
2. **Add error handling:** Use try/catch for risky operations
3. **Use timeouts:** Never use infinite waits
4. **Document hotkeys:** Add comments or help system
5. **Test on multiple monitors:** If using window management
6. **Follow naming conventions:** See [CONTRIBUTING.md](../CONTRIBUTING.md)

### Testing

**Before committing:**

1. Test script functionality
2. Verify hotkeys work as expected
3. Check for error dialogs
4. Test on different screen resolutions (if applicable)
5. Test with/without admin privileges

## Troubleshooting

### Common Issues

**Issue: Script won't run**
- Check AutoHotkey v2 is installed
- Right-click script → Edit → Check for syntax errors
- Run from command line to see error messages

**Issue: Hotkeys don't work**
- Check for conflicting hotkeys
- Verify script is running (check system tray)
- Try running with admin privileges

**Issue: Window functions fail**
- Use Window Spy (comes with AHK) to get exact window title
- Add timeout handling
- Verify window exists before operations

**Issue: Multi-monitor problems**
- Check monitor configuration in Windows settings
- Verify monitors are detected by script
- Test on primary monitor first

## Resources

- [AutoHotkey v2 Documentation](https://www.autohotkey.com/docs/v2/)
- [v1 to v2 Changes](https://www.autohotkey.com/docs/v2/v2-changes.htm)
- [CLAUDE.md](../CLAUDE.md) - Detailed developer guide
- [CONTRIBUTING.md](../CONTRIBUTING.md) - Contribution guidelines

## Contributing

Contributions are welcome! Please:

1. Follow v2 syntax and conventions
2. Test thoroughly before submitting
3. Update documentation
4. Add header comments to new scripts

See [CONTRIBUTING.md](../CONTRIBUTING.md) for detailed guidelines.

---

**Last Updated:** 2025-12-26
**AutoHotkey Version:** v2.0.19+
