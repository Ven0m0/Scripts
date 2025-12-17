#Requires AutoHotkey v2.0

; ============================================================================
; Kill_Bluestacks.ahk - Terminate all Bluestacks processes
; Version: 2.0.0 (Migrated to AHK v2)
;
; Functionality:
;   Closes all Bluestacks-related processes
; ============================================================================

#Include %A_ScriptDir%\..\Lib\v2\AHK_Common.ahk
InitScript(false, false, true)

#SingleInstance Force
DetectHiddenText(false)
DetectHiddenWindows(false)

; Get PIDs of Bluestacks processes
try HDPlayer := WinGetPID("ahk_exe HD-Player.exe")
try BstkSVC := WinGetPID("ahk_exe BstkSVC.exe")
try LogCollector := WinGetPID("ahk_exe HD-LogCollector.exe")

; Close processes
try ProcessClose(HDPlayer)
try ProcessClose(BstkSVC)
try ProcessClose(LogCollector)
