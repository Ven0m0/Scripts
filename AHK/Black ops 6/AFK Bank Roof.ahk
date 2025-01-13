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

; Function to clean up remaining zombies
CleanUpZombies()
{
    Loop 5
    {
        Send {LButton}  ; Auto-repeat consists of consecutive down-events
        Sleep 50  ; The number of milliseconds between keystrokes
    }
}

F6::  ; When F6 is pressed, start the loop
{
    Loop
    {
        ; Start of the loop
        StartTime := A_TickCount  ; Store the start time
        Walked20Seconds := false  ; Flag to check if walking occurred at 20-21 seconds
        Walked35Seconds := false  ; Flag to check if walking occurred at 35-36 seconds
        ; Run the loop
        Loop
        {
        ; Check if 40 seconds have passed
        if (A_TickCount - StartTime >= 40000)
            {
                break  ; Break out of the inner loop
            }            
            ; Your code to execute during the loop goes here
            Random, rand, 0, 20
			DllCall("Sleep","UInt",rand)
            Send {LButton}
            Sleep 10
            Send {g}
            Sleep, 100  ; Add a small delay to prevent high CPU usage
        }
        ; Clean up remaining zombies
        CleanUpZombies()
        Sleep, 2000
        CleanUpZombies()
        ; Wait for new Wave of Zombies
        Sleep, 12000
    }
    return
}

F7::ExitApp