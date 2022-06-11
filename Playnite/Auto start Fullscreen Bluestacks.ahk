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
SetTitleMatchMode, 2
SetTitleMatchMode, Fast

WinWait, BlueStacks ahk_exe HD-Player.exe
Sleep, 1000
Send {F11}
return