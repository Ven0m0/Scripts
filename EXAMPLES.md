# Examples & Common Usage Patterns

Practical examples for the `Lib/` helpers and scripts actually in this repository.

## Table of Contents

- [Window Management](#window-management)
- [Init & Elevation](#init--elevation)
- [AFK Macros](#afk-macros)
- [Error Handling Pattern](#error-handling-pattern)

---

## Window Management

### Fake Fullscreen, Snap, Restore (multi-monitor)

```autohotkey
#Include A_ScriptDir "\..\Lib\WindowManager.ahk"

End::ToggleFakeFullscreen()
#Left::SnapWindow("left")
#Right::SnapWindow("right")
#Down::RestoreWindow()
```

Each acts on the window's own monitor. Press `End` again to restore; `RestoreWindow()` returns
the window to where it was before its first snap or fullscreen.

### Wait for a Window or Process

```autohotkey
#Include A_ScriptDir "\..\Lib\WindowManager.ahk"

if !WaitForWindow("ahk_exe game.exe", 10) {
    MsgBox("Game window not found!")
    ExitApp
}

if !WaitForProcess("game.exe", 10) {
    MsgBox("Game process not found!")
    ExitApp
}
```

### Always On Top Toggle

```autohotkey
^Space::WinSetAlwaysOnTop(-1, "A")  ; Ctrl+Space, -1 = toggle
```

---

## Init & Elevation

`Lib/AHK_Common.ahk` provides one-call setup for entry scripts:

```autohotkey
#Requires AutoHotkey v2.0
#SingleInstance Force
SendMode "Input"
SetWorkingDir A_ScriptDir

#Include A_ScriptDir "\..\Lib\AHK_Common.ahk"

InitScript(true, true)  ; requireAdmin=true, optimize=true
```

`InitScript(requireAdmin := false, optimize := true)` sets title-match mode, requests
elevation via `RequireAdmin()` when `requireAdmin` is true, and applies zero-delay
key/mouse/window settings when `optimize` is true.

---

## AFK Macros

### Minecraft AFK Fishing (`ahk/Minecraft/MC_AFK.ahk`)

```autohotkey
F7:: {  ; Toggle fishing loop
  if fishingOn
    StopFishing()
  else
    FishLoop()
}
F8::Pause(-1)  ; Pause
F9::ExitApp()  ; Stop
```

### Black Ops 6 (`ahk/Black_ops_6/bo6-afk.ahk`)

Modes are registered in a `Map` and dispatched by hotkey; reuse the loop instead of writing
a new one:

```autohotkey
ModeHandlers := Map(
    "balcony", BalconyLoop,
    "hold_click", HoldClickLoop
)
Hotkey("F1", (*) => StartMode("balcony"))
Hotkey("F7", (*) => StopAll())
```

To reuse `bo6-afk.ahk` from a wrapper without its default hotkeys:

```autohotkey
g_registerDefaultHotkeys := false
g_autostartMode := "balcony"
#Include bo6-afk.ahk
```

---

## Error Handling Pattern

```autohotkey
#Requires AutoHotkey v2.0

try {
    if !FileExist("emulator.exe")
        throw Error("Emulator not found!")

    Run("emulator.exe", , , &pid)

    if !WinWait("ahk_pid " . pid, , 10)
        throw Error("Window did not appear!")
} catch as e {
    MsgBox("Error: " . e.Message, "Error", "Icon!")
    ExitApp(1)
}
```

---

## Resources

- [README.md](README.md) - Main documentation
- [AGENTS.md](AGENTS.md) - Developer guide
- [AutoHotkey v2 Documentation](https://www.autohotkey.com/docs/v2/)
