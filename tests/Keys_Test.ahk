#Requires AutoHotkey v2.0
#SingleInstance Force

#Include %A_ScriptDir%\..\Lib\AHK_Common.ahk
#Include %A_ScriptDir%\TestKit.ahk

InitScript(false, false)

; Define the test mock variables used by Keys.ahk logic
global positions := Map()
global lw := 800
global rw := 900
global mh := 1000
global mw := 1920

; Override API for test
class MockKeysAPI {
    __New() {
        this.calls := []
        this.mockStyle := 0
        this.mockHwnd := 12345
        this.mockPos := {x: 10, y: 20, w: 800, h: 600}
    }

    WinExist(winTitle) {
        this.calls.Push({method: "WinExist", args: [winTitle]})
        return this.mockHwnd
    }

    WinGetPos(&x, &y, &w, &h, winTitle) {
        this.calls.Push({method: "WinGetPos", args: [winTitle]})
        x := this.mockPos.x
        y := this.mockPos.y
        w := this.mockPos.w
        h := this.mockPos.h
    }

    WinGetStyle(winTitle) {
        this.calls.Push({method: "WinGetStyle", args: [winTitle]})
        return this.mockStyle
    }

    WinMove(x, y, w, h, winTitle) {
        this.calls.Push({method: "WinMove", args: [x, y, w, h, winTitle]})
    }

    WinMoveNoSize(x, y, winTitle) {
        this.calls.Push({method: "WinMoveNoSize", args: [x, y, winTitle]})
    }
}

; Include the actual Keys.ahk so we can call the functions
#Include %A_ScriptDir%\..\ahk\Keys.ahk

    testOut.WriteLine("Starting tests for Keys.ahk window functions...")

    ; Test SaveWindowPosition
    global positions := Map()
    api := MockKeysAPI()
    api.mockHwnd := 9999
    api.mockPos := {x: 50, y: 60, w: 1024, h: 768}

    SaveWindowPosition(api)

    AssertEqual(true, positions.Has(9999), "SaveWindowPosition should store entry for hwnd")
    if (positions.Has(9999)) {
        AssertEqual([50, 60, 1024, 768], positions[9999], "SaveWindowPosition should save correct coordinates")
    }

    ; Test IsResizable
    api := MockKeysAPI()
    api.mockStyle := 0x00000000
    AssertEqual(false, IsResizable(api), "IsResizable should return false without WS_SIZEBOX")

    api.mockStyle := 0x00040000
    AssertEqual(true, IsResizable(api), "IsResizable should return true with WS_SIZEBOX")

    ; Test RestoreWindowPosition
    global positions := Map()
    positions[7777] := [100, 200, 800, 600]
    api := MockKeysAPI()
    api.mockHwnd := 7777

    RestoreWindowPosition(api)

    AssertEqual("WinMove", api.calls[2].method, "RestoreWindowPosition should call WinMove")
    if (api.calls.Length >= 2) {
        AssertEqual([100, 200, 800, 600, "A"], api.calls[2].args, "RestoreWindowPosition should move to saved pos")
    }

    ; Test RestoreWindowPosition - No saved position
    api := MockKeysAPI()
    api.mockHwnd := 8888

    RestoreWindowPosition(api)
    AssertEqual(1, api.calls.Length, "RestoreWindowPosition should not call WinMove if not saved")

    ; Test MoveWindowLeft (Resizable)
    global positions := Map()
    api := MockKeysAPI()
    api.mockHwnd := 1111
    api.mockStyle := 0x00040000 ; Resizable

    global lw := 800
    global mh := 1000

    MoveWindowLeft(api)

    AssertEqual(true, positions.Has(1111), "MoveWindowLeft should save position first")
    AssertEqual("WinMove", api.calls[4].method, "MoveWindowLeft should call WinMove")
    if (api.calls.Length >= 4) {
        AssertEqual([0, 0, 800, 1000, "A"], api.calls[4].args, "MoveWindowLeft should move to left half")
    }


    ; Test MoveWindowLeft (Not Resizable)
    global positions := Map()
    api := MockKeysAPI()
    api.mockHwnd := 3333
    api.mockStyle := 0 ; Not resizable

    global lw := 800
    global mh := 1000

    MoveWindowLeft(api)

    AssertEqual(true, positions.Has(3333), "MoveWindowLeft should save position first")
    AssertEqual("WinMoveNoSize", api.calls[4].method, "MoveWindowLeft should call WinMoveNoSize")
    if (api.calls.Length >= 4) {
        AssertEqual([0, 0, "A"], api.calls[4].args, "MoveWindowLeft non-resizable should only move x,y")
    }

    ; Test MoveWindowRight (Not Resizable)
    global positions := Map()
    api := MockKeysAPI()
    api.mockHwnd := 2222
    api.mockStyle := 0 ; Not resizable

    global lw := 800
    global rw := 900
    global mh := 1000

    MoveWindowRight(api)

    AssertEqual(true, positions.Has(2222), "MoveWindowRight should save position first")
    AssertEqual("WinMoveNoSize", api.calls[4].method, "MoveWindowRight should call WinMoveNoSize")
    if (api.calls.Length >= 4) {
        AssertEqual([800, 0, "A"], api.calls[4].args, "MoveWindowRight non-resizable should only move x,y")
    }

FinishTests()
