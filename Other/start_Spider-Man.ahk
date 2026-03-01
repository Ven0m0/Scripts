#Requires AutoHotkey v2.0

; ============================================================================
; Auto_start_Spider-Man.ahk - Auto-start Spider-Man with splash screen dismiss
; ============================================================================

#Include %A_ScriptDir%\..\Lib\v2\AHK_Common.ahk
#SingleInstance Force

InitScript(false, false, true)

SetWorkingDir(A_ScriptDir)
DetectHiddenText(false)
DetectHiddenWindows(false)
SetTitleMatchMode(2)
SetTitleMatchMode("Fast")

; Spider-Man requires Enter key to dismiss splash screen
WinWait("ahk_exe Spider-Man.exe")
WinWaitActive("ahk_exe Spider-Man.exe")
ControlSend("{Enter}", , "ahk_exe Spider-Man.exe")
WinActivate("ahk_exe Spider-Man.exe")
ExitApp()
