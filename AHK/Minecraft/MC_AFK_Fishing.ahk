#Include %A_ScriptDir%\..\..\Lib\v1\AHK_Common.ahk
InitScript()

$*F7::
Loop{
Click, down, right
Sleep 100
Click, up, right
Sleep 9500
Click, down, right
Sleep 100
Click, up, right
}




$*F8::
Pause
Return

$*F9::
ExitApp
Return
