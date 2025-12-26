# GUI - Script Launcher Applications

This directory contains graphical user interface (GUI) launchers for managing and running multiple AutoHotkey scripts from a centralized location.

## Scripts

### GUI.ahk

**Purpose:** Main script launcher with tabbed interface

**Features:**
- Tabbed interface for organizing scripts
- Quick launch buttons for common scripts
- Process monitoring (shows if scripts are running)
- Kill script functionality
- System tray integration

**Usage:**
```bash
# Run the launcher
GUI.ahk

# Click buttons to start/stop scripts
# Right-click tray icon for quick access
```

**Customization:**
```autohotkey
; Add your own buttons to the GUI
; Edit the tabs and button definitions in the script
```

---

### WM.ahk

**Purpose:** Window Management GUI controls

**Features:**
- Visual controls for window operations
- Borderless fullscreen toggle
- Window positioning presets
- Always-on-top toggle
- Monitor configuration display

**Usage:**
```bash
# Run the window manager
WM.ahk

# Use GUI buttons for window operations
# Select target window or use "Active Window"
```

**Functions:**
- Toggle borderless fullscreen
- Snap windows to screen edges
- Set windows always on top
- Monitor management

---

### GUI_Shared.ahk

**Purpose:** Shared framework and utilities for GUI scripts

**Description:**
This is a library file that provides common functionality for GUI applications. It is not meant to be run directly.

**Contains:**
- Shared GUI styling functions
- Common button handlers
- Process management utilities
- Configuration loading/saving

**Usage:**
```autohotkey
; Include in other GUI scripts
#Include A_ScriptDir "\GUI_Shared.ahk"

; Use shared functions
CreateStyledButton("Launch", LaunchHandler)
```

---

## Common Features

### All GUI Scripts Include:

1. **Modern GUI Design**
   - Clean, organized layout
   - Consistent styling
   - Responsive controls

2. **Process Management**
   - Track running scripts by PID
   - Show running status
   - Proper cleanup on exit

3. **Error Handling**
   - User-friendly error messages
   - Validation of inputs
   - Graceful failure handling

4. **System Tray Integration**
   - Minimize to tray
   - Tray menu for quick access
   - Status indicators

## Customization Guide

### Adding Custom Buttons

**Example: Add a new script button to GUI.ahk**

```autohotkey
; 1. Define your script path
myScriptPath := A_ScriptDir "\..\Other\MyScript.ahk"

; 2. Add button to GUI
myGui.Add("Button", "w200", "Launch My Script").OnEvent("Click", LaunchMyScript)

; 3. Add launch handler
LaunchMyScript(*) {
  global myScriptPID
  if WinExist("ahk_pid " myScriptPID) {
    MsgBox("My Script is already running!")
    return
  }
  Run(myScriptPath, , , &myScriptPID)
}

; 4. Add close button if needed
myGui.Add("Button", "w200", "Close My Script").OnEvent("Click", CloseMyScript)

CloseMyScript(*) {
  global myScriptPID
  if WinExist("ahk_pid " myScriptPID) {
    WinClose("ahk_pid " myScriptPID)
    myScriptPID := 0
  }
}
```

### Creating Custom Tabs

```autohotkey
; Add a new tab category
myGui.Add("Tab3", "w600", ["Gaming", "Utilities", "Custom"])

; Select the new tab
myGui["Tab"].Choose(3)

; Add controls to the custom tab
myGui.Add("Text", , "Custom Scripts")
myGui.Add("Button", "w200", "Custom Action").OnEvent("Click", CustomHandler)

CustomHandler(*) {
  MsgBox("Custom button clicked!")
}
```

### Changing GUI Appearance

```autohotkey
; Modify GUI properties
myGui := Gui("+AlwaysOnTop -MinimizeBox", "My Launcher")
myGui.BackColor := "0x2B2B2B"  ; Dark background
myGui.SetFont("s10 cWhite", "Segoe UI")

; Custom button styling
myButton := myGui.Add("Button", "w200 h40")
myButton.SetFont("s11 bold", "Arial")
```

## Development

### Creating a New GUI Launcher

**Template:**

```autohotkey
; =============================================================================
; Custom GUI Launcher
; =============================================================================

#Requires AutoHotkey v2.0
#SingleInstance Force
SendMode "Input"
SetWorkingDir A_ScriptDir

#Include A_ScriptDir "\GUI_Shared.ahk"  ; Optional: use shared functions
#Include A_ScriptDir "\..\..\Lib\v2\AHK_Common.ahk"

InitScript(false, false)

; Global variables for process tracking
global scriptPID := 0

; Create GUI
myGui := Gui("+AlwaysOnTop", "My Launcher")
myGui.OnEvent("Close", GuiClose)

; Add controls
myGui.Add("Text", , "Select an action:")
myGui.Add("Button", "w200", "Launch Script").OnEvent("Click", LaunchScript)
myGui.Add("Button", "w200", "Close Script").OnEvent("Click", CloseScript)
myGui.Add("Button", "w200", "Exit Launcher").OnEvent("Click", GuiClose)

; Show GUI
myGui.Show()
return

; Event handlers
LaunchScript(*) {
  global scriptPID
  scriptPath := A_ScriptDir "\..\MyScript.ahk"
  
  if WinExist("ahk_pid " scriptPID) {
    MsgBox("Script already running!")
    return
  }
  
  try {
    Run(scriptPath, , , &scriptPID)
    MsgBox("Script launched!")
  } catch as e {
    MsgBox("Failed to launch: " e.Message)
  }
}

CloseScript(*) {
  global scriptPID
  if WinExist("ahk_pid " scriptPID) {
    WinClose("ahk_pid " scriptPID)
    scriptPID := 0
    MsgBox("Script closed!")
  } else {
    MsgBox("Script is not running!")
  }
}

GuiClose(*) {
  ExitApp
}
```

### Best Practices

1. **Track PIDs:** Always store process IDs for launched scripts
2. **Check if running:** Verify script isn't already running before launching
3. **Proper cleanup:** Close launched scripts when GUI exits
4. **Error handling:** Use try/catch for file operations
5. **User feedback:** Provide clear status messages
6. **Consistent styling:** Follow existing GUI design patterns

### Testing

**Test checklist:**
- [ ] All buttons launch correct scripts
- [ ] Scripts don't launch multiple times
- [ ] Close buttons properly terminate scripts
- [ ] GUI closes cleanly (no orphaned processes)
- [ ] Error messages are clear and helpful
- [ ] GUI appearance is consistent
- [ ] Works with and without admin privileges

## Troubleshooting

### Issue: Script won't launch from GUI

**Possible causes:**
1. Incorrect script path
2. Script doesn't exist
3. Missing AutoHotkey installation
4. Insufficient permissions

**Solutions:**
```autohotkey
; Debug script path
MsgBox("Script path: " scriptPath)
MsgBox("File exists: " FileExist(scriptPath))

; Use absolute paths
scriptPath := A_ScriptDir "\..\MyScript.ahk"

; Check for errors
try {
  Run(scriptPath, , , &scriptPID)
} catch as e {
  MsgBox("Error: " e.Message "`nFile: " e.File "`nLine: " e.Line)
}
```

### Issue: Multiple instances launching

**Problem:** Script launches multiple times when button clicked repeatedly

**Solution:**
```autohotkey
; Check if already running
if WinExist("ahk_pid " scriptPID) {
  MsgBox("Already running!")
  return
}

; Alternative: Disable button while launching
myButton.Enabled := false
Run(scriptPath, , , &scriptPID)
Sleep(500)
myButton.Enabled := true
```

### Issue: GUI doesn't close scripts

**Problem:** Scripts keep running after GUI closes

**Solution:**
```autohotkey
; Add cleanup in OnEvent("Close")
GuiClose(*) {
  ; Close all tracked processes
  if WinExist("ahk_pid " script1PID)
    WinClose("ahk_pid " script1PID)
  if WinExist("ahk_pid " script2PID)
    WinClose("ahk_pid " script2PID)
  
  ExitApp
}
```

## Examples

### Example 1: Simple Script Launcher

```autohotkey
#Requires AutoHotkey v2.0
#SingleInstance Force

global pid := 0

myGui := Gui(, "Simple Launcher")
myGui.Add("Button", "w200", "Start Script").OnEvent("Click", (*) => Run("script.ahk", , , &pid))
myGui.Add("Button", "w200", "Stop Script").OnEvent("Click", (*) => WinClose("ahk_pid " pid))
myGui.Show()
```

### Example 2: Status Display

```autohotkey
#Requires AutoHotkey v2.0
#SingleInstance Force

global pid := 0
global statusText := ""

myGui := Gui(, "Status Launcher")
statusText := myGui.Add("Text", "w200", "Status: Not running")
myGui.Add("Button", "w200", "Launch").OnEvent("Click", Launch)

; Update status periodically
SetTimer(UpdateStatus, 1000)

Launch(*) {
  global pid
  Run("script.ahk", , , &pid)
}

UpdateStatus() {
  global statusText, pid
  if WinExist("ahk_pid " pid)
    statusText.Value := "Status: Running (PID: " pid ")"
  else
    statusText.Value := "Status: Not running"
}

myGui.Show()
```

## Resources

- [AutoHotkey v2 GUI Documentation](https://www.autohotkey.com/docs/v2/lib/Gui.htm)
- [AHK_v2/README.md](../README.md) - Parent directory documentation
- [CLAUDE.md](../../CLAUDE.md) - Developer guide

## Contributing

When adding new GUI scripts:

1. Follow the established design patterns
2. Use consistent button sizes and spacing
3. Include proper error handling
4. Test all button functions
5. Document hotkeys and features
6. Update this README

See [CONTRIBUTING.md](../../CONTRIBUTING.md) for detailed guidelines.

---

**Last Updated:** 2025-12-26
