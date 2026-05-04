#Requires AutoHotkey v2.0
#Include A_ScriptDir "\..\Lib\v2\WindowManager.ahk"

class MockWindowAPI {
    __New() {
        this.calls := []
        this.mockStyle := 0xC00000 ; Has title
        this.screenWidth := 1920
        this.screenHeight := 1080
        this.monitors := []
    }

    WinGetStyle(winTitle) {
        this.calls.Push({method: "WinGetStyle", args: [winTitle]})
        return this.mockStyle
    }

    WinSetStyle(style, winTitle) {
        this.calls.Push({method: "WinSetStyle", args: [style, winTitle]})
    }

    WinMove(x, y, w, h, winTitle) {
        this.calls.Push({method: "WinMove", args: [x, y, w, h, winTitle]})
    }

    WinRestore(winTitle) {
        this.calls.Push({method: "WinRestore", args: [winTitle]})
    }

    GetScreenWidth() => this.screenWidth
    GetScreenHeight() => this.screenHeight

    MonitorGetCount() {
        this.calls.Push({method: "MonitorGetCount", args: []})
        return this.monitors.Length
    }

    MonitorGet(N, &Left, &Top, &Right, &Bottom) {
        this.calls.Push({method: "MonitorGet", args: [N]})
        if (N > 0 && N <= this.monitors.Length) {
            Left := this.monitors[N].l
            Top := this.monitors[N].t
            Right := this.monitors[N].r
            Bottom := this.monitors[N].b
        }
    }
}

TestToggleFakeFullscreen_MakeFullscreen() {
    mockApi := MockWindowAPI()
    mockApi.mockStyle := 0xC00000 ; Has title

    ToggleFakeFullscreen("TestWindow", mockApi)

    ; Verify calls
    if (mockApi.calls.Length != 3) {
        FileOpen("*", "w `n").Write("Fail: Expected 3 calls, got " mockApi.calls.Length "`n")
        FileOpen("*", "w").Write("Fail: Expected 3 calls, got " mockApi.calls.Length "`n")
    }

    if (mockApi.calls[1].method != "WinGetStyle") {
        FileOpen("*", "w `n").Write("Fail: First call was not WinGetStyle`n")
        ExitApp(1)
    }

    if (mockApi.calls[2].method != "WinSetStyle") {
        FileOpen("*", "w `n").Write("Fail: Second call was not WinSetStyle`n")
        ExitApp(1)
    }

    if (mockApi.calls[3].method != "WinMove") {
        FileOpen("*", "w `n").Write("Fail: Third call was not WinMove`n")
        ExitApp(1)
    }

    FileOpen("*", "w `n").Write("Pass: MakeFullscreen`n")
    return true
}

TestToggleFakeFullscreen_RestoreWindow() {
    mockApi := MockWindowAPI()
    mockApi.mockStyle := 0 ; No title

    ToggleFakeFullscreen("TestWindow", mockApi)

    ; Verify calls
    if (mockApi.calls.Length != 3) {
        FileOpen("*", "w `n").Write("Fail: Expected 3 calls, got " mockApi.calls.Length "`n")
        ExitApp(1)
    }

    if (mockApi.calls[2].method != "WinSetStyle") {
        FileOpen("*", "w `n").Write("Fail: Second call was not WinSetStyle`n")
        ExitApp(1)
    }

    if (mockApi.calls[3].method != "WinRestore") {
        FileOpen("*", "w `n").Write("Fail: Third call was not WinRestore`n")
        ExitApp(1)
    }

    FileOpen("*", "w `n").Write("Pass: RestoreWindow`n")
    return true
}

TestGetMonitorAtPos_InsideMonitor() {
    mockApi := MockWindowAPI()
    mockApi.monitors := [
        {l: 0, t: 0, r: 1920, b: 1080}
    ]

    res := GetMonitorAtPos(500, 500, mockApi)
    if (res != 1) {
        FileOpen("*", "w `n").Write("Fail: Expected 1, got " res "`n")
        ExitApp(1)
    }
    FileOpen("*", "w `n").Write("Pass: GetMonitorAtPos_InsideMonitor`n")
    return true
}

TestGetMonitorAtPos_OutsideMonitors() {
    mockApi := MockWindowAPI()
    mockApi.monitors := [
        {l: 0, t: 0, r: 1920, b: 1080}
    ]

    res := GetMonitorAtPos(-100, 500, mockApi)
    if (res != -1) {
        FileOpen("*", "w `n").Write("Fail: Expected -1, got " res "`n")
        ExitApp(1)
    }
    FileOpen("*", "w `n").Write("Pass: GetMonitorAtPos_OutsideMonitors`n")
    return true
}

TestGetMonitorAtPos_MultipleMonitors() {
    mockApi := MockWindowAPI()
    mockApi.monitors := [
        {l: 0, t: 0, r: 1920, b: 1080},
        {l: -1920, t: 0, r: 0, b: 1080}
    ]

    res := GetMonitorAtPos(-500, 500, mockApi)
    if (res != 2) {
        FileOpen("*", "w `n").Write("Fail: Expected 2, got " res "`n")
        ExitApp(1)
    }
    FileOpen("*", "w `n").Write("Pass: GetMonitorAtPos_MultipleMonitors`n")
    return true
}

TestToggleFakeFullscreen_MakeFullscreen()
TestToggleFakeFullscreen_RestoreWindow()

TestGetMonitorAtPos_InsideMonitor()
TestGetMonitorAtPos_OutsideMonitors()
TestGetMonitorAtPos_MultipleMonitors()

FileOpen("*", "w `n").Write("All tests complete.`n")
ExitApp(0)
