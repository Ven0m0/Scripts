# Examples & Common Usage Patterns

This document provides practical examples and common usage patterns for the scripts in this repository.

## Table of Contents

- [Window Management](#window-management)
- [Emulator Automation](#emulator-automation)
- [AFK Macros](#afk-macros)
- [GUI Launchers](#gui-launchers)
- [Media Downloads](#media-downloads)
- [System Utilities](#system-utilities)

---

## Window Management

### Example 1: Toggle Borderless Fullscreen

**Use Case:** Make any game fullscreen without borders

```autohotkey
; AHK_v2/Fullscreen.ahk
#Requires AutoHotkey v2.0
#Include A_ScriptDir "\..\Lib\v2\WindowManager.ahk"

; Press End key to toggle borderless fullscreen on active window
End::ToggleFakeFullscreenMultiMonitor("A")
```

**Usage:**
1. Run `Fullscreen.ahk`
2. Focus on your game window
3. Press `End` key
4. Press `End` again to restore

---

### Example 2: Window Snapping

**Use Case:** Snap windows to screen edges like Windows 11

```autohotkey
; From Keys.ahk - Window snapping with Win+Arrow keys
#Left::  ; Win+Left - Snap to left half
    WinGetPos(&X, &Y, &Width, &Height, "A")
    WinMove(0, 0, A_ScreenWidth/2, A_ScreenHeight, "A")
Return

#Right::  ; Win+Right - Snap to right half
    WinGetPos(&X, &Y, &Width, &Height, "A")
    WinMove(A_ScreenWidth/2, 0, A_ScreenWidth/2, A_ScreenHeight, "A")
Return
```

---

### Example 3: Always On Top Toggle

**Use Case:** Keep a window on top of all others

```autohotkey
; Toggle always-on-top for active window
^Space::  ; Ctrl+Space
    WinSetAlwaysOnTop(-1, "A")  ; -1 = toggle
    MsgBox("Always on top toggled!")
Return
```

---

## Emulator Automation

### Example 4: Auto-Fullscreen for Citra

**Use Case:** Automatically launch Citra in fullscreen

**Method 1: Using AutoStartManager**

```bash
# Run with emulator name
Other/AutoStartManager.ahk Citra
```

**Method 2: Manual Script**

```autohotkey
#Requires AutoHotkey v2.0
#Include A_ScriptDir "\..\Lib\v2\AutoStartHelper.ahk"

; Wait for Citra, then press F11 for fullscreen
AutoStartFullscreen("citra-qt.exe", "{F11}", true, 0)
```

---

### Example 5: Per-Game Citra Configuration

**Use Case:** Apply HD textures for Zelda: Ocarina of Time

```autohotkey
#Include %A_ScriptDir%\tf.ahk

global CitraConfigFile := A_AppData . "\Citra\config\qt-config.ini"

; Enable HD Textures
tf_Replace(CitraConfigFile, "custom_textures\use_custom_textures=false", "custom_textures\use_custom_textures=true")

; Set 4x resolution
tf_Replace(CitraConfigFile, "resolution_factor\default=true", "resolution_factor\default=false")
tf_Replace(CitraConfigFile, "resolution_factor=1", "resolution_factor=4")

MsgBox("Configuration applied for Zelda OOT!")
ExitApp
```

---

### Example 6: Multi-Monitor Playnite Setup

**Use Case:** Auto-switch monitors when launching Playnite

```bash
# Run Playnite with multi-monitor automation
Other/Playnite_fullscreen_v2/Playnite_TV.ahk
```

This automatically:
- Disables secondary monitor
- Switches primary monitor
- Launches Playnite fullscreen
- Plays boot video
- Restores on exit

---

## AFK Macros

### Example 7: Minecraft AFK Fishing

**Use Case:** Auto-fish while AFK

```autohotkey
#Requires AutoHotkey v2.0

F7:: {  ; Start fishing macro
  Loop {
    Send("{Mouse2}")  ; Cast rod
    Sleep(RandomDelay(15000, 20000))  ; Wait for bite
    Send("{Mouse2}")  ; Reel in
    Sleep(RandomDelay(1000, 2000))  ; Delay before next cast
  }
}

F8::Pause  ; Pause/Resume
F9::ExitApp  ; Stop

RandomDelay(min, max) {
  return Random(min, max)
}
```

**Usage:**
1. Position yourself at fishing spot
2. Hold fishing rod
3. Run script and press F7
4. F8 to pause, F9 to stop

---

### Example 8: Black Ops 6 XP Farming

**Use Case:** AFK XP grinding in Zombies

```autohotkey
#Requires AutoHotkey v2.0

F7:: {  ; Start XP macro
  Loop {
    ; Move in circle to avoid AFK kick
    Send("{w down}")
    Sleep(500)
    Send("{w up}")
    Sleep(100)
    
    ; Shoot periodically
    Send("{Mouse1}")
    Sleep(RandomDelay(800, 1200))
    
    ; Anti-AFK movement every 30 seconds
    if (Mod(A_Index, 30) == 0) {
      Send("{Space}")  ; Jump
      Sleep(200)
    }
  }
}

F8::Pause
F9::ExitApp

RandomDelay(min, max) {
  return Random(min, max)
}
```

---

## GUI Launchers

### Example 9: Simple Script Launcher

**Use Case:** Launch multiple scripts from one GUI

```autohotkey
#Requires AutoHotkey v2.0

global script1PID := 0
global script2PID := 0

; Create GUI
myGui := Gui("+AlwaysOnTop", "Script Launcher")

; Add buttons
myGui.Add("Button", "w200", "Launch Fullscreen").OnEvent("Click", LaunchFullscreen)
myGui.Add("Button", "w200", "Launch Power Plan").OnEvent("Click", LaunchPowerPlan)
myGui.Add("Button", "w200", "Close All Scripts").OnEvent("Click", CloseAll)

myGui.Show()

; Button handlers
LaunchFullscreen(*) {
  global script1PID
  Run(A_ScriptDir "\Fullscreen.ahk", , , &script1PID)
}

LaunchPowerPlan(*) {
  global script2PID
  Run(A_ScriptDir "\Powerplan.ahk", , , &script2PID)
}

CloseAll(*) {
  if WinExist("ahk_pid " script1PID)
    WinClose("ahk_pid " script1PID)
  if WinExist("ahk_pid " script2PID)
    WinClose("ahk_pid " script2PID)
}
```

---

## Media Downloads

### Example 10: Download YouTube Playlist

**Use Case:** Download entire playlist as MP3s

```bash
# 1. Place yt-dlp.exe in Other/Downloader/
# 2. Run YT_Spotify_Downloader.ahk
# 3. Paste playlist URL
# 4. Select "Audio - MP3"
# 5. Click Download
```

**Manual command line:**

```bash
cd Other/Downloader
yt-dlp -f "ba" -x --audio-format mp3 "https://youtube.com/playlist?list=..."
```

---

### Example 11: Download Spotify Playlist

**Use Case:** Download Spotify playlist to local files

```bash
# 1. Place spotdl.exe in Other/Downloader/
# 2. Run YT_Spotify_Downloader.ahk
# 3. Paste Spotify playlist URL
# 4. Click Download
```

**Manual command line:**

```bash
cd Other/Downloader
spotdl "https://open.spotify.com/playlist/..."
```

---

## System Utilities

### Example 12: Auto Power Plan Switching

**Use Case:** Switch to High Performance when game launches

```autohotkey
#Requires AutoHotkey v2.0

; Monitor for specific game
processName := "FortniteClient-Win64-Shipping.exe"
highPerfGUID := "{8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c}"
balancedGUID := "{381b4222-f694-41f0-9685-ff5bb260df2e}"

SetTimer(CheckProcess, 5000)

CheckProcess() {
  if ProcessExist(processName) {
    ; Switch to High Performance
    Run("powercfg /setactive " highPerfGUID, , "Hide")
  } else {
    ; Switch to Balanced
    Run("powercfg /setactive " balancedGUID, , "Hide")
  }
}
```

---

### Example 13: Controller Quit

**Use Case:** Quit games with controller combo

```autohotkey
#Requires AutoHotkey v2.0

; Guide + Start + B to close active window
; (Implementation varies by controller library)

; Simple version using keyboard simulation
^!q::  ; Ctrl+Alt+Q as alternative
  if WinExist("A") {
    WinClose("A")
  }
Return
```

---

### Example 14: Bulk Image Copy with Robocopy

**Use Case:** Copy all images from vacation photos to backup

```cmd
@echo off
REM Copy_vacation_photos.cmd

set ext=*.jpg *.jpeg *.png *.heic *.raw
robocopy "D:\Vacation 2024" "E:\Backup\Vacation 2024" %ext% /s /MT:32 /v

echo.
echo Copy complete!
pause
```

---

### Example 15: 7z Game Compression

**Use Case:** Compress PS2 games to save space

```bash
# Compress with maximum compression
7z a -t7z -mx=9 "God of War.7z" "God of War\*"

# Then use with 7zEmuPrepper for on-the-fly extraction
```

---

## Advanced Patterns

### Example 16: Multi-Step Automation

**Use Case:** Complete emulator setup automation

```autohotkey
#Requires AutoHotkey v2.0
#Include A_ScriptDir "\..\Lib\v2\AHK_Common.ahk"
#Include A_ScriptDir "\..\Lib\v2\WindowManager.ahk"

InitScript(false, true)  ; Require admin

; 1. Apply per-game config
Run("Citra_per_game_config\Pokemon-X.ahk")
Sleep(2000)

; 2. Launch emulator
citraPath := "C:\Emulators\Citra\citra-qt.exe"
gamePath := "D:\Games\3DS\Pokemon X.3ds"
Run('"' citraPath '" "' gamePath '"', , , &citraPID)

; 3. Wait and apply fullscreen
if WaitForProcess("citra-qt.exe", 10) {
  Sleep(2000)
  Send("{F11}")  ; Fullscreen
}
```

---

### Example 17: Conditional Automation

**Use Case:** Different settings for different times of day

```autohotkey
#Requires AutoHotkey v2.0

currentHour := A_Hour

if (currentHour >= 22 or currentHour < 6) {
  ; Night mode - reduce volume
  SoundSetVolume(30)
  MsgBox("Night mode activated")
} else {
  ; Day mode - normal volume
  SoundSetVolume(70)
  MsgBox("Day mode activated")
}
```

---

### Example 18: Error Handling Pattern

**Use Case:** Robust script with error recovery

```autohotkey
#Requires AutoHotkey v2.0

try {
  ; Try to launch emulator
  if !FileExist("emulator.exe") {
    throw Error("Emulator not found!")
  }
  
  Run("emulator.exe", , , &pid)
  
  ; Wait for window
  if !WinWait("ahk_pid " pid, , 10) {
    throw Error("Window did not appear!")
  }
  
  ; Success
  MsgBox("Emulator launched successfully!")
  
} catch as e {
  ; Handle error
  MsgBox("Error: " e.Message, "Error", "Icon!")
  ExitApp(1)
}
```

---

## Tips & Tricks

### Tip 1: Testing Scripts Safely

Always test with `/L` flag for file operations:

```cmd
REM Preview robocopy without copying
robocopy source dest /s /MT:32 /L
```

### Tip 2: Debugging AutoHotkey

```autohotkey
; Add debug output
MsgBox("Debug: Variable = " myVariable)

; Or use ToolTip for non-blocking
ToolTip("Debug: Step 1 complete")
Sleep(2000)
ToolTip()  ; Clear
```

### Tip 3: Quick Reload

Add to scripts for easy reloading:

```autohotkey
^r::Reload  ; Ctrl+R to reload script
^e::Edit    ; Ctrl+E to edit script
```

---

## Resources

- [README.md](README.md) - Main documentation
- [CLAUDE.md](CLAUDE.md) - Developer guide with detailed patterns
- [CONTRIBUTING.md](CONTRIBUTING.md) - Contribution guidelines
- [AutoHotkey v2 Documentation](https://www.autohotkey.com/docs/v2/)

---

**Last Updated:** 2025-12-26