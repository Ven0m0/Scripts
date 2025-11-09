#Include %A_ScriptDir%\..\Lib\AHK_Common.ahk
#Include %A_ScriptDir%\..\Lib\AutoStartHelper.ahk

InitScript()

#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
DetectHiddenText, Off
DetectHiddenWindows, Off
SetTitleMatchMode, 2
SetTitleMatchMode, Fast

AutoStartFullscreen("citra-qt.exe", "F11", true, 0)
return