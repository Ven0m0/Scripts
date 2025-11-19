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
Gui, Add, GroupBox, x2 y19 w150 h30 , 7zEmuPrepperPath
Gui, Add, Edit, x2 y34 w130 h20 v7zEmuPrepperPath gGuiInput    ;Shrunk width by 20px
Gui, Add, Button, x132 y34 w20 h20 g7zEmuPrepperPath, F           ;Added button into above space. see below for button code
;
Gui, Add, GroupBox, x2 y60 w150 h30 , 7ZipPath
Gui, Add, Edit, x2 y75 w130 h20 v7ZipPath gGuiInput
Gui, Add, Button, x132 y75 w20 h20 g7ZipPath, F
;
Gui, Add, GroupBox, x2 y101 w150 h30 , EmulatorPath
Gui, Add, Edit, x2 y116 w130 h20 vEmulatorPath gGuiInput
Gui, Add, Button, x132 y116 w20 h20 gEmulatorPath , F 
;
Gui, Add, GroupBox, x2 y142 w150 h30 , Arguments
Gui, Add, Edit, x2 y157 w130 h20 vArguments gGuiInput
;
Gui, Add, GroupBox, x2 y183 w150 h30 , ExtractionPath
Gui, Add, Edit, x2 y198 w130 h20 vExtractionPath gGuiInput 
Gui, Add, Button, x132 y198 w20 h20 gExtractionPath, F
;
Gui, Add, GroupBox, x2 y224 w150 h30 , GamePath
Gui, Add, Edit, x2 y239 w130 h20 vGamePath gGuiInput
Gui, Add, Button, x132 y239 w20 h20 gGamePath, F
;
Gui, Add, GroupBox, x2 y265 w150 h30 , Extensions
Gui, Add, Edit, x2 y280 w130 h20 vExtensions gGuiInput
;
Gui, Add, CheckBox, x2 y305 w130 h30 vKeepExtracted gGuiInput , KeepExtracted
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

; Code for buttons
7zEmuPrepperPath:
  FileSelectFile, 7zEmuPrepperPath,,3,Select the folder to copy
  GuiControl,,7zEmuPrepperPath,% 7zEmuPrepperPath
return

7zipPath:
  FileSelectFile, 7zipPath,,3,Select the folder to copy
  GuiControl,,7zipPath,% 7zipPath
return

EmulatorPath:
  FileSelectFile, EmulatorPath,,3,Select the folder to copy
  GuiControl,,EmulatorPath,% EmulatorPath
return

ExtractionPath:
  FileSelectFolder, ExtractionPath,,3,Select the folder to copy
  GuiControl,,ExtractionPath,% ExtractionPath
return

GamePath:
  FileSelectFile, GamePath,,3,Select the folder to copy
  GuiControl,,GamePath,% GamePath
return