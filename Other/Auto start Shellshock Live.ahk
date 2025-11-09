#Include %A_ScriptDir%\..\Lib\AHK_Common.ahk

InitScript()

#NoEnv
SetWorkingDir %A_ScriptDir%
DetectHiddenText, Off
DetectHiddenWindows, Off
SetTitleMatchMode, 2
SetTitleMatchMode, Fast

; ShellShock Live requires Enter key to start
WinWait, ahk_exe ShellShockLive.exe
Sleep, 100
ControlSend, , {Enter}, ahk_exe ShellShockLive.exe
WinActivate, ahk_exe ShellShockLive.exe