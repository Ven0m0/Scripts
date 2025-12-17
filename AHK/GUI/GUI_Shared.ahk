#SingleInstance Force
#Persistent
#NoEnv
#Warn
SetBatchLines -1
SetTitleMatchMode, 3
SetTitleMatchMode, Fast

global gButtonActions := {}
global gButtonCount := 0
global DEFAULT_GUI_TITLE := "My Codes"
global BUTTON_WIDTH := 80
global BUTTON_HEIGHT := 50
global BUTTON_X_START := 22
global BUTTON_X_STEP := 83
global BUTTON_Y_START := 34
global BUTTON_Y_STEP := 56

CreateLauncher(tabs, title := DEFAULT_GUI_TITLE) {
    global gButtonActions, gButtonCount

    gButtonActions := {}
    gButtonCount := 0

    Gui, New, -MinimizeBox +AlwaysOnTop, %title%

    tabNames := ""
    for index, tab in tabs
        tabNames .= (index > 1 ? "|" : "") . tab.Name

    Gui, Add, Tab2,, %tabNames%

    for index, tab in tabs {
        Gui, Tab, %index%
        AddButtonsForTab(tab.Buttons)
    }

    Gui, Tab
    Gui, Add, Button, default xm gOnGuiClose, OK
    Gui, Show
}

AddButtonsForTab(buttons) {
    global gButtonActions, gButtonCount

    if !IsObject(buttons)
        return

    for index, button in buttons {
        column := Mod(index - 1, 2)
        row := Floor((index - 1) / 2)
        x := BUTTON_X_START + (column * BUTTON_X_STEP)
        y := BUTTON_Y_START + (row * BUTTON_Y_STEP)

        gButtonCount++
        controlName := "Btn" . gButtonCount

        Gui, Add, Button, % "gOnButtonClick w" BUTTON_WIDTH " h" BUTTON_HEIGHT " x" x " y" y " v" controlName, % button.Label
        gButtonActions[controlName] := button.Action
    }
}

OnButtonClick:
    global gButtonActions

    GuiControlGet, controlText,, %A_GuiControl%
    buttonName := controlText != "" ? controlText : A_GuiControl

    action := gButtonActions[A_GuiControl]
    if !IsObject(action) {
        OutputDebug, [GUI_Shared] No action registered for %buttonName%
        return
    }

    try {
        action.Call()
    } catch e {
        MsgBox, 16, Action Error, % "Failed to run action for " buttonName ": " e.Message
    }
return

OnGuiClose:
ButtonOK:
GuiClose:
    ExitApp
return
