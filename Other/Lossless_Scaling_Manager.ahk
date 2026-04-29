#Requires AutoHotkey v2.0
#SingleInstance Force

; ---------- Config ----------
LSPath := "C:\Program Files\Lossless Scaling\LosslessScaling.exe"  ; update if different
MinDelayMs := 800

; ---------- Helpers ----------
IsAdmin() => DllCall("shell32\IsUserAnAdmin", "Int")
EnsureAdmin() {
  if IsAdmin()
    return
  try Run('*RunAs "' A_AhkPath '" "' A_ScriptFullPath '" ' A_Args.Join(" "))
  ExitApp
}
if (A_LineFile == A_ScriptFullPath) {
  EnsureAdmin()
}

MinimizeLS() {
  try {
    WinWait("ahk_exe LosslessScaling.exe",, 2)
    WinMinimize("ahk_exe LosslessScaling.exe")
  }
}

StartLS() {
  global LSPath, MinDelayMs
  if !FileExist(LSPath)
    throw Error("LSPath not found: " LSPath)
  Run(LSPath,, "UseErrorLevel")
  Sleep(MinDelayMs)
  MinimizeLS()
}

StopLS() {
  try ProcessClose("LosslessScaling.exe")
}

ToggleLS(mockProcessExist := "", mockStopLS := "", mockStartLS := "") {
  fnProcessExist := (mockProcessExist != "") ? mockProcessExist : ProcessExist
  fnStopLS := (mockStopLS != "") ? mockStopLS : StopLS
  fnStartLS := (mockStartLS != "") ? mockStartLS : StartLS

  if fnProcessExist("LosslessScaling.exe")
    fnStopLS()
  else
    fnStartLS()
}

; ---------- Dispatch ----------
if (A_LineFile == A_ScriptFullPath) {
  cmd := (A_Args.Length ? StrLower(A_Args[1]) : "toggle")
  try {
    switch cmd {
      case "start":  StartLS()
      case "stop", "close": StopLS()
      case "toggle": ToggleLS()
      default:
        MsgBox("Usage: " A_ScriptName " [start|stop|toggle]")
    }
  } catch Error as err {
    MsgBox("Error: " err.Message)
  }
}
