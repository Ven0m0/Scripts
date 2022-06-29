; UIA check
if (!InStr(A_AhkPath, "_UIA.exe")) {
	newPath := RegExReplace(A_AhkPath, "\.exe", "U" (32 << A_Is64bitOS) "_UIA.exe")
	Run % StrReplace(DllCall("Kernel32\GetCommandLine", "Str"), A_AhkPath, newPath)
	ExitApp
}

#SingleInstance Force
#Warn ; Enable warnings to assist with detecting common errors.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetWorkingDir % A_ScriptDir ; Ensures a consistent starting directory.

EnvGet OneDrive, ONEDRIVE
root := OneDrive "\Backup\Optimal\Scripts\Other\Playnite\Citra mods\Mods 2"

Destination := ""
Buttons := {}                                                                  ; Create Object for the Folder Names and Related Paths
loop Files, % root "\*.*", D
{
        Gamename := A_LoopFileName     ; save game name
        Gamepath := A_LoopFileFullPath ; save game path
        findDest:
        loop Read, % A_ScriptDir "\Destination.txt"
        {
                if (InStr(A_LoopReadLine, Gamename))
                {
                        Destination := StrReplace(A_LoopReadLine, Gamename . "_", "")
                        break findDest
                }
        }
        loop Files, % Gamepath "\*.*", D
        {
                Buttons.Push({"Name":A_LoopFileName, "Path":A_LoopFileFullPath, "Ziel":Destination})
        }
}

for each,button in Buttons                                                     ; Move through the Buttons object, one button at a time
{                                                                              
        Buttonhwnd := RegExReplace(button.Name, "[^A-Z0-9]")                   ; Sanitising the button name for use as a Hwnd 
        Gui Add, Button, % "+HWNDh" Buttonhwnd, % "Apply " button.Name " mod"  ; Adding the button to the GUI, with the Hwnd as an option
        ControlHandler := Func("FileActions").Bind(root, button)               ; Create Link from the button to the function we want
        GuiControl, +g, % h%Buttonhwnd%, % ControlHandler                      ; Update the button control to call the ControlHandler
}

Gui Show                                                                       ; Show the GUI with the folders as Buttons

return ; End of auto-execute

FileActions(Root, Button)
{
        MsgBox % button.Name button.Ziel
}

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
