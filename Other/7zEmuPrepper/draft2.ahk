#Warn
#NoEnv
#SingleInstance

Header:=["7zEmuPrepperPath","7ZipPath","EmulatorPath","Arguments","ExtractionPath","GamePath","Extensions"]

Gui Tab,1
Gui Add,GroupBox,x22 y340 w430 h90,Batch output
Gui Add,Edit,ReadOnly x32 y355 w410 h70 vOutput 

Gui Add,Tab,x2 y-1 w640 h481,Main
xPos:=162,yPos:=19,wPos:=150                                                                                 ;x|yPos dist from left|top, wPos is full edit width
Loop 7{                                                                                                      ;Loop through each item in Header[]
  Gui Add,GroupBox,% "x" xPos " y" (A_Index-1)*41+yPos " w" wPos " h30",% Header[A_Index]                    ;  Add GroupBoxes equal distance apart
  If !(A_Index=4 || A_Index=7){                                                                              ;  If Not Header[4 or 7] (Arg|Ext)...
    Gui Add,Edit,% "x" xPos " y" (A_Index-1)*41+yPos+20 " w" wPos-20 " h20 v" Header[A_Index] " gGuiInput"   ;    ...Create shorted edit fields...
    Gui Add,Button,% "x" xPos+wPos-20 " y" (A_Index-1)*41+yPos+20 " w20 h20 vBut" A_Index " gFolderSelect",F ;    ...and add buttons
  }Else                                                                                                 ;  Otherwise...
    Gui Add,Edit,% "x" xPos " y" (A_Index-1)*41+yPos+20 " w" wPos " h20 v" Header[A_Index] " gGuiInput"      ;    ...Add full-lenght edit fields
}
Gui Add,CheckBox,% "x" xPos " y" yPos+286 " w130 h30 vKeepExtracted gGuiInput",KeepExtracted

Gui +AlwaysOnTop
Gui Show, x127 y87 h480 w640, Game
Return
 
GuiInput:
  Gui Submit,NoHide
  KeepExtracted:=KeepExtracted?" -KeepExtracted":""
  Output= "%7zEmuPrepperPath%" "%7zipPath%" "%EmulatorPath%" "%Arguments%" "%ExtractionPath%" "%GamePath%" "%Extensions%" "%KeepExtracted%"`r`n
  GuiControl ,,Output,% RegExReplace(Output, " ?""""")
Return

FolderSelect:
  Option:=SubStr(A_GuiControl,4)                         ;Get the number of the button pressed (same as Header[] ID)
  If (Option>=1) && (Option<=3)                          ;If button is 1-3
    FileSelectFile Selected,,3,Select the file to copy   ;  Choose a file dialog
  Else                                                   ;Otherwise
    FileSelectFolder Select,,3,Select the folder to copy ;  Choose a folder dialog
  GuiControl ,,% Header[Option],% Selected               ;Both file\folder select have same options/output so this works for both
Return

GuiClose:
  ExitApp