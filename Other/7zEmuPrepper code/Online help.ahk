#Warn
#NoEnv
#SingleInstance

Header:=["7zEmuPrepperPath","7ZipPath","EmulatorPath","Arguments","ExtractionPath","GamePath","Extensions"]

Gui Add,GroupBox,x22 y340 w430 h90,Batch output
Gui Add,Edit,ReadOnly x32 y355 w410 h70 vOutput 

Loop 3
  Gui Add,Button,% "x2 y" (A_Index-1)*30+19 " w120 h30",% "Skylanders " ((A_Index=1)?"SwapForce":(A_Index=2)?"TrapTeam":"Imaginators")
Loop 7{
  Gui Add,GroupBox,% "x162 y" (A_Index-1)*41+19 " w150 h30",% Header[A_Index]
  Gui Add,Edit,% "x162 y" (A_Index-1)*41+39 " w130 h20 v" Header[A_Index] " gGuiInput"
  Gui Add,Button,% "x292 y" (A_Index-1)*41+39 " w20 h20 vBut" A_Index " gFolderSelect",F
}
Gui Add,CheckBox,x162 y305 w130 h30 vKeepExtracted gGuiInput,KeepExtracted

Gui, Show, h480 w640, Game
Return
 
GuiInput:
  Gui Submit,NoHide
  KeepExtracted:=KeepExtracted?" -KeepExtracted":""
  GuiControl ,,Output,"%7zEmuPrepperPath%" "%7zipPath%" "%EmulatorPath%" "%Arguments%" "%ExtractionPath%" "%GamePath%" "%Extensions%" "%KeepExtracted%"`r`n
Return

FolderSelect:
  FileSelectFolder Folder,,3,Select the folder to copy
  GuiControl ,,% Header[SubStr(A_GuiControl,4)],% Folder
Return

GuiClose:
  ExitApp