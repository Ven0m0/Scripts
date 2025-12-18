#Requires AutoHotkey v2.0
#SingleInstance Force

target := A_ScriptDir "\..\..\AHK_v2\GUI\WM.ahk"

if !FileExist(target) {
  MsgBox("Unable to find v2 window manager: " target, "Missing File", "Iconx")
  ExitApp()
}

Run('"' target '"')
ExitApp()
