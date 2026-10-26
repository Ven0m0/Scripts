#Requires AutoHotkey v2.0
#SingleInstance Force

#Include %A_ScriptDir%\..\Lib\AHK_Common.ahk
#Include %A_ScriptDir%\TestKit.ahk

; Records what RequireAdmin asked of the host instead of elevating or exiting
class FakeHost {
    __New(isAdmin, runFails := false) {
        this.admin := isAdmin
        this.runFails := runFails
        this.ran := ""
        this.shown := ""
        this.exited := false
    }

    IsAdmin() => this.admin

    Run(target) {
        this.ran := target
        if this.runFails
            throw Error("Simulated elevation failure")
    }

    MsgBox(text) {
        this.shown := text
    }

    ExitApp(code := 0) {
        this.exited := true
    }
}

host := FakeHost(true)
RequireAdmin(host)
AssertEqual([false, ""], [host.exited, host.ran], "Already admin - no relaunch, no exit")

host := FakeHost(false)
RequireAdmin(host)
AssertEqual('*RunAs "' . A_ScriptFullPath . '"', host.ran, "Not admin - relaunches elevated")
AssertEqual([true, ""], [host.exited, host.shown], "Not admin - exits without an error")

host := FakeHost(false, true)
RequireAdmin(host)
AssertEqual("Failed to elevate: Simulated elevation failure", host.shown, "Elevation fails - reports the error")
AssertEqual(true, host.exited, "Elevation fails - still exits")

FinishTests()
