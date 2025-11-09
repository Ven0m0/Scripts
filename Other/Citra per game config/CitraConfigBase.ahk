; ============================================================================
; CitraConfigBase.ahk - Shared initialization for Citra config scripts
; Version: 1.0.0
; ============================================================================

#SingleInstance Force
; #Warn  ; Enable warnings to assist with detecting common errors. Warn needs to be off for tf library.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#KeyHistory 0
#include %A_ScriptDir%\tf.ahk
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
DetectHiddenText, Off
DetectHiddenWindows, Off
ListLines Off
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1
SetControlDelay, -1
SendMode Input
SetTitleMatchMode, 3

; Global config file path
global CitraConfigFile := "!C:\Users\janni\OneDrive\Backup\Game\Emul\Citra\nightly-mingw\user\config\qt-config.ini"
