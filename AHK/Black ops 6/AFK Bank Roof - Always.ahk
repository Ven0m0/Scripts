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
SetTimer , AFK , 100
return

AFK:
Random, rand, 0, 20
DllCall("Sleep","UInt",rand)
Send {LButton}
Sleep 10
Send {g}
return

F7::ExitApp