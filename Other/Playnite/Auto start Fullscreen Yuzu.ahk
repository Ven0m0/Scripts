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
#KeyHistory 0 
ListLines Off ; ListLines and #KeyHistory are functions used to "log your keys". Disable them as they're only useful for debugging purposes.
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0 ; Even though SendInput ignores SetKeyDelay, SetMouseDelay and SetDefaultMouseSpeed, having these delays at -1 improves SendEvent's speed just in case SendInput is not available and falls back to SendEvent.
SetWinDelay, -1
SetControlDelay, -1 ; SetWinDelay and SetControlDelay may affect performance depending on the script.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetTitleMatchMode, 2
SetTitleMatchMode, Fast

WinWait, | ahk_exe yuzu.exe
Send {F11}
return