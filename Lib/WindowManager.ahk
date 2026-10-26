#Requires AutoHotkey v2.0

; WindowManager - window placement: fake fullscreen, snap, and restore, each on the window's own monitor

global STYLE_UNDECORATED := "-0xEC0000"     ; title/menu/frame/sysmodal combined
global WS_SIZEBOX := 0x40000
global SNAP_MAX_LEFT_WIDTH := 1024

; Returns true when the window is now fake fullscreen, false when it was restored or not found
ToggleFakeFullscreen(winTitle := "A", api := "") {
    if !api
        api := SystemWindowAPI()

    hwnd := api.WinExist(winTitle)
    if !hwnd
        return false

    geometry := RememberedGeometry()
    if geometry.Has(hwnd) && geometry[hwnd].placement = "fullscreen" {
        RestoreWindow("ahk_id " . hwnd, api)
        return false
    }

    RememberGeometry(hwnd, "fullscreen", api)
    api.MonitorGet(MonitorOfWindow(hwnd, api), &l, &t, &r, &b)
    api.WinSetStyle(STYLE_UNDECORATED, "ahk_id " . hwnd)
    api.WinMove(l, t, r - l, b - t, "ahk_id " . hwnd)
    return true
}

; side: "left" or "right"; fills that part of the work area, keeping the size of non-resizable windows
SnapWindow(side, winTitle := "A", api := "") {
    if !api
        api := SystemWindowAPI()

    hwnd := api.WinExist(winTitle)
    if !hwnd
        return false

    saved := RememberGeometry(hwnd, "snap", api)
    id := "ahk_id " . hwnd
    ; Undo a fake fullscreen's stripped borders
    api.WinSetStyle(saved.style, id)

    api.MonitorGetWorkArea(MonitorOfWindow(hwnd, api), &l, &t, &r, &b)
    leftWidth := Round(Min(SNAP_MAX_LEFT_WIDTH, (r - l) * 2 / 3))
    x := (side = "left") ? l : l + leftWidth
    w := (side = "left") ? leftWidth : (r - l) - leftWidth

    if (api.WinGetStyle(id) & WS_SIZEBOX)
        api.WinMove(x, t, w, b - t, id)
    else
        api.WinMove(x, t, , , id)
    return true
}

; Returns the window to its remembered geometry; false when nothing is remembered
RestoreWindow(winTitle := "A", api := "") {
    if !api
        api := SystemWindowAPI()

    hwnd := api.WinExist(winTitle)
    geometry := RememberedGeometry()
    if !hwnd || !geometry.Has(hwnd)
        return false

    saved := geometry.Delete(hwnd)
    api.WinSetStyle(saved.style, "ahk_id " . hwnd)
    api.WinMove(saved.x, saved.y, saved.w, saved.h, "ahk_id " . hwnd)
    return true
}

; shortcut: entries for closed windows stay until the script exits, add cleanup if hwnds ever pile up
RememberedGeometry() {
    static geometry := Map()
    return geometry
}

; The first placement's geometry wins, so a chain of placements restores to the original window
RememberGeometry(hwnd, placement, api) {
    geometry := RememberedGeometry()
    if !geometry.Has(hwnd) {
        id := "ahk_id " . hwnd
        ; Remember the normal window, not the maximized/minimized rectangle and state bits
        if api.WinGetMinMax(id) != 0
            api.WinRestore(id)
        api.WinGetPos(&x, &y, &w, &h, id)
        geometry[hwnd] := {style: api.WinGetStyle(id), x: x, y: y, w: w, h: h}
    }
    geometry[hwnd].placement := placement
    return geometry[hwnd]
}

; Off-screen windows fall back to the primary monitor
MonitorOfWindow(hwnd, api) {
    api.WinGetPos(&x, &y, &w, &h, "ahk_id " . hwnd)
    mon := GetMonitorAtPos(x + w / 2, y + h / 2, api)
    return (mon = -1) ? api.MonitorGetPrimary() : mon
}

GetMonitorAtPos(x, y, api := "") {
    if !api
        api := SystemWindowAPI()

    Loop api.MonitorGetCount() {
        api.MonitorGet(A_Index, &l, &t, &r, &b)
        if (l <= x && x <= r && t <= y && y <= b)
            return A_Index
    }
    return -1
}

WaitForWindow(winTitle, timeout := 30, api := "") {
    if !api
        api := SystemWindowAPI()

    return api.WinWait(winTitle, , timeout) != 0
}

WaitForProcess(processName, timeout := 30) {
    return ProcessWait(processName, timeout) != 0
}

class SystemWindowAPI {
    WinExist(winTitle) => WinExist(winTitle)
    WinWait(winTitle, winText?, timeout?) => WinWait(winTitle, winText?, timeout?)
    WinGetStyle(winTitle) => WinGetStyle(winTitle)
    WinSetStyle(style, winTitle) => WinSetStyle(style, winTitle)
    WinGetPos(&x, &y, &w, &h, winTitle) => WinGetPos(&x, &y, &w, &h, winTitle)
    WinGetMinMax(winTitle) => WinGetMinMax(winTitle)
    WinRestore(winTitle) => WinRestore(winTitle)
    WinMove(x?, y?, w?, h?, winTitle?) => WinMove(x?, y?, w?, h?, winTitle?)
    MonitorGetCount() => MonitorGetCount()
    MonitorGetPrimary() => MonitorGetPrimary()
    MonitorGet(n, &left, &top, &right, &bottom) => MonitorGet(n, &left, &top, &right, &bottom)
    MonitorGetWorkArea(n, &left, &top, &right, &bottom) => MonitorGetWorkArea(n, &left, &top, &right, &bottom)
}
