; UIA check
if (!InStr(A_AhkPath, "_UIA.exe")) {
    newPath := RegExReplace(A_AhkPath, "\.exe", "U" (32 << A_Is64bitOS) "_UIA.exe")
    Run % StrReplace(DllCall("Kernel32\GetCommandLine", "Str"), A_AhkPath, newPath)
    ExitApp
}

#SingleInstance Force
#Warn ; Enable warnings to assist with detecting common errors.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetBatchLines, -1  ; Run as fast as possible.
SetWorkingDir % A_ScriptDir ; Ensures a consistent starting directory.
Menu, Tray, Tip, Citra Mod Manager
EnvGet OneDrive, ONEDRIVE
root := OneDrive "\Backup\Game\Emul\Citra\nightly-mingw\Mods"

; Read CSV once and cache destinations in an associative array
Destinations := {}
loop Read, % A_ScriptDir "\Destination.csv"
{
    if (InStr(A_LoopReadLine, ","))
    {
        parts := StrSplit(A_LoopReadLine, ",")
        if (parts.Length() >= 2)
            Destinations[parts[1]] := parts[2]
    }
}

Buttons := {}  ; Create Object for the Folder Names and Related Paths
loop, Files, % root "\*.*", D
{
    Gamename := A_LoopFileName     ; save game name
    Gamepath := A_LoopFileFullPath ; save game path
    Destination := Destinations[Gamename]  ; Look up from cached data

    loop, Files, % Gamepath "\*.*", D
    {
        Buttons.Push({"Name":A_LoopFileName, "Path":A_LoopFileFullPath, "Ziel":Destination})
    }
}

Gui, New, -MinimizeBox, Citra Mod Manager

for each,button in Buttons                                                     ; Move through the Buttons object, one button at a time
{                                                                              
        Buttonhwnd := RegExReplace(button.Name, "[^A-Z0-9]")                   ; Sanitising the button name for use as a Hwnd 
        Gui Add, Button, % "+HWNDh" Buttonhwnd, % "Apply " button.Name " mod"  ; Adding the button to the GUI, with the Hwnd as an option
        ControlHandler := Func("FileActions").Bind(root, button)               ; Create Link from the button to the function we want
        GuiControl, +g, % h%Buttonhwnd%, % ControlHandler                      ; Update the button control to call the ControlHandler
}

Gui, Show, Center, Citra Mod Manager                                                                       ; Show the GUI with the folders as Buttons


return ; End of auto-execute

FileActions(Root, Button)
{
        EnvGet, OneDriveDir, OneDrive
        Zielpfad = %OneDriveDir%\Backup\Game\Emul\Citra\nightly-mingw\user\load\mods
        Fullpath := Zielpfad "\" button.Ziel "\" button.Name
        Checkdir := Zielpfad "\" button.Ziel
        Quellpfad := button.Path
        vCount :=0
        Loop, Files, %Checkdir%\*, DF       ;Loop through items in dir
          vCount++                          ;Increment vCount for each item
        If !vCount                          ;Is vCount empty?
        {                         
          FileCopyDir, %Quellpfad%, %Fullpath%
          MsgBox % "Copied " button.Name
        }
        Else                                   ;Otherwise vCount is NOT empty...
          MsgBox % "Dir has " vCount " item(s). Can't copy"
}

GuiClose:
GuiEscape:

ExitApp
