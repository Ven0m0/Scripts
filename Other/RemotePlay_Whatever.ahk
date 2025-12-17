#Requires AutoHotkey v2.0

; ============================================================================
; RemotePlay_Whatever.ahk - Launch Steam and RemotePlayWhatever
; ============================================================================

#Include %A_ScriptDir%\..\Lib\v2\AHK_Common.ahk
#SingleInstance Force

InitScript(false, false, true)

SetWorkingDir(A_ScriptDir)
SetTitleMatchMode(2)
SetTitleMatchMode("Fast")

; Launch Steam (standard x86 installation path)
steamPath := "C:\Program Files (x86)\Steam\steam.exe"

; Try alternate 64-bit path if x86 doesn't exist
if (!FileExist(steamPath)) {
    steamPath := "C:\Program Files\Steam\steam.exe"
}

Run(steamPath)
DllCall("kernel32.dll\Sleep", "UInt", 2000)

; Retry if Steam window not found
if (!WinExist("ahk_exe steam.exe")) {
    Run(steamPath)
}

WinWait("ahk_exe steam.exe")

; Construct RemotePlayWhatever path using OneDrive environment variable
; NOTE: Update this path if your RemotePlayWhatever installation is in a different location
oneDrivePath := EnvGet("OneDrive")
remotePlayPath := oneDrivePath . "\Backup\Game\Other\Tools\Multiplayer\RemotePlayWhatever\RemotePlayWhatever.exe"

; Fallback to hardcoded path if OneDrive env var not found
if (oneDrivePath = "") {
    remotePlayPath := "C:\Users\" . A_UserName . "\OneDrive\Backup\Game\Other\Tools\Multiplayer\RemotePlayWhatever\RemotePlayWhatever.exe"
}

Run(remotePlayPath)
ExitApp()