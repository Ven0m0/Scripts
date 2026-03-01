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
global JoystickNumber := 0
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

; Register individual hotkeys for Joy9 & Joy10
; This is event-driven and much more efficient than a continuous polling loop
Hotkey(JoystickNumber . "Joy9", CheckButtons)
Hotkey(JoystickNumber . "Joy10", CheckButtons)

; Keep script running since there is no longer a loop
Persistent()

CheckButtons(HotkeyName) {
    ; Extract the button number that was pressed (9 or 10)
    pressed_btn := RegExReplace(HotkeyName, "^\d+Joy")
    other_btn := (pressed_btn = "9") ? "10" : "9"

    ; If the other button is also currently held down
    if (GetKeyState(JoystickNumber . "Joy" . other_btn)) {
        ; Don't close desktop
        if (!WinActive("ahk_class WorkerW")) {
            WinClose("A")
        }
    }
}
