#Requires AutoHotkey v2.0
#Include AHK_Common.ahk

MockRun(target) {
    throw Error("Simulated elevation failure")
}

CloseMsgBox() {
    if WinExist("ahk_class #32770") {
        text := WinGetText("ahk_class #32770")
        if InStr(text, "Failed to elevate: Simulated elevation failure") {
            WinClose()
            out := FileOpen("*", "w `n")
            out.Write("Test Passed: Caught simulated elevation failure.`n")
            out.Close()
            ExitApp(0)
        }
    }
}

; Set up a timer to catch and close the MsgBox asynchronously
SetTimer(CloseMsgBox, 50)

; Trigger the error path
RequireAdmin(false, MockRun)

; Fallback failure if the async process fails or the error is never triggered
out := FileOpen("*", "w `n")
out.Write("Test Failed: Error MsgBox not encountered or test timed out.`n")
out.Close()
ExitApp(1)
