#Requires AutoHotkey v2.0
#SingleInstance Force

#Include %A_ScriptDir%\..\..\Lib\AHK_Common.ahk
InitScript()
Persistent

global fishingOn := false
global eatTimerOn := false

eatFood() {
  Sleep(150)        ; let any swing finish
  Send("6")         ; food slot
  Sleep(200)
  Click("down", "right")
  Sleep(3500)       ; eat duration
  Click("up", "right")
  Sleep(200)
  Send("1")         ; back to sword
  Sleep(200)
}

FishLoop() {
  global fishingOn
  if (fishingOn)
    return  ; already running

  fishingOn := true
  try {
    while fishingOn {
      Click("down", "right")
      Sleep(100)
      Click("up", "right")
      Sleep(9500)
      Click("down", "right")
      Sleep(100)
      Click("up", "right")
      Sleep(500)
    }
  } finally {
    fishingOn := false
  }
}

StopFishing() {
  global fishingOn
  fishingOn := false
}

; Bindings come from hotkeys.ini next to this script ([MC_AFK]); these are the defaults.
keys := LoadHotkeys(A_ScriptDir . "\hotkeys.ini", "MC_AFK", Map(
    "fishing", "F7",
    "autoEat", "F6",
    "pause", "F8",
    "exit", "F9"))

ToggleFishing(*) {
    if fishingOn
        StopFishing()
    else
        FishLoop()
}

; Toggle mob auto-eat every 60s
ToggleAutoEat(*) {
    global eatTimerOn
    if eatTimerOn {
        SetTimer(eatFood, 0)
        eatTimerOn := false
    } else {
        Send("1")  ; ensure sword slot first
        SetTimer(eatFood, 60000)
        eatTimerOn := true
    }
}

Hotkey(keys["fishing"], ToggleFishing)
Hotkey(keys["autoEat"], ToggleAutoEat)
Hotkey(keys["pause"], (*) => Pause(-1))
Hotkey(keys["exit"], (*) => ExitApp())
