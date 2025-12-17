#Requires AutoHotkey v2.0

; ============================================================================
; WindowManager.ahk - Window manipulation and fullscreen utilities
; Version: 2.0.0 (Migrated to AHK v2)
; ============================================================================

; ============================================================================
; ToggleFakeFullscreen(winTitle := "A") - Toggle borderless fullscreen
; Removes/restores window decorations and maximizes to simulate fullscreen
;
; Parameters:
;   winTitle - Window to affect (default: active window)
; ============================================================================
ToggleFakeFullscreen(winTitle := "A") {
    ; Check if window is currently in fake fullscreen by checking for titlebar
    currentStyle := WinGetStyle(winTitle)
    hasTitleBar := currentStyle & 0xC00000

    if (hasTitleBar) {
        ; Enter fake fullscreen - remove window decorations
        WinSetStyle(-0xC00000, winTitle)  ; hide title bar
        WinSetStyle(-0x800000, winTitle)  ; hide thin-line border
        WinSetStyle(-0x400000, winTitle)  ; hide dialog frame
        WinSetStyle(-0x40000, winTitle)   ; hide thickframe/sizebox

        ; Maximize the window
        WinMove(0, 0, A_ScreenWidth, A_ScreenHeight, winTitle)
    } else {
        ; Exit fake fullscreen - restore window decorations
        WinSetStyle(0xC00000, winTitle)  ; restore title bar
        WinSetStyle(0x800000, winTitle)  ; restore thin-line border
        WinSetStyle(0x400000, winTitle)  ; restore dialog frame
        WinSetStyle(0x40000, winTitle)   ; restore thickframe/sizebox

        ; Restore window to non-maximized state
        WinRestore(winTitle)
    }
}

; ============================================================================
; SetWindowBorderless(winTitle) - Remove window borders and decorations
; Parameters:
;   winTitle - Window to affect
; ============================================================================
SetWindowBorderless(winTitle) {
    WinSetStyle(-0xC00000, winTitle)  ; hide title bar
    WinSetStyle(-0x800000, winTitle)  ; hide thin-line border
    WinSetStyle(-0x400000, winTitle)  ; hide dialog frame
    WinSetStyle(-0x40000, winTitle)   ; hide thickframe/sizebox
}

; ============================================================================
; MaximizeWindow(winTitle) - Maximize window to full screen size
; Parameters:
;   winTitle - Window to affect
; ============================================================================
MaximizeWindow(winTitle) {
    WinMove(0, 0, A_ScreenWidth, A_ScreenHeight, winTitle)
}

; ============================================================================
; MakeFullscreen(winTitle) - Combine borderless + maximize
; Parameters:
;   winTitle - Window to affect
; ============================================================================
MakeFullscreen(winTitle) {
    SetWindowBorderless(winTitle)
    MaximizeWindow(winTitle)
}

; ============================================================================
; WaitForWindow(winTitle, timeout := 30) - Wait for window with timeout
; Returns: true if window found, false if timeout
;
; Parameters:
;   winTitle - Window to wait for
;   timeout  - Timeout in seconds (default: 30 seconds)
; ============================================================================
WaitForWindow(winTitle, timeout := 30) {
    try {
        WinWait(winTitle, , timeout)
        return true
    } catch TimeoutError {
        return false
    }
}

; ============================================================================
; WaitForProcess(processName, timeout := 30) - Wait for process with timeout
; Returns: true if process found, false if timeout
;
; Parameters:
;   processName - Process to wait for (e.g., "notepad.exe")
;   timeout     - Timeout in seconds (default: 30 seconds)
; ============================================================================
WaitForProcess(processName, timeout := 30) {
    startTime := A_TickCount
    timeoutMs := timeout * 1000

    while (!ProcessExist(processName)) {
        if (A_TickCount - startTime > timeoutMs)
            return false

        Sleep(100)
    }

    return true
}

; ============================================================================
; Multi-monitor aware fullscreen functions
; ============================================================================

GetMonitorAtPos(x, y) {
    ; Monitor number at position x,y or -1 if x,y outside monitors
    monitorCount := MonitorGetCount()

    Loop monitorCount {
        MonitorGet(A_Index, &areaLeft, &areaTop, &areaRight, &areaBottom)
        if (areaLeft <= x && x <= areaRight && areaTop <= y && y <= areaBottom)
            return A_Index
    }
    return -1
}

GetMonitorActiveWindow(winTitle := "A") {
    ; Get Monitor number at the center position of the specified window
    WinGetPos(&x, &y, &width, &height, winTitle)
    return GetMonitorAtPos(x + width/2, y + height/2)
}

ToggleFakeFullscreenMultiMonitor(winTitle := "A") {
    ; Toggle borderless fullscreen with multi-monitor support
    static WINDOW_STYLE_UNDECORATED := -0xC40000
    static savedInfo := Map()

    id := WinGetID(winTitle)

    if (savedInfo.Has(id)) {
        ; Restore saved window state
        inf := savedInfo[id]
        WinSetStyle(inf["style"], "ahk_id " . id)
        WinMove(inf["x"], inf["y"], inf["width"], inf["height"], "ahk_id " . id)
        savedInfo.Delete(id)
    } else {
        ; Save current state and make fullscreen
        inf := Map()
        inf["style"] := WinGetStyle(winTitle)
        WinGetPos(&ltmpX, &ltmpY, &ltmpWidth, &ltmpHeight, "ahk_id " . id)
        inf["x"] := ltmpX
        inf["y"] := ltmpY
        inf["width"] := ltmpWidth
        inf["height"] := ltmpHeight
        savedInfo[id] := inf

        WinSetStyle(WINDOW_STYLE_UNDECORATED, "ahk_id " . id)

        ; Get the monitor where window is currently located
        mon := GetMonitorActiveWindow("ahk_id " . id)
        MonitorGet(mon, &monLeft, &monTop, &monRight, &monBottom)
        WinMove(monLeft, monTop, monRight - monLeft, monBottom - monTop, winTitle)
    }
}

; ============================================================================
; RestoreWindowBorders(winTitle) - Restore standard window decorations
; Parameters:
;   winTitle - Window to affect
; ============================================================================
RestoreWindowBorders(winTitle) {
    WinSetStyle(0xC00000, winTitle)   ; restore title bar
    WinSetStyle(0x800000, winTitle)   ; restore thin-line border
    WinSetStyle(0x400000, winTitle)   ; restore dialog frame
    WinSetStyle(0x40000, winTitle)    ; restore thickframe/sizebox
}
