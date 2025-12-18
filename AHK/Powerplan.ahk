#Requires AutoHotkey v2.0
#SingleInstance Force

target := A_ScriptDir "\..\AHK_v2\Powerplan.ahk"

if !FileExist(target) {
  MsgBox("Unable to find v2 script: " target, "Missing File", "Iconx")
  ExitApp()
}

Run('"' target '"')
ExitApp()
