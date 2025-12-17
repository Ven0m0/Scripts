#Warn
#SingleInstance
#NoEnv

; Initialise variables
Link := ""

Gui, Add, GroupBox, x22 y340 w430 h90 vMyGroupBox, Batch output
Gui, Add, Edit, ReadOnly x32 y355 w410 h70 vOutput, 

Gui, Add, GroupBox, x2 y19 w250 h30 , Link
Gui, Add, Edit, x2 y34 w250 h20 vLink gYTDLP

; Add a button to execute the command
Gui, Add, Button, x32 y435 w100 h30 gRunCmd, Run Command

Gui, Show, h480 w640, YT Downloader
Return

; The GUI fields and buttons
YTDLP:
  GuiControlGet, Link
  ; Add "yt-dlp.exe" in front of the input text
  Cmd := "yt-dlp.exe --paths %userprofile%\Music -f ""bv*[height=1080]+ba/b"" --merge-output-format mp4 " . Link
  ; Update the GroupBox with the combined text
  GuiControl,, Output, % Cmd
return

; Function to validate input for command injection
ValidateInput(input) {
    ; Check for dangerous characters that could enable command injection
    ; Dangerous: & | ; < > ( ) $ ` ^ "
    if RegExMatch(input, "[&|;<>()`$^""]") {
        return false
    }
    return true
}

; Function to execute the command in cmd
RunCmd:
  GuiControlGet, Link

  ; Validate input before executing
  if (!ValidateInput(Link)) {
      MsgBox, 16, Security Error, Invalid characters detected in URL!`n`nThe following characters are not allowed:`n& | ; < > ( ) $ `` ^ "
      return
  }

  GuiControlGet, Cmd, , Output
  Run, %ComSpec% /c %Cmd%,, Hide
return

GuiClose:
ExitApp
