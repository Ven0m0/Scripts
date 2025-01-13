; UIA check
if !InStr(A_AhkPath, "_UIA.exe") {
    Run, % A_AhkPath . " U" (32 << A_Is64bitOS) "_UIA.exe"
    ExitApp
}

#SingleInstance, Force
#NoEnv
#Warn
#KeyHistory 0
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
ListLines Off
SetBatchLines, -1 ; Script doesnt sleep every line (CPU heavy)
SendMode Input
Process, Priority, , A
;Incase SendMode Input doesn't work
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1
SetControlDelay, -1

F6::
Send {LButton down}
return

F7::ExitApp