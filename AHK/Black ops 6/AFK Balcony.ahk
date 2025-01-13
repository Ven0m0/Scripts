; UIA check
if !InStr(A_AhkPath, "_UIA.exe") {
    Run, % A_AhkPath . " U" (32 << A_Is64bitOS) "_UIA.exe"
    ExitApp
}

#SingleInstance, Force
#NoEnv
#Warn
#KeyHistory 0
ListLines Off
SetBatchLines, 10ms
SendMode Input

F6::
SetTimer , AFK , 500
Return

AFK:
Random, rand, 250, 2001
Sleep %rand%
Send {p}
Sleep 1001
Send {2}
Sleep 1001
Send {RButton down}
Sleep 1001
Send {RButton up}
Sleep 3001
Send {c}
Sleep 1001
Send {p}
Sleep 75001
Return

$*F7::
SetTimer, AFK, Off
ExitApp