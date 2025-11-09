#Include %A_ScriptDir%\..\Lib\AHK_Common.ahk
#Include %A_ScriptDir%\..\Lib\WindowManager.ahk

InitScript(true, true)  ; UIA + Admin required

#NoEnv
SetBatchLines -1
SetControlDelay -1
#SingleInstance Force
#persistent
#Warn

; Ctrl+Alt+K for fullscreen
^!k::
{
    WinSet, AlwaysOnTop, On, A
    SetWindowBorderless("A")
    WinMove, A, , 0, 0, A_ScreenWidth, A_ScreenHeight
}
return

; Ctrl+Alt+L to restore window
^!l::
{
    WinSet, AlwaysOnTop, Off, A
    WinSet, Style, +0xC00000, A  ; show title bar
    WinSet, Style, +0x800000, A  ; show thin-line border
    WinSet, Style, +0x400000, A  ; show dialog frame
    WinSet, Style, +0x40000, A   ; show thickframe/sizebox
    WinMove, A, , 0, 0, 1280, 720
}
return
