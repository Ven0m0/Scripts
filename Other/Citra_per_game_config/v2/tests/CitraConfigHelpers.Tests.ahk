#Requires AutoHotkey v2.0
#Include ../CitraConfigHelpers.ahk

CloseMsgBox() {
    if WinExist("Config Save Error") {
        WinClose("Config Save Error")
    }
}

TestSaveConfigError() {
    stdout := FileOpen("*", "w `n")
    stdout.Write("Running TestSaveConfigError...`n")

    ; Create a directory to use as the "file" path to trigger a FileAppend error
    testDirPath := A_ScriptDir . "\test_locked_file"
    if !DirExist(testDirPath)
        DirCreate(testDirPath)

    ; Start a timer to dismiss the MsgBox that SaveConfig will show on failure
    SetTimer(CloseMsgBox, 50)

    ; Attempt to save to a directory, which will fail
    result := SaveConfig("test configuration content", testDirPath)

    ; Stop the timer
    SetTimer(CloseMsgBox, 0)

    ; Clean up
    if DirExist(testDirPath)
        DirRemove(testDirPath)

    if (result == false) {
        stdout.Write("PASS: SaveConfig correctly returned false on error.`n")
    } else {
        stdout.Write("FAIL: SaveConfig returned true despite an error condition.`n")
        ExitApp(1)
    }
}

TestSaveConfigError()
ExitApp(0)
