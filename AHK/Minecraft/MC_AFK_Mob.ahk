#Include %A_ScriptDir%\..\..\Lib\AHK_Common.ahk
InitScript()

$*F7::
Send, 1 ; switch to slot 1
SetTimer, eatFood, 60000
Return

eatFood:
Sleep 150 ; wait for sword swing finish if in progress
Send, 6 ; switch to slot 2
Sleep 200 ; all Sleep 200 are here "just in case". fe Wait for switch animation to finish. May not be needed
Click, down, right
Sleep 3500 ;wait until food eaten
Click, up, right
Sleep 200
Send, 1 ; switch to slot 1
Sleep 200
Return

$*F8::
Pause
Return

$*F9::
ExitApp
Return
