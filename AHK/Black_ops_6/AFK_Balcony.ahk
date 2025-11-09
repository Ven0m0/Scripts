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
SetTimer , AFK , 500
Return

AFK:
Random, rand, 250, 2001
Sleep %rand%
Send {p}
Sleep 1001
Send {2}
Sleep 1001
Send {RButton down}
Sleep 1001
Send {RButton up}
Sleep 3001
Send {c}
Sleep 1001
Send {p}
Sleep 75001
Return

$*F7::
SetTimer, AFK, Off
ExitApp