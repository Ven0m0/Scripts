#Requires AutoHotkey v2.0
#Include AHK_Common.ahk

MockRun(target) {
    throw Error("Simulated elevation failure")
}

global msgBoxText := ""

MockMsgBox(text) {
    global msgBoxText
    msgBoxText := text
}

MockExitApp() {
    global msgBoxText
    out := FileOpen("*", "w `n")
    if InStr(msgBoxText, "Failed to elevate: Simulated elevation failure") {
        out.Write("Test Passed: Caught simulated elevation failure.`n")
        out.Close()
        ExitApp(0)
    } else {
        out.Write("Test Failed: Error MsgBox not encountered or incorrect text.`n")
        out.Close()
        ExitApp(1)
    }
}

; Trigger the error path
RequireAdmin(false, MockRun, MockMsgBox, MockExitApp)

; Fallback failure if the async process fails or the error is never triggered
out := FileOpen("*", "w `n")
out.Write("Test Failed: Script did not exit through MockExitApp.`n")
out.Close()
ExitApp(1)
