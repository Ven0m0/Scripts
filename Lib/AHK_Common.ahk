; ============================================================================
; AHK_Common.ahk - Common utility functions for AutoHotkey scripts
; Version: 1.0.0
; ============================================================================

; ============================================================================
; InitUIA() - Ensures script runs with UIA (UI Automation) support
; This is necessary for modern UI interactions and accessibility features
; ============================================================================
InitUIA() {
    if (!InStr(A_AhkPath, "_UIA.exe")) {
        newPath := RegExReplace(A_AhkPath, "\.exe", "U" (32 << A_Is64bitOS) "_UIA.exe")
        Run % StrReplace(DllCall("Kernel32\GetCommandLine", "Str"), A_AhkPath, newPath)
        ExitApp
    }
}

; ============================================================================
; RequireAdmin() - Ensures script runs with administrator privileges
; Relaunches script with admin rights if not already running as admin
; ============================================================================
RequireAdmin() {
    if not A_IsAdmin {
        Run *RunAs "%A_ScriptFullPath%"
        ExitApp
    }
}

; ============================================================================
; SetOptimalPerformance() - Applies performance optimization settings
; Disables delays and history for maximum script execution speed
; ============================================================================
SetOptimalPerformance() {
    #KeyHistory 0
    ListLines Off
    SetKeyDelay, -1, -1
    SetMouseDelay, -1
    SetDefaultMouseSpeed, 0
    SetWinDelay, -1
    SetControlDelay, -1
    SendMode Input
}

; ============================================================================
; InitScript(requireUIA := true, requireAdmin := false, optimize := true)
; Convenience function to initialize script with common settings
;
; Parameters:
;   requireUIA    - Run with UIA support (default: true)
;   requireAdmin  - Run with admin privileges (default: false)
;   optimize      - Apply performance optimizations (default: true)
; ============================================================================
InitScript(requireUIA := true, requireAdmin := false, optimize := true) {
    if (requireUIA)
        InitUIA()
    if (requireAdmin)
        RequireAdmin()
    if (optimize)
        SetOptimalPerformance()
}
