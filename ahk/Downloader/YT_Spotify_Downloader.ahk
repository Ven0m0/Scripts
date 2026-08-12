#Requires AutoHotkey v2.0
#SingleInstance Force
SendMode "Input"
SetWorkingDir A_ScriptDir

#Include %A_ScriptDir%\..\..\Lib\AHK_Common.ahk

InitScript(false, false)

; ============================================================================
; YT_Spotify_Downloader.ahk - GUI for yt-dlp / spotdl
; ============================================================================

musicDir := EnvGet("USERPROFILE") . "\Music"

ytdlpExe := MustGetExe("yt-dlp.exe", [A_ScriptDir . "\yt-dlp.exe"])
spotdlExe := MustGetExe("spotdl.exe", [A_ScriptDir . "\spotdl.exe"])

dlGui := Gui(, "YT & Spotify Downloader")

dlGui.Add("GroupBox", "x2 y19 w250 h30", "Youtube")
youtubeEdit := dlGui.Add("Edit", "x12 y34 w230 h20")
youtubeEdit.OnEvent("Change", (*) => UpdateCommand())

dlGui.Add("GroupBox", "x300 y19 w250 h30", "Spotify")
spotifyEdit := dlGui.Add("Edit", "x310 y34 w230 h20")
spotifyEdit.OnEvent("Change", (*) => UpdateCommand())

dlGui.Add("GroupBox", "x22 y340 w430 h90", "Batch output")
outputEdit := dlGui.Add("Edit", "x32 y355 w410 h70 ReadOnly")

runBtn := dlGui.Add("Button", "x32 y435 w100 h30", "Run Command")
runBtn.OnEvent("Click", RunCmd)

dlGui.OnEvent("Close", (*) => ExitApp())
dlGui.Show("h480 w640")

; Reject shell metacharacters that would enable command injection.
ValidateInput(input) {
    return !RegExMatch(input, "[&|;<>()`$^`"]")
}

UpdateCommand() {
    if (youtubeEdit.Value != "") {
        cmd := '"' . ytdlpExe . '" --paths "' . musicDir . '" -f "bv*[height=1080]+ba/b" --merge-output-format mp4 ' . youtubeEdit.Value
        outputEdit.Value := cmd
    } else if (spotifyEdit.Value != "") {
        cmd := '"' . spotdlExe . '" download ' . spotifyEdit.Value . ' --output "' . musicDir . '" --preload --sponsor-block --threads 16'
        outputEdit.Value := cmd
    }
}

RunCmd(*) {
    input := (youtubeEdit.Value != "") ? youtubeEdit.Value : spotifyEdit.Value

    if (!ValidateInput(input)) {
        MsgBox("Invalid characters detected in URL!`n`nThe following characters are not allowed:`n& | ; < > ( ) $ `` ^ `"", "Security Error", "Icon!")
        return
    }

    cmd := outputEdit.Value
    if (cmd == "")
        return

    Run(A_ComSpec . " /c " . cmd, , "Hide")
}
