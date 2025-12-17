#Include %A_ScriptDir%\..\Lib\v1\AHK_Common.ahk
#Include %A_ScriptDir%\..\Lib\v1\WindowManager.ahk

InitScript()

#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
DetectHiddenText, Off
DetectHiddenWindows, Off
SetTitleMatchMode, 2
SetTitleMatchMode, Fast

; fpPS4 emulator with multi-monitor support
WinWait, ahk_exe fpPS4.exe
Sleep, 1000
DllCall("SetCursorPos", "int", 0, "int", 1080)
WinActivate, ahk_exe fpPS4.exe
WinMaximize, ahk_exe fpPS4.exe
ToggleFakeFullscreenMultiMonitor("ahk_exe fpPS4.exe")