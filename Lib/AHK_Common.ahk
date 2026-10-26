#Requires AutoHotkey v2.0
#SingleInstance Force

; AHK_Common – shared init utilities

; Relaunches the script elevated and exits; on failure reports the error and exits anyway
RequireAdmin(host := "") {
    if !host
        host := SystemHost()

    if host.IsAdmin()
        return
    try {
        host.Run('*RunAs "' . A_ScriptFullPath . '"')
    } catch Error as err {
        host.MsgBox("Failed to elevate: " . err.Message)
    }
    host.ExitApp()
}

SetOptimalPerformance() {
    SetKeyDelay(-1, -1)
    SetMouseDelay(-1)
    SetDefaultMouseSpeed(0)
    SetWinDelay(-1)
    SetControlDelay(-1)
    SendMode("Input")
}

InitScript(requireAdmin := false, optimize := true) {
    SetWorkingDir(A_ScriptDir)
    SetTitleMatchMode(2)
    SetTitleMatchMode("Fast")
    DetectHiddenText(false)
    DetectHiddenWindows(false)

    if requireAdmin
        RequireAdmin()
    if optimize
        SetOptimalPerformance()
}

class SystemHost {
    IsAdmin() => A_IsAdmin
    Run(target) => Run(target)
    MsgBox(text) => MsgBox(text)
    ExitApp(code := 0) => ExitApp(code)
}
