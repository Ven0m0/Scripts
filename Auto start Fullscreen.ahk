; Admin check
 if not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"
   ExitApp
}

#SingleInstance Force
#Warn  ; Enable warnings to assist with detecting common errors.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
DetectHiddenWindows, On

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetTitleMatchMode, 3
SetTitleMatchMode, Fast

sleep, 5000
WinWait BlueStacks
WinGetTitle, currentWindow, A
IfWinExist %currentWindow%
{
    WinSet, Style, -0xC00000, A ; hide title bar
	WinSet, Style, -0x800000, A ; hide thin-line border
	WinSet, Style, -0x400000, A ; hide dialog frame
	WinSet, Style, -0x40000, A ; hide thickframe/sizebox
    WinMove, A, , 0, 0, A_ScreenWidth, A_ScreenHeight
}
return