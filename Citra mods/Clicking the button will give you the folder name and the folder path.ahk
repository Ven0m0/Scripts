﻿	#SingleInstance Force
	#Warn  ; Enable warnings to assist with detecting common errors.
	#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
	SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
																				
	Buttons := {}																; Create Object for the Folder Names and Related Paths
	Loop, Files, % A_MyDocuments "\*.*", d 										; Loop the folders in your MyDocuments Folder
	{
		Buttons.Push({"Name":A_LoopFileName, "Path":A_LoopFileFullPath}) 		; Add the name and path of the current folder to the Buttons Object
	}
	
	for each, button in Buttons {												; Move through the Buttons object, one button at a time
		Buttonhwnd := RegExReplace(button.Name, "[^A-Z0-9]") 					; Sanitising the button name for use as a Hwnd 
		Gui, Add, Button, % "+HWNDh" Buttonhwnd, % "Apply " button.Name " mod." ; Adding the button to the GUI, with the Hwnd as an option
		ControlHandler := Func("FileActions").Bind(button)						; Create Link from the button to the function we want
		GuiControl +g, % h%Buttonhwnd%, % ControlHandler 						; Update the button control to call the ControlHandler
	}
	
	Gui, Show																	; Show the GUI with the folders as Buttons
	
	FileActions(Button){
		MsgBox % "Button: " Button.Name "`nPath: " Button.Path
	}