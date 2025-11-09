#Include %A_ScriptDir%\..\Lib\AHK_Common.ahk
#Include %A_ScriptDir%\..\Lib\AutoStartHelper.ahk

InitScript()

#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
DetectHiddenText, Off
DetectHiddenWindows, Off
SetTitleMatchMode, 3
SetTitleMatchMode, Fast

; Bluestacks with fullscreen and rotation
AutoStartFullscreen("HD-Player.exe", "F11", true, 6500, true)

; Click rotation button
CoordMode, mouse, Relative
WinGetActiveStats, Title, Width, Height, X, Y
x := Width - 15
y := 380
Click %x%, %y%
return
