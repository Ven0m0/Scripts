; ============================================================================
; CitraConfigBase.ahk - Shared initialization for Citra config scripts (v2)
; Version: 2.0.0
; Migrated from v1: 2025-12-26
; Changes: Eliminated tf.ahk dependency, modernized v2 syntax
; ============================================================================

#Requires AutoHotkey v2.0
#SingleInstance Force

; Performance optimizations
#KeyHistory 0
ListLines False
SetKeyDelay -1, -1
SetMouseDelay -1
SetDefaultMouseSpeed 0
SetWinDelay -1
SetControlDelay -1
SendMode "Input"
SetTitleMatchMode 3
SetWorkingDir A_ScriptDir

; Include v2 helper functions
#Include CitraConfigHelpers.ahk

; Global config file path
OneDriveDir := EnvGet("OneDrive")
if (OneDriveDir = "") {
    MsgBox("OneDrive environment variable not set!`n`nPlease ensure OneDrive is installed and configured.", "Config Error", 16)
    ExitApp 1
}

global CitraConfigFile := OneDriveDir . "\Backup\Game\Emul\Citra\nightly-mingw\user\config\qt-config.ini"

; Verify config file exists
if !FileExist(CitraConfigFile) {
    MsgBox("Citra config file not found:`n" CitraConfigFile "`n`nPlease verify your Citra installation.", "Config Error", 16)
    ExitApp 1
}
