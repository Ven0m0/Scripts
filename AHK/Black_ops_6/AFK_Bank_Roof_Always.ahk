#Include %A_ScriptDir%\..\..\Lib\v1\AHK_Common.ahk
InitScript()

#SingleInstance, Force
#NoEnv
#Warn
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
SetBatchLines, -1
Process, Priority, , A

F6::
Loop {
    Random, rand, 0, 20
    DllCall("Sleep","UInt",rand)
    Send {LButton}
    Sleep 10
    Send {g}
    Sleep 90  ; Total ~120ms per iteration (similar to original behavior)
}
return

F7::ExitApp