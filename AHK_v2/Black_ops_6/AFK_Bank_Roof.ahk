#Requires AutoHotkey v2.0

; ============================================================================
; AFK_Bank_Roof.ahk - AFK macro for Black Ops 6 Bank Roof strategy
; Version: 2.0.0 (Migrated to AHK v2)
;
; Hotkeys:
;   F6 - Start AFK macro
;   F7 - Stop and exit
; ============================================================================

#Include %A_ScriptDir%\..\..\Lib\v2\AHK_Common.ahk
InitScript(false, false, true)

#SingleInstance Force
ProcessSetPriority("High")

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
