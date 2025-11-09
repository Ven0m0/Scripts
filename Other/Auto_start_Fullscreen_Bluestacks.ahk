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

AutoStartFullscreen("HD-Player.exe", "F11", true, 6500, true)
return