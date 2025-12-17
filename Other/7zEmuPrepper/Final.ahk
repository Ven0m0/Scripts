#Requires AutoHotkey v2.0

; ============================================================================
; 7zEmuPrepper Configuration GUI
; Generates command line for 7zEmuPrepper.ps1
; ============================================================================

#Warn
#SingleInstance

; Initialize variables
sevenZEmuPrepperPath := ""
sevenZipPath := ""
EmulatorPath := ""
Arguments := ""
ExtractionPath := ""
GamePath := ""
Extensions := ""
KeepExtracted := false

; Create GUI
myGui := Gui("+AlwaysOnTop", "7zEmuPrepper Configuration")

; GroupBox and Edit controls
myGui.Add("GroupBox", "x22 y340 w430 h90", "Batch output")
OutputEdit := myGui.Add("Edit", "ReadOnly x32 y355 w410 h70 vOutput")

myGui.Add("GroupBox", "x2 y19 w150 h30", "7zEmuPrepperPath")
Edit7zEmuPrepper := myGui.Add("Edit", "x2 y34 w130 h20 v7zEmuPrepperPath")
Btn7zEmuPrepper := myGui.Add("Button", "x132 y34 w20 h20", "F")

myGui.Add("GroupBox", "x2 y60 w150 h30", "7ZipPath")
Edit7Zip := myGui.Add("Edit", "x2 y75 w130 h20 v7ZipPath")
Btn7Zip := myGui.Add("Button", "x132 y75 w20 h20", "F")

myGui.Add("GroupBox", "x2 y101 w150 h30", "EmulatorPath")
EditEmulator := myGui.Add("Edit", "x2 y116 w130 h20 vEmulatorPath")
BtnEmulator := myGui.Add("Button", "x132 y116 w20 h20", "F")

myGui.Add("GroupBox", "x2 y142 w150 h30", "Arguments")
EditArguments := myGui.Add("Edit", "x2 y157 w130 h20 vArguments")

myGui.Add("GroupBox", "x2 y183 w150 h30", "ExtractionPath")
EditExtraction := myGui.Add("Edit", "x2 y198 w130 h20 vExtractionPath")
BtnExtraction := myGui.Add("Button", "x132 y198 w20 h20", "F")

myGui.Add("GroupBox", "x2 y224 w150 h30", "GamePath")
EditGame := myGui.Add("Edit", "x2 y239 w130 h20 vGamePath")
BtnGame := myGui.Add("Button", "x132 y239 w20 h20", "F")

myGui.Add("GroupBox", "x2 y265 w150 h30", "Extensions")
EditExtensions := myGui.Add("Edit", "x2 y280 w130 h20 vExtensions")

CheckKeep := myGui.Add("CheckBox", "x2 y305 w130 h30 vKeepExtracted", "KeepExtracted")

; Set event handlers
Edit7zEmuPrepper.OnEvent("Change", UpdateOutput)
Edit7Zip.OnEvent("Change", UpdateOutput)
EditEmulator.OnEvent("Change", UpdateOutput)
EditArguments.OnEvent("Change", UpdateOutput)
EditExtraction.OnEvent("Change", UpdateOutput)
EditGame.OnEvent("Change", UpdateOutput)
EditExtensions.OnEvent("Change", UpdateOutput)
CheckKeep.OnEvent("Click", UpdateOutput)

Btn7zEmuPrepper.OnEvent("Click", Select7zEmuPrepper)
Btn7Zip.OnEvent("Click", Select7Zip)
BtnEmulator.OnEvent("Click", SelectEmulator)
BtnExtraction.OnEvent("Click", SelectExtraction)
BtnGame.OnEvent("Click", SelectGame)

myGui.OnEvent("Close", (*) => ExitApp())

myGui.Show("h480 w640")

; Event handler functions
UpdateOutput(*) {
    global
    sevenZEmuPrepperPath := Edit7zEmuPrepper.Value
    sevenZipPath := Edit7Zip.Value
    EmulatorPath := EditEmulator.Value
    Arguments := EditArguments.Value
    ExtractionPath := EditExtraction.Value
    GamePath := EditGame.Value
    Extensions := EditExtensions.Value
    KeepExtracted := CheckKeep.Value

    keepFlag := KeepExtracted ? " -KeepExtracted" : ""

    outputText := ' "' . sevenZEmuPrepperPath . '" "' . sevenZipPath . '" "'
        . EmulatorPath . '" "' . Arguments . '" "' . ExtractionPath . '" "'
        . GamePath . '" "' . Extensions . '"' . keepFlag . "`r`n"

    OutputEdit.Value := outputText
}

Select7zEmuPrepper(*) {
    global
    selected := FileSelect(3, , "Select 7zEmuPrepper.ps1")
    if (selected != "") {
        Edit7zEmuPrepper.Value := selected
        UpdateOutput()
    }
}

Select7Zip(*) {
    global
    selected := FileSelect(3, , "Select 7-Zip executable")
    if (selected != "") {
        Edit7Zip.Value := selected
        UpdateOutput()
    }
}

SelectEmulator(*) {
    global
    selected := FileSelect(3, , "Select emulator executable")
    if (selected != "") {
        EditEmulator.Value := selected
        UpdateOutput()
    }
}

SelectExtraction(*) {
    global
    selected := DirSelect(, 3, "Select extraction folder")
    if (selected != "") {
        EditExtraction.Value := selected
        UpdateOutput()
    }
}

SelectGame(*) {
    global
    selected := FileSelect(3, , "Select game archive")
    if (selected != "") {
        EditGame.Value := selected
        UpdateOutput()
    }
}
