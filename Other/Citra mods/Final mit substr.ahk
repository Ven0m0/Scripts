; UIA check
if (!InStr(A_AhkPath, "_UIA.exe")) {
	newPath := RegExReplace(A_AhkPath, "\.exe", "U" (32 << A_Is64bitOS) "_UIA.exe")
	Run % StrReplace(DllCall("Kernel32\GetCommandLine", "Str"), A_AhkPath, newPath)
	ExitApp
}

#SingleInstance Force
#Warn  ; Enable warnings to assist with detecting common errors.
; #NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; EnvGet OneDrive, ONEDRIVE

HasFolder(Root, Subfolder)
{
	Root := RTrim(Root, "\")
	if (!FileExist(Root)) {
		ErrorLevel := -1
		return
	}
	Subfolder := RTrim(Subfolder, "\")
	attributes := FileExist(Root "\" Subfolder)
	hasFolder := !!InStr(attributes, "D")
	ErrorLevel := !hasFolder
	return hasFolder
}

Buttons := {}																; Create Object for the Folder Names and Related Paths
Loop, Files, C:\Users\janni\OneDrive\Backup\Optimal\Scripts\Other\Playnite\Citra mods\Mods 2\*.*, d
{
	Gamename := A_LoopFileName ; save game name
	Gamepath := A_LoopFileFullPath ; save game path
    Loop, Read, %A_ScriptDir%\Destination.txt
	{
		MsgBox, Dateizeile pruefen: A_LoopReadLine spielname: %Gamename%
		FoundPos := InStr(A_LoopReadLine, %Gamename%)
		NewStr := SubStr(%Gamename%, FoundPos, 16)
		MsgBox, NewStr
        {
			MsgBox, yes
			Destination :=StrReplace(A_LoopReadLine, %Gamename%, "")
		}
	}
	Loop, Files, %Gamepath%\*.*, d
	{
		Buttons.Push({"Name":A_LoopFileName, "Path":A_LoopFileFullPath})
	}
}

for each, button in Buttons {												; Move through the Buttons object, one button at a time
	Buttonhwnd := RegExReplace(button.Name, "[^A-Z0-9]") 					; Sanitising the button name for use as a Hwnd 
	Gui, Add, Button, % "+HWNDh" Buttonhwnd, % "Apply " button.Name " mod"  ; Adding the button to the GUI, with the Hwnd as an option
	ControlHandler := Func("FileActions").Bind(button)						; Create Link from the button to the function we want
	GuiControl +g, % h%Buttonhwnd%, % ControlHandler 						; Update the button control to call the ControlHandler
}

Gui, Show																	; Show the GUI with the folders as Buttons

FileActions(Button){
if (HasFolder("C:\Users\janni\OneDrive\Backup\Optimal\Scripts\Other\Playnite\Citra mods\Mods 2\3d Land", "Kaizo Mario 3D Land"))
	MsgBox, Kaizo Mario 3D Land ist da
if (HasFolder("C:\Users\janni\OneDrive\Backup\Optimal\Scripts\Other\Playnite\Citra mods\Mods 2\3d Land", "Super Mario 3d Land Expedition"))
MsgBox, Super Mario 3d Land Expedition ist da
if (HasFolder("C:\Users\janni\OneDrive\Backup\Optimal\Scripts\Other\Playnite\Citra mods\Mods 2\NSMB", "NSMBNext The Lost Levels"))
	MsgBox, NSMBNext The Lost Levels ist da
}