#Requires AutoHotkey v2.0

; AutoStartHelper – wait, maximize, fullscreen helpers

WaitWin(target, timeout := 0) {
    try {
        WinWait(target, , timeout)
        return true
    } catch TimeoutError {
        return false
    }
}

MaybeActivateMaximize(target, maximize, activate) {
    if activate
        WinActivate(target)
    if maximize
        WinMaximize(target)
}

AutoStartFullscreen(exeName, fullscreenKey := "F11", maximize := true, delay := 0, activate := false) {
    target := "ahk_exe " . exeName
    if !WaitWin(target)
        return
    if (delay > 0)
        Sleep(delay)
    MaybeActivateMaximize(target, maximize, activate)
    if fullscreenKey != ""
        ControlSend("{" . fullscreenKey . "}", , target)
}

AutoStartFullscreenWithTitle(winTitle, fullscreenKey := "F11", maximize := true, delay := 0) {
    target := winTitle
    if !WaitWin(target)
        return
    MaybeActivateMaximize(target, maximize, false)
    if (delay > 0)
        Sleep(delay)
    if fullscreenKey != ""
        ControlSend("{" . fullscreenKey . "}", , target)
}
