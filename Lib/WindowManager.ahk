; ============================================================================
; WindowManager.ahk - Window manipulation and fullscreen utilities
; Version: 1.0.0
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
    WinGet, currentStyle, Style, %winTitle%
    hasTitleBar := currentStyle & 0xC00000

    if (hasTitleBar) {
        ; Enter fake fullscreen - remove window decorations
        WinSet, Style, -0xC00000, %winTitle%  ; hide title bar
        WinSet, Style, -0x800000, %winTitle%  ; hide thin-line border
        WinSet, Style, -0x400000, %winTitle%  ; hide dialog frame
        WinSet, Style, -0x40000, %winTitle%   ; hide thickframe/sizebox

        ; Maximize the window
        WinMove, %winTitle%, , 0, 0, A_ScreenWidth, A_ScreenHeight
    } else {
        ; Exit fake fullscreen - restore window decorations
        WinSet, Style, +0xC00000, %winTitle%  ; restore title bar
        WinSet, Style, +0x800000, %winTitle%  ; restore thin-line border
        WinSet, Style, +0x400000, %winTitle%  ; restore dialog frame
        WinSet, Style, +0x40000, %winTitle%   ; restore thickframe/sizebox

        ; Restore window to non-maximized state
        WinRestore, %winTitle%
    }
}

; ============================================================================
; SetWindowBorderless(winTitle) - Remove window borders and decorations
; Parameters:
;   winTitle - Window to affect
; ============================================================================
SetWindowBorderless(winTitle) {
    WinSet, Style, -0xC00000, %winTitle%  ; hide title bar
    WinSet, Style, -0x800000, %winTitle%  ; hide thin-line border
    WinSet, Style, -0x400000, %winTitle%  ; hide dialog frame
    WinSet, Style, -0x40000, %winTitle%   ; hide thickframe/sizebox
}

; ============================================================================
; MaximizeWindow(winTitle) - Maximize window to full screen size
; Parameters:
;   winTitle - Window to affect
; ============================================================================
MaximizeWindow(winTitle) {
    WinMove, %winTitle%, , 0, 0, A_ScreenWidth, A_ScreenHeight
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
; WaitForWindow(winTitle, timeout := 30000) - Wait for window with timeout
; Returns: true if window found, false if timeout
;
; Parameters:
;   winTitle - Window to wait for
;   timeout  - Timeout in milliseconds (default: 30 seconds)
; ============================================================================
WaitForWindow(winTitle, timeout := 30000) {
    WinWait, %winTitle%, , %timeout%
    if ErrorLevel
        return false
    return true
}

; ============================================================================
; WaitForProcess(processName, timeout := 30000) - Wait for process with timeout
; Returns: true if process found, false if timeout
;
; Parameters:
;   processName - Process to wait for (e.g., "notepad.exe")
;   timeout     - Timeout in milliseconds (default: 30 seconds)
; ============================================================================
WaitForProcess(processName, timeout := 30000) {
    Process, Exist, %processName%
    startTime := A_TickCount

    while (!ErrorLevel) {
        if (A_TickCount - startTime > timeout)
            return false

        Sleep, 100
        Process, Exist, %processName%
    }

    return true
}

; ============================================================================
; Multi-monitor aware fullscreen functions
; ============================================================================

GetMonitorAtPos(x, y) {
    ; Monitor number at position x,y or -1 if x,y outside monitors
    SysGet, monitorCount, MonitorCount
    i := 0
    while (i < monitorCount) {
        SysGet, area, Monitor, %i%
        if (areaLeft <= x && x <= areaRight && areaTop <= y && y <= areaBottom)
            return i
        i := i + 1
    }
    return -1
}

GetMonitorActiveWindow(winTitle := "A") {
    ; Get Monitor number at the center position of the specified window
    WinGetPos, x, y, width, height, %winTitle%
    return GetMonitorAtPos(x + width/2, y + height/2)
}

ToggleFakeFullscreenMultiMonitor(winTitle := "A") {
    ; Toggle borderless fullscreen with multi-monitor support
    CoordMode, Screen, Window
    static WINDOW_STYLE_UNDECORATED := -0xC40000
    static savedInfo := Object()

    WinGet, id, ID, %winTitle%
    if (savedInfo[id]) {
        ; Restore saved window state
        inf := savedInfo[id]
        WinSet, Style, % inf["style"], ahk_id %id%
        WinMove, ahk_id %id%, , % inf["x"], % inf["y"], % inf["width"], % inf["height"]
        savedInfo[id] := ""
    } else {
        ; Save current state and make fullscreen
        savedInfo[id] := inf := Object()
        WinGet, ltmp, Style, %winTitle%
        inf["style"] := ltmp
        WinGetPos, ltmpX, ltmpY, ltmpWidth, ltmpHeight, ahk_id %id%
        inf["x"] := ltmpX
        inf["y"] := ltmpY
        inf["width"] := ltmpWidth
        inf["height"] := ltmpHeight
        WinSet, Style, %WINDOW_STYLE_UNDECORATED%, ahk_id %id%

        ; Get the monitor where window is currently located
        mon := GetMonitorActiveWindow("ahk_id " . id)
        SysGet, mon, Monitor, %mon%
        WinMove, %winTitle%, , %monLeft%, %monTop%, % monRight-monLeft, % monBottom-monTop
    }
}
