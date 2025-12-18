#Requires AutoHotkey v2.0
#SingleInstance

; 7zEmuPrepper command builder (for 7zEmuPrepper.ps1)
; Fields -> emits a ready-to-run PowerShell command. Includes a Copy button.

sevenZEmuPrepperPath := ""
sevenZipPath := ""
emulatorPath := ""
arguments := ""
extractionPath := ""
archivePath := ""
extensions := ""
keepExtracted := false

gui := Gui("+AlwaysOnTop", "7zEmuPrepper Config")
gui.OnEvent("Close", (*) => ExitApp())

gui.Add("GroupBox", "x10 y330 w460 h90", "Command")
outputEdit := gui.Add("Edit", "ReadOnly x20 y350 w440 h60 vOutput")

fields := [
    ["7zEmuPrepper.ps1", "x10 y20 w150 h30", "x10 y40 w390 h23", "vPrepper"],
    ["7Zip exe",         "x10 y70 w150 h30", "x10 y90 w390 h23", "vSevenZip"],
    ["Emulator exe",     "x10 y120 w150 h30","x10 y140 w390 h23", "vEmu"],
    ["Emu Arguments",    "x10 y170 w150 h30","x10 y190 w390 h23", "vArgs"],
    ["Extraction dir",   "x10 y220 w150 h30","x10 y240 w390 h23", "vExtract"],
    ["Archive file",     "x10 y270 w150 h30","x10 y290 w390 h23", "vArchive"],
    ["Launch ext(s)",    "x10 y320 w150 h30","x10 y340 w390 h23", "vExt"]
]

for f in fields {
    gui.Add("GroupBox", f[2])
    gui.Add("Edit", f[3] . " w370").OnEvent("Change", UpdateOutput)
    gui.Add("Button", "x405 y" . SubStr(f[3], 6, 2) . " w35 h23", "…").OnEvent("Click", (btn,*) => SelectFileOrDir(btn))
}

keepCB := gui.Add("CheckBox", "x20 y430 w200 h23 vKeep", "KeepExtracted")
keepCB.OnEvent("Click", UpdateOutput)

copyBtn := gui.Add("Button", "x240 y430 w80 h23", "Copy")
copyBtn.OnEvent("Click", (*) => (A_Clipboard := outputEdit.Value))

gui.Add("Button", "x340 y430 w80 h23", "Exit").OnEvent("Click", (*) => ExitApp())

gui.Show("w480 h470")
return

SelectFileOrDir(btn) {
    global
    text := btn.Text
    if (text = "…") {
        ; infer based on label order
        idx := btn.Hwnd
    }
}

; Simplified per-control selection based on Y position
SelectFileOrDir(btn, *) {
    y := btn.Pos.Y
    if (y < 80)      setVal("Prepper", FileSelect(3, , "Select 7zEmuPrepper.ps1"))
    else if (y < 130) setVal("SevenZip", FileSelect(3, , "Select 7z.exe"))
    else if (y < 180) setVal("Emu", FileSelect(3, , "Select emulator exe"))
    else if (y < 230) setVal("Args", InputBox("Enter emulator arguments (optional):").Value)
    else if (y < 280) setVal("Extract", DirSelect(, 3, "Select extraction folder"))
    else if (y < 330) setVal("Archive", FileSelect(3, , "Select archive"))
    else              setVal("Ext", InputBox("Enter launch extensions (e.g. .iso,.bin):").Value)
    UpdateOutput()
}

setVal(name, val) {
    if (val = "" || val = null) return
    switch name {
        case "Prepper":  ControlSetText(val, "Edit1")
        case "SevenZip": ControlSetText(val, "Edit2")
        case "Emu":      ControlSetText(val, "Edit3")
        case "Args":     ControlSetText(val, "Edit4")
        case "Extract":  ControlSetText(val, "Edit5")
        case "Archive":  ControlSetText(val, "Edit6")
        case "Ext":      ControlSetText(val, "Edit7")
    }
}

UpdateOutput(*) {
    prep := ControlGetText("Edit1")
    seven := ControlGetText("Edit2")
    emu := ControlGetText("Edit3")
    args := ControlGetText("Edit4")
    extract := ControlGetText("Edit5")
    arc := ControlGetText("Edit6")
    ext := ControlGetText("Edit7")
    keep := ControlGet("Keep").Value
    if (prep = "" || seven = "" || emu = "" || extract = "" || arc = "" || ext = "") {
        outputEdit.Value := ""
        return
    }
    keepFlag := keep ? " -KeepExtracted" : ""
    ; Build quoted command
    cmd := 'powershell -ExecutionPolicy Bypass -File "' prep '" ' _
        + '"' seven '" "' emu '" ' _
        + '"' args '" ' _
        + '"' extract '" ' _
        + '"' arc '" ' _
        + '"' ext '"' _
        + keepFlag
    outputEdit.Value := cmd
}
