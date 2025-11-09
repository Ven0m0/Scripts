#Include %A_ScriptDir%\..\Lib\AHK_Common.ahk
#Include %A_ScriptDir%\..\Lib\AutoStartHelper.ahk

InitScript()

#SingleInstance Force
#NoEnv
DetectHiddenText, Off
DetectHiddenWindows, Off
SetTitleMatchMode, 2
SetTitleMatchMode, Fast

; MelonDS requires special F11 handling (down/up)
WinWait, ahk_exe melonDS.exe
Sleep, 1000
WinActivate, ahk_exe melonDS.exe
WinMaximize, ahk_exe melonDS.exe
SendInput, {F11 down}
Sleep, 100
Send, {F11 up}
return