#Requires AutoHotkey v2.0

; ============================================================================
; AFK_Bank_Roof_Loot.ahk - AFK macro for Bank Roof with loot collection
; Version: 2.0.0 (Migrated to AHK v2)
;
; Hotkeys:
;   F6 - Start AFK macro with timed loot collection
;   F7 - Stop and exit
; ============================================================================

#Include %A_ScriptDir%\..\..\Lib\v2\AHK_Common.ahk
InitScript(false, false, true)

#SingleInstance Force
ProcessSetPriority("High")

; Function to walk forward and back for loot collection
WalkForwardAndBack() {
    Send("{W down}")
    Sleep(500)
    Send("{W up}")
    Sleep(50)
    Send("{S down}")
    Sleep(600)
    Send("{S up}")
    Sleep(50)
}

; Function to clean up remaining zombies
CleanUpZombies() {
    Loop 5 {
        Send("{LButton}")
        Sleep(50)
    }
}

F6:: {
    Loop {
        ; Start of the loop
        StartTime := A_TickCount
        Walked20Seconds := false
        Walked35Seconds := false

        ; Run the loop for 40 seconds
        Loop {
            ; Check if 40 seconds have passed
            if (A_TickCount - StartTime >= 40000)
                break

            ; Random delay
            rand := Random(0, 20)
            DllCall("Sleep", "UInt", rand)
            Send("{LButton}")
            Sleep(10)
            Send("{g}")
            Sleep(100)

            ; Walk forward and back to collect loot at specific intervals
            ElapsedTime := A_TickCount - StartTime

            if (ElapsedTime >= 20000 && ElapsedTime < 21000 && !Walked20Seconds) {
                WalkForwardAndBack()
                Walked20Seconds := true
            }

            if (ElapsedTime >= 35000 && ElapsedTime < 36000 && !Walked35Seconds) {
                WalkForwardAndBack()
                Walked35Seconds := true
            }
        }

        ; Clean up remaining zombies
        CleanUpZombies()
        Sleep(2000)
        CleanUpZombies()

        ; Wait for new Wave of Zombies
        Sleep(12000)
    }
}

F7:: {
    ExitApp()
}
