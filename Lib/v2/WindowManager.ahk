#Requires AutoHotkey v2.0

; WindowManager – borderless/fullscreen utilities

static STYLE_DECORATIONS := 0xEC0000      ; title/menu/frame/sysmodal combined
static STYLE_UNDECORATED := -0xEC0000

ToggleFakeFullscreen(winTitle := "A") {
    current := WinGetStyle(winTitle)
    hasTitle := current & 0xC00000
    if hasTitle {
        WinSetStyle(STYLE_UNDECORATED, winTitle)
        WinMove(0, 0, A_ScreenWidth, A_ScreenHeight, winTitle)
    } else {
        WinSetStyle(STYLE_DECORATIONS, winTitle)
        WinRestore(winTitle)
    }
}

SetWindowBorderless(winTitle) {
    WinSetStyle(STYLE_UNDECORATED, winTitle)
}

MaximizeWindow(winTitle) {
    WinMove(0, 0, A_ScreenWidth, A_ScreenHeight, winTitle)
}

MakeFullscreen(winTitle) {
    SetWindowBorderless(winTitle)
    MaximizeWindow(winTitle)
}

WaitForWindow(winTitle, timeout := 30) {
    try {
        WinWait(winTitle, , timeout)
        return true
    } catch TimeoutError {
        return false
    }
}

WaitForProcess(processName, timeout := 30) {
    start := A_TickCount
    limit := timeout * 1000
    while !ProcessExist(processName) {
        if (A_TickCount - start > limit)
            return false
        Sleep(100)
    }
    return true
}

GetMonitorAtPos(x, y) {
    count := MonitorGetCount()
    Loop count {
        MonitorGet(A_Index, &l, &t, &r, &b)
        if (l <= x && x <= r && t <= y && y <= b)
            return A_Index
    }
    return -1
}

GetMonitorActiveWindow(winTitle := "A") {
    WinGetPos(&x, &y, &w, &h, winTitle)
    return GetMonitorAtPos(x + w/2, y + h/2)
}

ToggleFakeFullscreenMultiMonitor(winTitle := "A") {
    static saved := Map()
    id := WinGetID(winTitle)

    if saved.Has(id) {
        inf := saved[id]
        WinSetStyle(inf.style, "ahk_id " . id)
        WinMove(inf.x, inf.y, inf.w, inf.h, "ahk_id " . id)
        saved.Delete(id)
        return
    }

    inf := Map()
    inf.style := WinGetStyle(winTitle)
    WinGetPos(&ix, &iy, &iw, &ih, "ahk_id " . id)
    inf.x := ix, inf.y := iy, inf.w := iw, inf.h := ih
    saved[id] := inf

    WinSetStyle(STYLE_UNDECORATED, "ahk_id " . id)
    mon := GetMonitorActiveWindow("ahk_id " . id)
    MonitorGet(mon, &ml, &mt, &mr, &mb)
    WinMove(ml, mt, mr - ml, mb - mt, winTitle)
}

RestoreWindowBorders(winTitle) {
    WinSetStyle(STYLE_DECORATIONS, winTitle)
}
