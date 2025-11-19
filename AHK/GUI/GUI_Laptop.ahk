#Include %A_ScriptDir%\..\..\Lib\AHK_Common.ahk
InitScript(true, true)  ; UIA + Admin required

#SingleInstance Force
#Persistent
#NoEnv
#Warn
SetBatchLines -1
SetTitleMatchMode, 3
SetTitleMatchMode, Fast

Gui +AlwaysOnTop
Gui, New, -MinimizeBox, My Codes
Gui, Add, Tab2,, General|Games
Gui Add, Button, gChoiceA w80 h50 x22 y34, Open Keys
Gui Add, Button, gChoice1 w80 h50 x105 y34, Close Keys
Gui Add, Button, gChoiceB w80 h50 x22 y90, Open Host
Gui Add, Button, gChoice2 w80 h50 x105 y90, Close Host
Gui, Tab, 2
Gui Add, Button, gChoiceD w80 h50 x22 y34, Open ShellShockLive
Gui Add, Button, gChoice4 w80 h50 x105 y34, Close ShellShockLive
Gui Add, Button, gChoiceE w80 h50 x22 y90, Open Robosquare
Gui Add, Button, gChoice5 w80 h50 x105 y90, Close Robosquare
Gui Add, Button, gChoiceF w80 h50 x22 y146, Open Y8 Games
Gui Add, Button, gChoice6 w80 h50 x105 y146, Close Y8 Games

Gui, Tab
Gui, Add, Button, default xm, OK  ; xm puts it at the bottom left corner.
Gui, Show
return

ChoiceA:
    Run, "C:\Users\janni\Documents\Scripts\Keys.ahk",,, KeysPID
Return

Choice1:
    WinKill, ahk_pid %KeysPID%
Return

ChoiceB:
    Run, "C:\Users\janni\Documents\Scripts\Script Master\Host.ahk",,, HostPID
Return

Choice2:
    WinKill, ahk_pid %HostPID%
Return

ChoiceD:
   Run, C:\Program Files (x86)\Steam\steamapps\common\ShellShock Live\ShellShockLive.exe
Return

Choice4:
    WinKill, ahk_exe ShellShockLive.exe
Return

ChoiceE:
   Run, C:\Program Files (x86)\Steam\steamapps\common\RoboSquare\RoboSquare.exe
Return

Choice5:
   WinKill, ahk_exe RoboSquare.exe
Return

ChoiceF:
   Run, https://y8.com
Return

Choice6:
   IfWinExist, Y8 Games
   Winactivate, Y8 Games
   Send, ^w
Return



ButtonOK:
GuiClose:
ExitApp
