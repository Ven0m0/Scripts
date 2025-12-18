#Requires AutoHotkey v2.0
#SingleInstance Force

; AHK_Common – shared init utilities

InitUIA() {
    ; UIA is built-in in v2 (no-op, kept for compatibility)
}

RequireAdmin() {
    if A_IsAdmin
        return
    try {
        Run('*RunAs "' . A_ScriptFullPath . '"')
        ExitApp()
    } catch Error as err {
        MsgBox("Failed to elevate: " . err.Message)
        ExitApp()
    }
}

SetOptimalPerformance() {
    SetKeyDelay(-1, -1)
    SetMouseDelay(-1)
    SetDefaultMouseSpeed(0)
    SetWinDelay(-1)
    SetControlDelay(-1)
    SendMode("Input")
}

InitScript(requireUIA := true, requireAdmin := false, optimize := true) {
    if requireUIA
        InitUIA()
    if requireAdmin
        RequireAdmin()
    if optimize
        SetOptimalPerformance()
}
