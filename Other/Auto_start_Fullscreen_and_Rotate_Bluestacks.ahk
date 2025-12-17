#Requires AutoHotkey v2.0

; ============================================================================
; Auto_start_Fullscreen_and_Rotate_Bluestacks.ahk
; Bluestacks auto-fullscreen with screen rotation
; ============================================================================

#Include %A_ScriptDir%\..\Lib\v2\AHK_Common.ahk
#Include %A_ScriptDir%\..\Lib\v2\AutoStartHelper.ahk
#SingleInstance Force

InitScript(false, false, true)

SetWorkingDir(A_ScriptDir)
DetectHiddenText(false)
DetectHiddenWindows(false)
SetTitleMatchMode(3)
SetTitleMatchMode("Fast")

; Bluestacks with fullscreen and rotation
AutoStartFullscreen("HD-Player.exe", "F11", true, 6500, true)

; Click rotation button
CoordMode("Mouse", "Relative")
WinGetPos(&X, &Y, &Width, &Height, "A")
x := Width - 15
y := 380
Click(x, y)
ExitApp()
