#Warn
#SingleInstance
#NoEnv

; Initialise variables
Youtube := ""
Spotify := ""

Gui, Add, GroupBox, x22 y340 w430 h90 vMyGroupBox, Batch output
Gui, Add, Edit, ReadOnly x32 y355 w410 h70 vOutput, 

Gui, Add, GroupBox, x2 y19 w250 h30 , Youtube
Gui, Add, Edit, x2 y34 w250 h20 vYoutube gYTDLP

Gui, Add, GroupBox, x300 y19 w250 h30 , Spotify
Gui, Add, Edit, x300 y34 w250 h20 vSpotify gSpotYoutube
; Add a button to execute the command
Gui, Add, Button, x32 y435 w100 h30 gRunCmd, Run Command

Gui, Show, h480 w640, YT & Spotify Downloader
Return

; The GUI fields and buttons
YTDLP:
  GuiControlGet, Youtube
  ; Add "yt-dlp.exe" in front of the input text
  Cmd := "yt-dlp.exe --paths %userprofile%\Music -f ""bv*[height=1080]+ba/b"" --merge-output-format mp4 " . Youtube
  ; Update the GroupBox with the combined text
  GuiControl,, Output, % Cmd
return
; The GUI fields and buttons
SpotYoutube:
  GuiControlGet, Spotify
  ; Add "spotdl" in front of the input text
  Cmd := "spotdl download " Spotify " --output %userprofile%\Music --preload --sponsor-block --threads 16 "
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
