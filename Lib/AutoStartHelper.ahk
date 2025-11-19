; ============================================================================
; AutoStartHelper.ahk - Helper functions for auto-start fullscreen scripts
; Version: 1.0.0
; ============================================================================

; ============================================================================
; AutoStartFullscreen(exeName, fullscreenKey := "F11", maximize := true, delay := 0, activate := false)
; Waits for a process to start and makes it fullscreen
;
; Parameters:
;   exeName         - Executable name (e.g., "citra-qt.exe")
;   fullscreenKey   - Key to send for fullscreen (default: "F11")
;   maximize        - Whether to maximize window first (default: true)
;   delay           - Delay in milliseconds before sending fullscreen key (default: 0)
;   activate        - Whether to activate window before maximizing (default: false)
; ============================================================================
AutoStartFullscreen(exeName, fullscreenKey := "F11", maximize := true, delay := 0, activate := false) {
    ; Wait for the window to appear
    WinWait, ahk_exe %exeName%

    ; Apply initial delay if specified
    if (delay > 0)
        Sleep, %delay%

    ; Activate window if requested
    if (activate)
        WinActivate, ahk_exe %exeName%

    ; Maximize if requested
    if (maximize)
        WinMaximize, ahk_exe %exeName%

    ; Send fullscreen key
    if (fullscreenKey != "")
        ControlSend, , {%fullscreenKey%}, ahk_exe %exeName%

    return
}

; ============================================================================
; AutoStartFullscreenWithTitle(winTitle, fullscreenKey := "F11", maximize := true, delay := 0)
; Waits for a window with specific title and makes it fullscreen
;
; Parameters:
;   winTitle        - Window title to wait for
;   fullscreenKey   - Key to send for fullscreen (default: "F11")
;   maximize        - Whether to maximize window first (default: true)
;   delay           - Delay in milliseconds before sending fullscreen key (default: 0)
; ============================================================================
AutoStartFullscreenWithTitle(winTitle, fullscreenKey := "F11", maximize := true, delay := 0) {
    ; Wait for the window to appear
    WinWait, %winTitle%

    ; Maximize if requested
    if (maximize)
        WinMaximize, %winTitle%

    ; Apply delay if specified
    if (delay > 0)
        Sleep, %delay%

    ; Send fullscreen key
    if (fullscreenKey != "")
        ControlSend, , {%fullscreenKey%}, %winTitle%

    return
}
