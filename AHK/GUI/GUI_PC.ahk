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
Gui Add, Button, gChoiceC w80 h50 x22 y146, Open Autocorrect
Gui Add, Button, gChoice3 w80 h50 x105 y146, Close Autocorrect
Gui, Tab, 2
Gui Add, Button, gChoiceD w80 h50 x22 y34, Open Fortnite
Gui Add, Button, gChoice4 w80 h50 x105 y34, Close Fortnite
Gui Add, Button, gChoiceE w80 h50 x22 y90, Open Battlefront
Gui Add, Button, gChoice5 w80 h50 x105 y90, Close Battlefront
Gui Add, Button, gChoiceF w80 h50 x22 y146, Open The Witcher 3
Gui Add, Button, gChoice6 w80 h50 x105 y146, Close The Witcher 3
Gui, Tab, 3
Gui Add, Button, gChoiceG w80 h50 x22 y34, Open Gameboost
Gui Add, Button, gChoice7 w80 h50 x105 y34, Close Gameboost

Gui, Tab
Gui, Add, Button, default xm, OK  ; xm puts it at the bottom left corner.
Gui, Show
return

ChoiceA:
    Run "C:\Users\Jannik\OneDrive\Backup\Optimal\Scripts\AHK\Keys.ahk",,, Keys
Return

Choice1:
    WinKill, ahk_pid  %Keys%
Return

ChoiceB:
    Run "C:\Users\Jannik\OneDrive\Backup\Optimal\Scripts\AHK\Script Master\Host.ahk",,, Host
Return

Choice2:
    WinKill, ahk_pid %Host%
Return

ChoiceC:
    Run "C:\Users\janni\OneDrive\Backup\Optimal\Scripts\AHK\Autocorrect.ahk",,, Autocorrect
Return

Choice3:
    WinKill, ahk_pid %Autocorrect%
Return

ChoiceD:
   Run, "C:\Program Files\Epic Games\Fortnite\FortniteGame\Binaries\Win64\FortniteClient-Win64-Shipping.exe",,, FortnitePID
    Process, Priority, %FortnitePID%, High
Return

Choice4:
   WinKill, FortniteClient-Win64-Shipping.exe
Return

ChoiceE:
   Run "C:\Users\janni\OneDrive\Backup\Game\Steam\Battlefront 2\FrostyModManager.lnk"
   WinWait, ahk_exe starwarsbattlefrontii.exe
   WinGet, Battlefront_pid, PID, ahk_exe starwarsbattlefrontii.exe
   Process, Priority, %Battlefront_pid%, High
Return

Choice5:
   WinKill, starwarsbattlefrontii.exe
Return

ChoiceF:
   Run, "C:\Program Files (x86)\Steam\steamapps\common\The Witcher 3\bin\x64\witcher3.exe",,, WitcherPID
   Process, Priority, %WitcherPID%, High
Return

Choice6:
   WinKill, ahk_exe witcher3.exe
Return

ChoiceG:
   Run, "C:\Users\Jannik\OneDrive\Backup\Optimal\Scripts\AHK\Gameboost.ahk",,, GamePID
Return

Choice7:
   WinKill, ahk_pid  %GamePID%
Return

ButtonOK:
GuiClose:
ExitApp