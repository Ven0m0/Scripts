#Requires AutoHotkey v2.0
#Include GUI_Shared.ahk

global testPassed := false
global targetMsgBoxTitle := "Run Error"

; Set a timer to close the error message box
SetTimer(CloseErrorMsgBox, 50)

; Create action with invalid run path
badAction := Map("run", "Z:\NonExistentDrive\ThisExecutableDoesNotExist12345.exe")

; Perform action - this should trigger the run exception and show a MsgBox
PerformAction(badAction)

; Cleanup timer
SetTimer(CloseErrorMsgBox, 0)

; Check result
if (testPassed) {
    FileAppend("PASS: PerformAction correctly handled invalid run exception.`n", "*")
    ExitApp(0)
} else {
    FileAppend("FAIL: PerformAction did not handle invalid run exception as expected (MsgBox not shown/closed).`n", "*")
    ExitApp(1)
}

CloseErrorMsgBox() {
    global testPassed, targetMsgBoxTitle
    if WinExist(targetMsgBoxTitle) {
        WinClose(targetMsgBoxTitle)
        testPassed := true
    }
}
