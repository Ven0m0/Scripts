#Requires AutoHotkey v2.0

; ============================================================================
; Close_Window.ahk - Safely close active window (v2)
; Version: 2.0.0 (Migrated to AHK v2)
;
; Functionality:
;   Closes the active window unless it's in the "Safe" list
;   Safe windows: Explorer, Desktop, Playnite, Edge
; ============================================================================

#Include %A_ScriptDir%\..\Lib\v2\AHK_Common.ahk
InitScript(false, false, true)

#SingleInstance Force
DetectHiddenText(false)
DetectHiddenWindows(false)
SetTitleMatchMode(2)

; Create group of safe windows that shouldn't be closed
GroupAdd("Safe", "ahk_exe Explorer.EXE")
GroupAdd("Safe", "ahk_class ExploreWClass")
GroupAdd("Safe", "ahk_class CabinetWClass")
GroupAdd("Safe", "ahk_class WorkerW")
GroupAdd("Safe", "ahk_exe Playnite.DesktopApp.exe")
GroupAdd("Safe", "ahk_exe Playnite.FullscreenApp.exe")
GroupAdd("Safe", "ahk_exe msedge.exe")

; Only close if not a safe window
if (!WinActive("ahk_group Safe")) {
    WinKill("A")
}
