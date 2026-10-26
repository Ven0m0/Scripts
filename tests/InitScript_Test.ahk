#Requires AutoHotkey v2.0
#SingleInstance Force

#Include %A_ScriptDir%\..\Lib\AHK_Common.ahk
#Include %A_ScriptDir%\TestKit.ahk

SetKeyDelay(10)
InitScript({titleMatch: 3, optimize: false})
AssertEqual(3, A_TitleMatchMode, "titleMatch option - sets the mode")
AssertEqual("Fast", A_TitleMatchModeSpeed, "titleMatch option - keeps fast matching")
AssertEqual(10, A_KeyDelay, "optimize false - leaves delays alone")

InitScript()
AssertEqual(2, A_TitleMatchMode, "defaults - title match mode 2")
AssertEqual(-1, A_KeyDelay, "defaults - zero key delay")
AssertEqual("Input", A_SendMode, "defaults - SendMode Input")
AssertEqual(A_ScriptDir, A_WorkingDir, "defaults - working dir is the script dir")

FinishTests()
