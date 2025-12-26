#Requires AutoHotkey v2.0

; ============================================================================
; ControllerQuit.ahk - Close active window with controller buttons
; Version: 2.0.0 (Migrated to AHK v2)
;
; Functionality:
;   Press Joy9 (Select) + Joy10 (Start) to close active window
;   Works with any detected controller
; ============================================================================

#SingleInstance Force

; Find first available joystick
JoystickNumber := 0
Loop 16 {
    try {
        JoyName := GetKeyState(A_Index . "JoyName")
        if (JoyName != "") {
            JoystickNumber := A_Index
            break
        }
    }
}

if (JoystickNumber == 0) {
    MsgBox("No joystick detected")
    ExitApp()
}

; Get number of buttons
joy_buttons := GetKeyState(JoystickNumber . "JoyButtons")

Loop {
    ; Check all buttons
    buttons_down := ""
    Loop joy_buttons {
        if (GetKeyState(JoystickNumber . "Joy" . A_Index)) {
            buttons_down .= " " . A_Index
        }
    }

    ; If Joy9 (Select) and Joy10 (Start) are pressed, close active window
    if (InStr(buttons_down, " 9") && InStr(buttons_down, " 10")) {
        ; Don't close desktop
        if (!WinActive("ahk_class WorkerW")) {
            WinClose("A")
        }
    }

    Sleep(200)
}
