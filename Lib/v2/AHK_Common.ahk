#Requires AutoHotkey v2.0

; ============================================================================
; AHK_Common.ahk - Common utility functions for AutoHotkey scripts
; Version: 2.0.0 (Migrated to AHK v2)
; ============================================================================

; ============================================================================
; InitUIA() - No longer needed in AHK v2
; UIA (UI Automation) support is built-in to AutoHotkey v2
; This function is kept for compatibility but does nothing
; ============================================================================
InitUIA() {
    ; UIA is built-in to AHK v2 - no action needed
    return
}

; ============================================================================
; RequireAdmin() - Ensures script runs with administrator privileges
; Relaunches script with admin rights if not already running as admin
; ============================================================================
RequireAdmin() {
    if (!A_IsAdmin) {
        try {
            Run('*RunAs "' . A_ScriptFullPath . '"')
            ExitApp()
        } catch Error as err {
            MsgBox("Failed to elevate to admin: " . err.Message)
            ExitApp()
        }
    }
}

; ============================================================================
; SetOptimalPerformance() - Applies performance optimization settings
; Disables delays for maximum script execution speed
; Note: Some v1 directives are deprecated/removed in v2
; ============================================================================
SetOptimalPerformance() {
    ; Note: #KeyHistory and ListLines are deprecated in v2
    ; These are now controlled by script directives only
    SetKeyDelay(-1, -1)
    SetMouseDelay(-1)
    SetDefaultMouseSpeed(0)
    SetWinDelay(-1)
    SetControlDelay(-1)
    SendMode("Input")
}

; ============================================================================
; InitScript(requireUIA := true, requireAdmin := false, optimize := true)
; Convenience function to initialize script with common settings
;
; Parameters:
;   requireUIA    - Run with UIA support (default: true) - No-op in v2
;   requireAdmin  - Run with admin privileges (default: false)
;   optimize      - Apply performance optimizations (default: true)
; ============================================================================
InitScript(requireUIA := true, requireAdmin := false, optimize := true) {
    ; UIA is built-in to v2, so InitUIA() does nothing
    if (requireUIA)
        InitUIA()

    if (requireAdmin)
        RequireAdmin()

    if (optimize)
        SetOptimalPerformance()
}
