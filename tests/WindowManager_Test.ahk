#Requires AutoHotkey v2.0
#SingleInstance Force

#Include %A_ScriptDir%\..\Lib\WindowManager.ahk
#Include %A_ScriptDir%\TestKit.ahk

global DECORATED := 0xCF0000      ; WS_OVERLAPPEDWINDOW, includes WS_SIZEBOX
global FIXED_SIZE := 0xC80000     ; caption + system menu, no WS_SIZEBOX
global WS_MAXIMIZE := 0x1000000

; Fake window system: monitors are {l, t, r, b, workBottom}, windows are hwnd -> {x, y, w, h, style}
class FakeDesktop {
    __New(monitors) {
        this.monitors := monitors
        this.windows := Map()
        this.active := 0
        this.waitResult := 0
    }

    AddWindow(hwnd, x, y, w, h, style := DECORATED) {
        this.windows[hwnd] := {x: x, y: y, w: w, h: h, style: style, maximizedFrom: ""}
        this.active := hwnd
    }

    ; Maximized windows remember their normal rect, like the real window system
    AddMaximizedWindow(hwnd, normal, maxRect) {
        this.AddWindow(hwnd, maxRect[1], maxRect[2], maxRect[3], maxRect[4], DECORATED | WS_MAXIMIZE)
        this.windows[hwnd].maximizedFrom := normal
    }

    Geometry(hwnd) {
        win := this.windows[hwnd]
        return [win.x, win.y, win.w, win.h]
    }

    Resolve(winTitle) {
        if (winTitle = "A")
            return this.active
        if RegExMatch(winTitle, "^ahk_id (\d+)$", &m) && this.windows.Has(Integer(m[1]))
            return Integer(m[1])
        return 0
    }

    WinExist(winTitle) => this.Resolve(winTitle)
    WinWait(winTitle, winText?, timeout?) => this.waitResult
    WinGetStyle(winTitle) => this.windows[this.Resolve(winTitle)].style

    WinSetStyle(style, winTitle) {
        win := this.windows[this.Resolve(winTitle)]
        prefix := SubStr(style, 1, 1)
        if (prefix = "-")
            win.style := win.style & ~Integer(SubStr(style, 2))
        else if (prefix = "+")
            win.style := win.style | Integer(SubStr(style, 2))
        else
            win.style := style
    }

    WinGetPos(&x, &y, &w, &h, winTitle) {
        win := this.windows[this.Resolve(winTitle)]
        x := win.x, y := win.y, w := win.w, h := win.h
    }

    WinGetMinMax(winTitle) => this.windows[this.Resolve(winTitle)].maximizedFrom ? 1 : 0

    WinRestore(winTitle) {
        win := this.windows[this.Resolve(winTitle)]
        if !win.maximizedFrom
            return
        normal := win.maximizedFrom
        win.x := normal[1], win.y := normal[2], win.w := normal[3], win.h := normal[4]
        win.style := win.style & ~WS_MAXIMIZE
        win.maximizedFrom := ""
    }

    WinMove(x?, y?, w?, h?, winTitle?) {
        win := this.windows[this.Resolve(winTitle)]
        if IsSet(x)
            win.x := x
        if IsSet(y)
            win.y := y
        if IsSet(w)
            win.w := w
        if IsSet(h)
            win.h := h
    }

    MonitorGetCount() => this.monitors.Length
    MonitorGetPrimary() => 1

    MonitorGet(n, &left, &top, &right, &bottom) {
        mon := this.monitors[n]
        left := mon.l, top := mon.t, right := mon.r, bottom := mon.b
    }

    MonitorGetWorkArea(n, &left, &top, &right, &bottom) {
        mon := this.monitors[n]
        left := mon.l, top := mon.t, right := mon.r, bottom := mon.workBottom
    }
}

; Primary 1920x1080 with a 40px taskbar, second monitor to its right
TwoMonitors() => FakeDesktop([
    {l: 0, t: 0, r: 1920, b: 1080, workBottom: 1040},
    {l: 1920, t: 0, r: 3840, b: 1080, workBottom: 1040}
])

testOut.WriteLine("GetMonitorAtPos...")

single := FakeDesktop([{l: 0, t: 0, r: 1920, b: 1080, workBottom: 1040}])
AssertEqual(1, GetMonitorAtPos(960, 540, single), "Single monitor - Center")
AssertEqual(1, GetMonitorAtPos(0, 0, single), "Single monitor - Top Left edge")
AssertEqual(1, GetMonitorAtPos(1920, 1080, single), "Single monitor - Bottom Right edge")
AssertEqual(-1, GetMonitorAtPos(-1, 540, single), "Single monitor - Out of bounds Left")
AssertEqual(-1, GetMonitorAtPos(1921, 540, single), "Single monitor - Out of bounds Right")
AssertEqual(-1, GetMonitorAtPos(960, -1, single), "Single monitor - Out of bounds Top")
AssertEqual(-1, GetMonitorAtPos(960, 1081, single), "Single monitor - Out of bounds Bottom")

multi := FakeDesktop([
    {l: 0, t: 0, r: 1920, b: 1080, workBottom: 1080},
    {l: -1080, t: 0, r: 0, b: 1920, workBottom: 1920},
    {l: 1920, t: 0, r: 3840, b: 1080, workBottom: 1080},
    {l: 0, t: -1080, r: 1920, b: 0, workBottom: 0}
])
AssertEqual(1, GetMonitorAtPos(960, 540, multi), "Multi monitor - Primary Center")
AssertEqual(2, GetMonitorAtPos(-500, 500, multi), "Multi monitor - Left Monitor")
AssertEqual(3, GetMonitorAtPos(2500, 500, multi), "Multi monitor - Right Monitor")
AssertEqual(4, GetMonitorAtPos(960, -500, multi), "Multi monitor - Top Monitor")
AssertEqual(1, GetMonitorAtPos(0, 0, multi), "Multi monitor - Origin overlapping")
AssertEqual(1, GetMonitorAtPos(1920, 500, multi), "Multi monitor - Border overlapping Primary/Right")
AssertEqual(-1, GetMonitorAtPos(960, 2000, multi), "Multi monitor - Out of bounds Bottom")
AssertEqual(-1, GetMonitorAtPos(-2000, 500, multi), "Multi monitor - Out of bounds Far Left")

AssertEqual(-1, GetMonitorAtPos(0, 0, FakeDesktop([])), "Zero monitors - Should return -1")

testOut.WriteLine("ToggleFakeFullscreen...")

desk := TwoMonitors()
desk.AddWindow(101, 2000, 100, 800, 600)
AssertEqual(true, ToggleFakeFullscreen("A", desk), "Fullscreen - reports entered")
AssertEqual([1920, 0, 1920, 1080], desk.Geometry(101), "Fullscreen - fills the window's own monitor")
AssertEqual(0, desk.windows[101].style & 0xC00000, "Fullscreen - title bar removed")
AssertEqual(false, ToggleFakeFullscreen("A", desk), "Fullscreen again - reports restored")
AssertEqual([2000, 100, 800, 600], desk.Geometry(101), "Fullscreen again - original geometry back")
AssertEqual(DECORATED, desk.windows[101].style, "Fullscreen again - original style back")

desk := TwoMonitors()
desk.AddWindow(102, -5000, -5000, 400, 300)
ToggleFakeFullscreen("A", desk)
AssertEqual([0, 0, 1920, 1080], desk.Geometry(102), "Fullscreen off-screen window - uses primary monitor")

AssertEqual(false, ToggleFakeFullscreen("A", TwoMonitors()), "Fullscreen with no window - returns false")

testOut.WriteLine("SnapWindow / RestoreWindow...")

desk := TwoMonitors()
desk.AddWindow(201, 300, 200, 640, 480)
SnapWindow("left", "A", desk)
AssertEqual([0, 0, 1024, 1040], desk.Geometry(201), "Snap left - capped width, work-area height")
SnapWindow("right", "A", desk)
AssertEqual([1024, 0, 896, 1040], desk.Geometry(201), "Snap right - rest of the work area")
AssertEqual(true, RestoreWindow("A", desk), "Restore - reports restored")
AssertEqual([300, 200, 640, 480], desk.Geometry(201), "Restore - geometry from before the first snap")
AssertEqual(false, RestoreWindow("A", desk), "Restore twice - nothing remembered")

desk := TwoMonitors()
desk.AddWindow(202, 2100, 50, 500, 400)
SnapWindow("left", "A", desk)
AssertEqual([1920, 0, 1024, 1040], desk.Geometry(202), "Snap left on second monitor - offset by monitor left")

desk := TwoMonitors()
desk.AddWindow(203, 300, 200, 640, 480, FIXED_SIZE)
SnapWindow("right", "A", desk)
AssertEqual([1024, 0, 640, 480], desk.Geometry(203), "Snap non-resizable - moves without resizing")

desk := TwoMonitors()
desk.AddWindow(204, 300, 200, 640, 480)
SnapWindow("left", "A", desk)
ToggleFakeFullscreen("A", desk)
RestoreWindow("A", desk)
AssertEqual([300, 200, 640, 480], desk.Geometry(204), "Snap, fullscreen, restore - back to the original window")

desk := TwoMonitors()
desk.AddWindow(205, 300, 200, 640, 480)
ToggleFakeFullscreen("A", desk)
SnapWindow("left", "A", desk)
AssertEqual(DECORATED, desk.windows[205].style, "Fullscreen then snap - borders come back")
AssertEqual(true, ToggleFakeFullscreen("A", desk), "Snapped window - toggle enters fullscreen, not restore")

desk := TwoMonitors()
desk.AddMaximizedWindow(206, [300, 200, 640, 480], [0, 0, 1920, 1040])
SnapWindow("left", "A", desk)
RestoreWindow("A", desk)
AssertEqual([300, 200, 640, 480], desk.Geometry(206), "Maximized, snap, restore - back to the normal window")
AssertEqual(DECORATED, desk.windows[206].style, "Maximized, snap, restore - no stale WS_MAXIMIZE")

testOut.WriteLine("WaitForWindow...")

desk := TwoMonitors()
desk.waitResult := 12345
AssertEqual(true, WaitForWindow("TestWin", 5, desk), "WaitForWindow - hit returns true")
desk.waitResult := 0
AssertEqual(false, WaitForWindow("TestWin", 5, desk), "WaitForWindow - timeout returns false")

FinishTests()
