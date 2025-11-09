#Include %A_ScriptDir%\..\Lib\AHK_Common.ahk

InitScript()

#NoEnv
SetWorkingDir %A_ScriptDir%
DetectHiddenText, Off
DetectHiddenWindows, Off
SetTitleMatchMode, 2
SetTitleMatchMode, Fast

; Spider-Man requires Enter key to dismiss splash screen
WinWait, ahk_exe Spider-Man.exe
Sleep, 500
ControlSend, , {Enter}, ahk_exe Spider-Man.exe
Sleep, 3500
WinActivate, ahk_exe Spider-Man.exe