#Requires AutoHotkey v2.0

; WindowManager – borderless/fullscreen utilities

static STYLE_DECORATIONS := 0xEC0000      ; title/menu/frame/sysmodal combined
static STYLE_UNDECORATED := -0xEC0000

ToggleFakeFullscreen(winTitle := "A", api := "") {
    if !api
        api := SystemWindowAPI()

    current := api.WinGetStyle(winTitle)
    hasTitle := current & 0xC00000
    if hasTitle {
        api.WinSetStyle(STYLE_UNDECORATED, winTitle)
        api.WinMove(0, 0, api.GetScreenWidth(), api.GetScreenHeight(), winTitle)
    } else {
        api.WinSetStyle(STYLE_DECORATIONS, winTitle)
        api.WinRestore(winTitle)
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

WaitForWindow(winTitle, timeout := 30, api := "") {
    if !api
        api := SystemWindowAPI()

    return api.WinWait(winTitle, , timeout) != 0
}

WaitForProcess(processName, timeout := 30) {
    return ProcessWait(processName, timeout) != 0
}

GetMonitorAtPos(x, y, api := "") {
    if !api
        api := SystemWindowAPI()

    count := api.MonitorGetCount()
    Loop count {
        api.MonitorGet(A_Index, &l, &t, &r, &b)
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

class SystemWindowAPI {
    WinWait(winTitle, winText?, timeout?) => WinWait(winTitle, winText?, timeout?)
    WinGetStyle(winTitle) => WinGetStyle(winTitle)
    WinSetStyle(style, winTitle) => WinSetStyle(style, winTitle)
    WinMove(x, y, w, h, winTitle) => WinMove(x, y, w, h, winTitle)
    WinRestore(winTitle) => WinRestore(winTitle)
    GetScreenWidth() => A_ScreenWidth
    GetScreenHeight() => A_ScreenHeight
    MonitorGetCount() => MonitorGetCount()
    MonitorGet(N, &Left, &Top, &Right, &Bottom) => MonitorGet(N, &Left, &Top, &Right, &Bottom)
}
