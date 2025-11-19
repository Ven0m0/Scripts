#Include %A_ScriptDir%\..\..\Lib\AHK_Common.ahk
InitScript()

#SingleInstance, Force
#NoEnv
#Warn
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
SetBatchLines, -1
Process, Priority, , A

F6::
Send {LButton down}
return

F7::
Send {LButton up}
ExitApp