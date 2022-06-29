EnvGet OneDrive, ONEDRIVE
Zielpfad := OneDrive "\Backup\Game\Emul\Citra\canary-mingw\user\load\mods"

SetBatchLines, -1  ; Make the operation run at maximum speed.
FolderSize := 0
Loop, %Zielpfad%\*.*, , 1
    FolderSize += A_LoopFileSize
MsgBox Size of %Zielpfad% is %FolderSize% bytes.
if (A_LoopFileSize := 0)
    MsgBox if Size is 0 


vCount:=0
Loop Files,C:\DirToCheck\*,DF          ;Loop through items in dir
  vCount++                             ;Increment vCount for each item
If !vCount                             ;Is vCount empty?
  MsgBox % "Nothing there!"            ;  Say it's empty
Else                                   ;Otherwise vCount is NOT empty...
  MsgBox % "Dir has " vCount " items." ;  ...