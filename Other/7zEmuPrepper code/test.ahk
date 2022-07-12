#Warn
#SingleInstance
#NoEnv
 
; Initialise variables
7zEmuPrepperPath :=""
7zipPath :=""
EmulatorPath :=""
Arguments :=""
ExtractionPath :=""
GamePath :=""
Extensions :=""
KeepExtracted :=""
; --------------------------------------------------------------------------------------------------------------------------------
Gui, Add, GroupBox, x22 y340 w430 h90 , Batch output
Gui, Add, Edit, ReadOnly x32 y355 w410 h70 vOutput, 
; 
Gui, Add, GroupBox, x162 y19 w150 h30 , 7zEmuPrepperPath
Gui, Add, Edit, x162 y39 w130 h20 v7zEmuPrepperPath gGuiInput    ;Shrunk width by 20px
Gui, Add, Button, x292 y39 w20 h20 g7zEmuPrepperPath,F           ;Added button into above space; see below for button code
;
Gui, Add, GroupBox, x162 y60 w150 h30 , 7ZipPath
Gui, Add, Edit, x162 y80 w150 h20 v7ZipPath gGuiInput 
;
Gui, Add, GroupBox, x162 y101 w150 h30 , EmulatorPath
Gui, Add, Edit, x162 y121 w150 h20 vEmulatorPath gGuiInput 
;
Gui, Add, GroupBox, x162 y142 w150 h30 , Arguments
Gui, Add, Edit, x162 y162 w150 h20 vArguments gGuiInput 
;
Gui, Add, GroupBox, x162 y183 w150 h30 , ExtractionPath
Gui, Add, Edit, x162 y203 w150 h20 vExtractionPath gGuiInput 
;
Gui, Add, GroupBox, x162 y224 w150 h30 , GamePath
Gui, Add, Edit, x162 y244 w150 h20 vGamePath gGuiInput 
;
Gui, Add, GroupBox, x162 y265 w150 h30 , Extensions
Gui, Add, Edit, x162 y285 w150 h20 vExtensions gGuiInput
;
Gui, Add, CheckBox, x162 y305 w130 h30 vKeepExtracted gGuiInput , KeepExtracted
;
Gui, Show, h480 w640, Game
Return
 
;The GUI fields and buttons
GuiInput:
  GuiControlGet 7zEmuPrepperPath
  GuiControlGet 7zipPath
  GuiControlGet EmulatorPath
  GuiControlGet Arguments
  GuiControlGet ExtractionPath
  GuiControlGet GamePath
  GuiControlGet Extensions
  GuiControlGet KeepExtracted
 
if KeepExtracted = 1
    KeepExtracted =" -KeepExtracted"
if KeepExtracted = 0
    KeepExtracted :=""

GuiControl, , % "Output", % " """ 7zEmuPrepperPath """ """ 7zipPath """ """ EmulatorPath """ """ Arguments """ """ ExtractionPath """ """ GamePath """ """ Extensions """ " KeepExtracted "`r`n"
return
 
GuiClose:
ExitApp

7zEmuPrepperPath:                                                ;Code for button (above)
  FileSelectFile 7zEmuPrepperPath,,3,Select the folder to copy
  GuiControl ,,7zEmuPrepperPath,% 7zEmuPrepperPath
return