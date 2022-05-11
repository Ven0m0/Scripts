; Admin check
 if not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"
   ExitApp
}

#SingleInstance Force
; #Warn  ; Enable warnings to assist with detecting common errors.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
DetectHiddenWindows, On

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetTitleMatchMode, 3
SetTitleMatchMode, Fast
SetNumlockState, AlwaysOn
SetCapsLockState, AlwaysOff
SetScrollLockState, AlwaysOff

; Rechner always on top
Loop
{
WinWaitActive, Rechner
WinSet, AlwaysOnTop, On, Rechner
WinWaitNotActive, Rechner
}

; Calculator always on top
Loop
{
WinWaitActive, Calculator
WinSet, AlwaysOnTop, On, Calculator
WinWaitNotActive, Calculator
}

; Bild-in-Bild always on top
Loop
{
WinWaitActive, Bild-in-Bild
WinSet, AlwaysOnTop, On, Bild-in-Bild
WinWaitNotActive, Bild-in-Bild
}

; Picture-in-Picture always on top
Loop
{
WinWaitActive, Picture-in-Picture
WinSet, AlwaysOnTop, On, Picture-in-Picture
WinWaitNotActive, Picture-in-Picture
}
Return

; Execute last copied clipboard text as admin in cmd with App key
AppsKey::
    ClipWait
    Run *RunAs cmd.exe
    WinWait, ahk_exe cmd.exe
    WinActivate, ahk_exe cmd.exe
    Send {Blind}{Text}%clipboard%
    Send {Enter}
return

; Google for last copied clipboard text with Right Control key
RCtrl::
    ClipWait  ; Wait for the clipboard to contain text.
    run, https://www.google.de/search?q=%clipboard%
return

; SHift + F1 Minimizes the active window
+F1::
    WinGet, active_id, ID, A
    WinMinimize, ahk_id %active_id%
Return

;Volume mixer, Shift + f2 opens
#MaxThreadsPerHotkey 2
+F2::Run SndVol.exe

; Empties the clipboard and recycle bin, Shift + F3 
+F3::
    FileRecycleEmpty
    clipboard := ""   ; Empty the clipboard.
Return

;Volume control, Alt+Scroll wheel (and Mbutton)
!WheelUp::Volume_Up
!WheelDown::Volume_Down
!MButton::Volume_Mute

;Always on top, Alt+t
!t::WinSet, AlwaysOnTop, Toggle, A

; Hotstrings section
::}ahk::autohotkey

;----------------------------------------------------------------------------
; Add date to selected file, Win+j
#j::
if !Explorer_GetSelection()
   {
   msgbox,,,No files were selected,2   
   return
   }
for each,Fn in strsplit(Explorer_GetSelection(),"`n","`r")
   {
   FileGetTime, InputVar, % Fn, C
   SplitPath, % Fn,,oDir, oExt, oNNE
   FormatTime, oNow, % InputVar, yyyyyMMdd
   nFn := oDir "\" oNow "_" oNNE "." oExt
   filemove,%Fn%,%nFn% 
   }
return

Explorer_GetSelection() {
   WinGetClass, winClass, % "ahk_id" . hWnd := WinExist("A")
   if (winClass ~= "Progman|WorkerW")
      oShellFolderView := GetDesktopIShellFolderViewDual()
   else if (winClass ~= "(Cabinet|Explore)WClass") {
      for window in ComObjCreate("Shell.Application").Windows
         if (hWnd = window.HWND) && (oShellFolderView := window.document)
            break
   }
   else
      Return
   
   for item in oShellFolderView.SelectedItems
      result .= (result = "" ? "" : "`n") . item.path
   if !result
      result := oShellFolderView.Folder.Self.Path
   Return result
}

GetDesktopIShellFolderViewDual()
{
    IShellWindows := ComObjCreate("{9BA05972-F6A8-11CF-A442-00A0C90A8F39}")
    desktop := IShellWindows.Item(ComObj(19, 8)) ; VT_UI4, SCW_DESKTOP                
   
    ; Retrieve top-level browser object.
    if ptlb := ComObjQuery(desktop
        , "{4C96BE40-915C-11CF-99D3-00AA004AE837}"  ; SID_STopLevelBrowser
        , "{000214E2-0000-0000-C000-000000000046}") ; IID_IShellBrowser
    {
        ; IShellBrowser.QueryActiveShellView -> IShellView
        if DllCall(NumGet(NumGet(ptlb+0)+15*A_PtrSize), "ptr", ptlb, "ptr*", psv) = 0
        {
            ; Define IID_IDispatch.
            VarSetCapacity(IID_IDispatch, 16)
            NumPut(0x46000000000000C0, NumPut(0x20400, IID_IDispatch, "int64"), "int64")
           
            ; IShellView.GetItemObject -> IDispatch (object which implements IShellFolderViewDual)
            DllCall(NumGet(NumGet(psv+0)+15*A_PtrSize), "ptr", psv
                , "uint", 0, "ptr", &IID_IDispatch, "ptr*", pdisp)
           
            IShellFolderViewDual := ComObjEnwrap(pdisp)
            ObjRelease(psv)
        }
        ObjRelease(ptlb)
    }
    return IShellFolderViewDual
}
