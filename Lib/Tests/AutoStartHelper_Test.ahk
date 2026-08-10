#Requires AutoHotkey v2.0
#Include %A_ScriptDir%\..\AutoStartHelper.ahk

Test_WaitWin_Timeout() {
    result := WaitWin("NonExistentWindowTitle_1234567890", 0.1)
    if (result != 0) {
        throw Error("Test failed: WaitWin should return false (0) for a nonexistent window, got " . result)
    }
}

Test_WaitWin_Timeout()
