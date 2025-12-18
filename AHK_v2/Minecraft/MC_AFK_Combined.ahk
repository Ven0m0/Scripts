#Requires AutoHotkey v2.0
#SingleInstance Force
ListLines False

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

F7:: {  ; Toggle fishing loop
  if fishingOn
    StopFishing()
  else
    FishLoop()
}

F6:: {  ; Toggle mob auto-eat every 60s
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

F8:: {
  Pause(-1)
}

F9:: {
  ExitApp()
}
