#Requires AutoHotkey v2.0

; ============================================================================
; Ryujinx_LDN.ahk - Launch Ryujinx LDN and hide console window
; ============================================================================

#Include %A_ScriptDir%\..\Lib\v2\AHK_Common.ahk
#SingleInstance Force

InitScript(false, false, true)

SetWorkingDir(A_ScriptDir)
SetTitleMatchMode(2)
SetTitleMatchMode("Fast")

; Construct path using OneDrive environment variable
; NOTE: Update this path if your Ryujinx LDN installation is in a different location
oneDrivePath := EnvGet("OneDrive")
ryujinxPath := oneDrivePath . "\Backup\Game\Emul\Yuzu\Ryujinx LDN\Ryujinx.exe"

; Fallback to hardcoded path if OneDrive env var not found
if (oneDrivePath = "") {
    ryujinxPath := "C:\Users\" . A_UserName . "\OneDrive\Backup\Game\Emul\Yuzu\Ryujinx LDN\Ryujinx.exe"
}

Run(ryujinxPath)
DllCall("kernel32.dll\Sleep", "UInt", 250)
WinHide("Ryujinx Console 1.0.0-ldn2.4")
ExitApp()