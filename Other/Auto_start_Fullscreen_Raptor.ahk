#Include %A_ScriptDir%\..\Lib\v1\AHK_Common.ahk
#Include %A_ScriptDir%\..\Lib\v1\AutoStartHelper.ahk

InitScript()

#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
DetectHiddenText, Off
DetectHiddenWindows, Off
SetTitleMatchMode, 2
SetTitleMatchMode, Fast

AutoStartFullscreen("RaptorCitrus.exe", "F11", true, 0)
return