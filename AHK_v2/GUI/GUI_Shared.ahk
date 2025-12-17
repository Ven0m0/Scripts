#Requires AutoHotkey v2.0

; ============================================================================
; GUI_Shared.ahk - Shared GUI framework for launcher scripts
; Version: 2.0.0 (Migrated to AHK v2)
;
; Provides data-driven GUI creation for script launchers
; ============================================================================

#Include %A_ScriptDir%\..\..\Lib\v2\AHK_Common.ahk
InitScript(true, true, true)  ; UIA + Admin + Performance

#SingleInstance Force
Persistent

global gButtonActions := Map()
global gActionCount := 0
global DEFAULT_WAIT_TIMEOUT := 30
global g GUI := ""

; ============================================================================
; CreateLauncherGui(tabLabels, buttonSets, windowTitle := "My Codes")
; Main entry point - creates tabbed GUI with buttons
;
; Parameters:
;   tabLabels   - Pipe-separated string of tab names (e.g., "Tab1|Tab2|Tab3")
;   buttonSets  - Array of button arrays, one per tab
;   windowTitle - Title for the GUI window
; ============================================================================
CreateLauncherGui(tabLabels, buttonSets, windowTitle := "My Codes") {
    global gButtonActions, gActionCount, gGUI
    ResetActions()

    gGUI := Gui("+AlwaysOnTop -MinimizeBox", windowTitle)
    gGUI.OnEvent("Close", (*) => ExitApp())

    ; Create Tab control
    tab := gGUI.Add("Tab3", , StrSplit(tabLabels, "|"))

    ; Add buttons to each tab
    for index, buttons in buttonSets {
        tab.UseTab(index)
        AddButtons(buttons)
    }

    tab.UseTab()  ; Future controls outside tabs

    ; Add OK button
    okBtn := gGUI.Add("Button", "default xm", "OK")
    okBtn.OnEvent("Click", (*) => ExitApp())

    gGUI.Show()
}

; ============================================================================
; AddButtons(buttons) - Add multiple buttons from array
; ============================================================================
AddButtons(buttons) {
    for _, button in buttons {
        AddButton(button)
    }
}

; ============================================================================
; AddButton(button) - Add single button to GUI
;
; Button object structure:
;   {label: "Button Text", x: 10, y: 10, action: {...}}
; ============================================================================
AddButton(button) {
    global gActionCount, gButtonActions, gGUI

    gActionCount++
    controlName := "Action" . gActionCount

    ; Create button
    btn := gGUI.Add("Button", "w80 h50 x" . button.x . " y" . button.y, button.label)
    btn.OnEvent("Click", HandleAction.Bind(controlName))

    ; Store action
    gButtonActions[controlName] := button.action
}

; ============================================================================
; HandleAction(controlName, *) - Button click handler
; ============================================================================
HandleAction(controlName, *) {
    global gButtonActions
    action := gButtonActions[controlName]
    PerformAction(action)
}

; ============================================================================
; PerformAction(action) - Execute action based on action object
;
; Action types:
;   {run: "path", storePidVar: "varName", waitExe: "ahk_exe...", priority: "High"}
;   {killPidVar: "varName"}
;   {killWinTitle: "ahk_exe..."}
;   {activateTitle: "ahk_exe...", sendKeys: "keys"}
; ============================================================================
PerformAction(action) {
    if (!IsObject(action))
        return

    ; Run action
    if (action.Has("run")) {
        pid := 0
        pidVar := action.Has("storePidVar") ? action.storePidVar : ""
        target := QuotePathIfNeeded(action.run)

        try {
            Run(target, , , &pid)

            if (pidVar != "")
                %pidVar% := pid

            ; Wait for window if specified
            if (action.Has("waitExe")) {
                timeout := action.Has("waitTimeout") ? action.waitTimeout : DEFAULT_WAIT_TIMEOUT

                try {
                    WinWait(action.waitExe, , timeout)
                    waitedPid := WinGetPID(action.waitExe)
                    pid := waitedPid

                    if (pidVar != "")
                        %pidVar% := pid
                } catch TimeoutError {
                    MsgBox("Timed out waiting for " . action.waitExe . " after " . timeout . " seconds.", "Window Not Found", "Icon!")
                    return
                }
            }

            ; Set priority if specified
            if (action.Has("priority") && pid) {
                try ProcessSetPriority(action.priority, pid)
            }

            ActivateIfNeeded(action)
            return
        } catch Error as err {
            MsgBox("Failed to run: " . target . "`n`nError: " . err.Message, "Run Error", "Icon!")
            return
        }
    }

    ; Kill by PID variable
    if (action.Has("killPidVar")) {
        pidVar := action.killPidVar
        pid := %pidVar%

        if (pid) {
            try WinKill("ahk_pid " . pid)
        }
        return
    }

    ; Kill by window title
    if (action.Has("killWinTitle")) {
        try WinKill(action.killWinTitle)
        return
    }

    ActivateIfNeeded(action)
}

; ============================================================================
; ResetActions() - Clear all stored button actions
; ============================================================================
ResetActions() {
    global gButtonActions, gActionCount
    gButtonActions := Map()
    gActionCount := 0
}

; ============================================================================
; QuotePathIfNeeded(target) - Add quotes to paths with spaces
; ============================================================================
QuotePathIfNeeded(target) {
    if (!target)
        return target

    firstChar := SubStr(target, 1, 1)
    lastChar := SubStr(target, -1)

    if (InStr(target, " ") && firstChar != '"' && lastChar != '"')
        return '"' . target . '"'

    return target
}

; ============================================================================
; ActivateIfNeeded(action) - Activate window and/or send keys
; ============================================================================
ActivateIfNeeded(action) {
    if (!action.Has("activateTitle") && !action.Has("sendKeys"))
        return

    if (action.Has("activateTitle")) {
        if (WinExist(action.activateTitle)) {
            WinActivate(action.activateTitle)
        }
    }

    if (action.Has("sendKeys")) {
        Send(action.sendKeys)
    }
}
