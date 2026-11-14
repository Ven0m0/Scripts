#Requires AutoHotkey v2.0
#SingleInstance Force

#Include %A_ScriptDir%\..\Lib\AHK_Common.ahk
#Include %A_ScriptDir%\TestKit.ahk

defaults := Map("fishing", "F7", "exit", "F9")
ini := A_Temp . "\LoadHotkeys_Test_" . A_TickCount . ".ini"

AssertEqual("F7", LoadHotkeys(ini, "MC_AFK", defaults)["fishing"], "missing file - default")

FileAppend("[MC_AFK]`nfishing= ^F1 `nexit=`n[Other]`nfishing=F12`n", ini)
keys := LoadHotkeys(ini, "MC_AFK", defaults)
AssertEqual("^F1", keys["fishing"], "set value - overrides and is trimmed")
AssertEqual("F9", keys["exit"], "empty value - default")
AssertEqual("F7", LoadHotkeys(ini, "Missing", defaults)["fishing"], "missing section - default")
AssertEqual("F12", LoadHotkeys(ini, "Other", defaults)["fishing"], "other section - isolated")
AssertEqual(2, keys.Count, "result has exactly the requested names")

FileDelete(ini)
FinishTests()
