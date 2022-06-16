#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;Set predetermined variables here
robocopy :="robocopy"
Source :=""
Dest :=""
FileCards :=""
SubDir :=""
RestartMode :=""
CopyAll :=""
Mirror :=""
FileCards :=""

;Everything GUI
;##############################################################
;Shown on all tabs
Gui, Add, GroupBox, x22 y290 w430 h90 , Batch output
Gui, Add, Edit, ReadOnly x32 y305 w410 h70 vOutput, 
Gui, Add, Button, gSetRunScript x22 y380 w100 h30 , Run Script
Gui, Add, Button, gSetGenerateFile x352 y380 w100 h30 , Generate
;Tabs Properties
Gui, Add, Tab2, x12 y9 w450 h280 , Path|Options|Advanced|Help
;Path tab
Gui, Add, GroupBox, x22 y39 w430 h50 , Source
Gui, Add, Edit, x32 y59 w410 h20 vSource gGuiInput 
Gui, Add, GroupBox, x22 y99 w430 h50 , Destination
Gui, Add, GroupBox, x22 y159 w430 h50 , File(s) and Wildcard(s)
Gui, Add, Edit, x32 y119 w410 h20 vDest gGuiInput 
Gui, Add, Edit, ReadOnly x32 y179 w410 h20 vFileCards gGuiInput, Not yet implemented
Gui, Add, CheckBox, x32 y233 w100 h40 , Create logfile
Gui, Add, Edit, ReadOnly x133 y243 w290 h20 , Not yet implemented
Gui, Add, GroupBox, x22 y219 w430 h60 , Logging
;Options Tab
Gui, Tab, Options
Gui, Add, GroupBox, x32 y49 w150 h180 , Group 1
Gui, Add, GroupBox, x192 y49 w250 h140 , Group 2
Gui, Add, CheckBox, x42 y69 w130 h30 vSubDir gGuiInput , Subdirectories
Gui, Add, CheckBox, x42 y109 w130 h30 vRestartMode gGuiInput , Restartable mode
Gui, Add, CheckBox, x42 y149 w130 h30 vCopyAll gGuiInput , Copy all file information
Gui, Add, CheckBox, x42 y189 w130 h30 vMirror gGuiInput , Mirror
Gui, Add, GroupBox, x202 y69 w230 h50 , Restart amount
Gui, Add, GroupBox, x202 y129 w230 h50 , Wait amount
Gui, Add, Edit, ReadOnly x212 y149 w210 h20 , Not yet implemented
Gui, Add, Edit, ReadOnly x212 y89 w210 h20 , Not yet implemented
;Output Tab
Gui, Tab, Advanced
Gui, Add, Text, x32 y59, Sorry, there is nothing here for you yet!
;Help Tab
Gui, Tab, Help
Gui, Add, GroupBox, x22 y39 w430 h230 , About
Gui, Add, Link, x32 y59, Check the <a href="https://github.com/Pyrree/Robocopy-generator">GitHub page</a>
;Other
Gui, Show, w479 h430, Robocopy Generator v0.3.0
OnMessage(0x200, "Help")
return

Help(wParam, lParam, Msg) {

MouseGetPos,,,, CheckboxHelperVar

If CheckboxHelperVar = Button11
{
	Help := "Copy Subdirectories, but not empty ones"
}

If CheckboxHelperVar = Button12
{
	Help := "Use restartable mode; if access denied use Backup mode"
}

If CheckboxHelperVar = Button13
{
	Help := "Copy ALL file info (equivalent to /COPY:DATSOU)"
}

If CheckboxHelperVar = Button14
{
	Help := "Mirror a directory tree (equivalent to /E plus /PURGE)"
}

ToolTip % Help
}

;The GUI fields and buttons
;##############################################################
GuiInput:
GuiControlGet, Source
GuiControlGet, Dest
;GuiControlGet, FileCards
GuiControlGet, SubDir
GuiControlGet, RestartMode
GuiControlGet, CopyAll
GuiControlGet, Mirror

if SubDir = 1
	SubDir :=" /S"
if Subdir = 0
	SubDir :=""

if RestartMode = 1
	RestartMode :=" /ZB"
if RestartMode = 0
	RestartMode :=""

if CopyAll = 1
	CopyAll :=" /COPYALL"
if CopyAll = 0
	CopyAll :=""

if Mirror = 1
	Mirror :=" /MIR"
if Mirror = 0
	Mirror :=""

GuiControl, , % "Output", %  robocopy " """ Source """ """ Dest """ " SubDir RestartMode CopyAll Mirror "`r`n"
return


;Run and Generate batch file
;##############################################################
SetRunScript:
RunScript :=True
goto, CreateScript

SetGenerateFile:
GenerateFile :=True
goto, CreateScript

CreateScript:
if (Source == "" && Dest == "")
    MsgBox, % "Source and Destination is empty, please choose a folder"
else if (Source = "")
    MsgBox, % "Source is empty, please choose a folder"
else if (Dest = "")
    MsgBox, % "Destination is empty, please choose a folder"
else
if FileExist(A_ScriptDir "\batch-temp.bat")
	MsgBox, 4, Error,
(
Error saving file as:
%A_ScriptDir%\Batch-temp.bat

Batch file with that name already exists,
Would you like to replace it?
)
	IfMsgBox Yes
		{
			FileDelete, %A_ScriptDir%\Batch-temp.bat
		}
	else
		return

FileAppend,
(
robocopy "%Source%" "%Dest%" %FileCards%%SubDir%%RestartMode%%CopyAll%%Mirror%

pause
exit
), %A_ScriptDir%\Batch-temp.bat

if (RunScript = True)
{
	MsgBox, 4, Caution!,
(
This is the missclick security guard!
Are you sure you would like to run this script?!

From: "%Source%"

To: "%Dest%"

Options: %FileCards%%SubDir%%RestartMode%%CopyAll%%Mirror%
)
IfMsgBox Yes
	{
		run, %A_ScriptDir%\Batch-temp.bat
	}
else
return
}
else if (GenerateFile = True)
{
	MsgBox, 4, Beep-Boop Batch file complete!, 
(
Successfully generated file "Batch-temp.bat".

Location:
%A_ScriptDir%\Batch-temp.bat

Would you like to open the folder?
)
IfMsgBox Yes
	{
		Run, %A_ScriptDir%\
	}
else
Return
}

GuiClose:
ExitApp
