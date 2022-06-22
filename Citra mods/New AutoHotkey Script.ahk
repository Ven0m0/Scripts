Folder = "C:\Users\janni\Downloads\New folder"
Loop, Files %Folder%, 0
    FileName := A_LoopFileName
Loop, Files, %Folder%[color=red]\..[/color], 2
    FileDir := A_LoopFileName
MsgBox %FileDir%`n%FileName%