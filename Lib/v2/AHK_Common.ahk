#Requires AutoHotkey v2.0
#SingleInstance Force

; AHK_Common – shared init utilities

InitUIA() {
    ; UIA is built-in in v2 (no-op, kept for compatibility)
}

RequireAdmin(mockIsAdmin := "", mockRun := "", mockMsgBox := "", mockExitApp := "") {
    isAdmin := mockIsAdmin !== "" ? mockIsAdmin : A_IsAdmin
    if isAdmin
        return
    try {
        if mockRun !== ""
            mockRun('*RunAs "' . A_ScriptFullPath . '"')
        else
            Run('*RunAs "' . A_ScriptFullPath . '"')
        if mockExitApp !== ""
            mockExitApp()
        else
            ExitApp()
    } catch Error as err {
        if mockMsgBox !== ""
            mockMsgBox("Failed to elevate: " . err.Message)
        else
            MsgBox("Failed to elevate: " . err.Message)
        if mockExitApp !== ""
            mockExitApp()
        else
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
    SetWorkingDir(A_ScriptDir)
    SetTitleMatchMode(2)
    SetTitleMatchMode("Fast")
    DetectHiddenText(false)
    DetectHiddenWindows(false)

    if requireUIA
        InitUIA()
    if requireAdmin
        RequireAdmin()
    if optimize
        SetOptimalPerformance()
}

FindExe(name, fallbacks := []) {
    if FileExist(name)
        return name
    Loop Parse, EnvGet("PATH"), ";"
    {
        p := Trim(A_LoopField)
        if !p
            continue
        cand := p . "\" . name
        if FileExist(cand)
            return cand
    }
    for _, fb in fallbacks
        if FileExist(fb)
            return fb
    return ""
}

MustGetExe(name, fallbacks := []) {
    exe := FindExe(name, fallbacks)
    if exe = ""
    {
        MsgBox("Required executable not found: " . name . "`nChecked PATH and fallbacks.")
        ExitApp(1)
    }
    return exe
}
