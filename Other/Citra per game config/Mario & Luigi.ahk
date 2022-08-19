#SingleInstance Force
; #Warn  ; Enable warnings to assist with detecting common errors. Warn needs to be off for tf library.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#KeyHistory 0
#include %A_ScriptDir%\tf.ahk
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
DetectHiddenText, Off
DetectHiddenWindows, Off
ListLines Off ; ListLines and #KeyHistory are functions used to "log your keys". Disable them as they're only useful for debugging purposes.
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0 ; Even though SendInput ignores SetKeyDelay, SetMouseDelay and SetDefaultMouseSpeed, having these delays at -1 improves SendEvent's speed just in case SendInput is not available and falls back to SendEvent.
SetWinDelay, -1
SetControlDelay, -1 ; SetWinDelay and SetControlDelay may affect performance depending on the script.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetTitleMatchMode, 3 ; Use SetTitleMatchMode 2 when you want to use wintitle that contains text anywhere in the title

; Layout to Default
TF_Replace("!C:\Users\janni\OneDrive\Backup\Game\Emul\Citra\nightly-mingw\user\config\qt-config.ini","layout_option=2","layout_option=0")