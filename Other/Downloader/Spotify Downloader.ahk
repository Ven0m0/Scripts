#Warn
#SingleInstance
#NoEnv

; Initialise variables
Link := ""
; --------------------------------------------------------------------------------------------------------------------------------
Gui, Add, GroupBox, x22 y340 w430 h90 vMyGroupBox, Batch output
Gui, Add, Edit, ReadOnly x32 y355 w410 h70 vOutput, 
; 
Gui, Add, GroupBox, x2 y19 w250 h30 , Link
Gui, Add, Edit, x2 y34 w250 h20 vLink gGuiInput
;
; Add a button to execute the command
Gui, Add, Button, x32 y435 w100 h30 gRunCmd, Run Command
;
Gui, Show, h480 w640, YT Downloader
Return

; The GUI fields and buttons
GuiInput:
  GuiControlGet, Link
  ; Add "yt-dlp.exe" in front of the input text
  Cmd := "spotdl download " Link " --output %userprofile%\Music --preload --sponsor-block --threads 12 "
  ; Update the GroupBox with the combined text
  GuiControl,, Output, % Cmd
return

; Function to execute the command in cmd
RunCmd:
  GuiControlGet, Cmd, , Output
  Run, %ComSpec% /c %Cmd%,, Hide
return

GuiClose:
ExitApp
