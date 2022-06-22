
Loop, Files, C:\Users\janni\Downloads\*.*, d
{
    MsgBox, 4, , Filename = %A_LoopFileFullPath%`n`nContinue?
    IfMsgBox, No
        break
    IfMsgBox, Yes
        MsgBox, %A_LoopFileFullPath%
}







