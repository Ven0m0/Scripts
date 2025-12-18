#Requires AutoHotkey v2.0
#SingleInstance Force

g_registerDefaultHotkeys := false
g_autostartMode := ""
#Include %A_ScriptDir%\..\..\AHK_v2\Black_ops_6\bo6-afk.ahk

F6::StartMode("bank_loot")
F7:: {
  StopAll()
  ExitApp()
}
