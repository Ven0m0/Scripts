; UIA check
if (!InStr(A_AhkPath, "_UIA.exe")) {
	newPath := RegExReplace(A_AhkPath, "\.exe", "U" (32 << A_Is64bitOS) "_UIA.exe")
	Run % StrReplace(DllCall("Kernel32\GetCommandLine", "Str"), A_AhkPath, newPath)
	ExitApp
}

#SingleInstance Force
#Warn  ; Enable warnings to assist with detecting common errors.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
																				
Buttons := {}																; Create Object for the Folder Names and Related Paths
Loop, Files, C:\Users\janni\OneDrive\Backup\Optimal\Scripts\Other\Playnite\Citra mods\Mods 2\*.*, d
{
	Gamename := A_LoopFileName
	Loop, Files, A_LoopFileFullPath
	{
		Buttons.Push({"Name":%Gamename%, "Path":A_LoopFileFullPath})
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
	MsgBox % "Button: " Button.Name "`nPath: " Button.Path
}