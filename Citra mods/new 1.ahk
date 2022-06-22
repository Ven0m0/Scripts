Dir = %A_ScriptDir%\ahkTest
FileCreateDir, %Dir%
MsgBox % IsEmpty(Dir)
FileAppend, , %Dir%\a.txt
Sleep 1000
MsgBox % IsEmpty(Dir)

IsEmpty(Dir){
   Loop %Dir%\*.*, 0, 1
      return 0
   return 1
}