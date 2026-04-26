#Requires AutoHotkey v2.0
#Include A_ScriptDir "\..\Lib\v2\WindowManager.ahk"

class MockWindowAPI {
    __New() {
        this.calls := []
        this.mockStyle := 0xC00000 ; Has title
        this.screenWidth := 1920
        this.screenHeight := 1080
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
}

TestToggleFakeFullscreen_MakeFullscreen() {
    mockApi := MockWindowAPI()
    mockApi.mockStyle := 0xC00000 ; Has title

    ToggleFakeFullscreen("TestWindow", mockApi)

    ; Verify calls
    if (mockApi.calls.Length != 3) {
        FileOpen("*", "w `n").Write("Fail: Expected 3 calls, got " mockApi.calls.Length "`n")
        return false
    }

    if (mockApi.calls[1].method != "WinGetStyle") {
        FileOpen("*", "w `n").Write("Fail: First call was not WinGetStyle`n")
        return false
    }

    if (mockApi.calls[2].method != "WinSetStyle") {
        FileOpen("*", "w `n").Write("Fail: Second call was not WinSetStyle`n")
        return false
    }

    if (mockApi.calls[3].method != "WinMove") {
        FileOpen("*", "w `n").Write("Fail: Third call was not WinMove`n")
        return false
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
        return false
    }

    if (mockApi.calls[2].method != "WinSetStyle") {
        FileOpen("*", "w `n").Write("Fail: Second call was not WinSetStyle`n")
        return false
    }

    if (mockApi.calls[3].method != "WinRestore") {
        FileOpen("*", "w `n").Write("Fail: Third call was not WinRestore`n")
        return false
    }

    FileOpen("*", "w `n").Write("Pass: RestoreWindow`n")
    return true
}

TestToggleFakeFullscreen_MakeFullscreen()
TestToggleFakeFullscreen_RestoreWindow()

FileOpen("*", "w `n").Write("All tests complete.`n")
ExitApp
