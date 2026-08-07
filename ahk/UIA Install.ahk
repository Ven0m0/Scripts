#Requires AutoHotkey v2.0
; ============================================================================
; UIA Install.ahk - Install AutoHotkey with UI Automation support
; ============================================================================
; NOTE: This script installs AutoHotkey v1 with UIA support for legacy scripts.
; AutoHotkey v2 has UIA built-in and doesn't require special installation.
; ============================================================================
if (!A_IsAdmin) {
    try {
        Run("*RunAs " . A_ScriptFullPath)
    }
    ExitApp()
}
Download("https://www.autohotkey.com/download/ahk-install.exe", A_Temp . "\ahk-install.exe")
cmd := "ahk-install.exe /S /uiAccess=1 & del ahk-install.exe"
Run(A_ComSpec . ' /C "' . cmd . '"', A_Temp, "Hide")
ExitApp()
