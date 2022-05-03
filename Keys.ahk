; Admin check
if not A_IsAdmin
{
Run *RunAs "%A_ScriptFullPath%"
ExitApp
}

; Great directives to have
#SingleInstance Force
#persistent
; #Warn  ; Enable warnings to assist with detecting common errors.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetBatchLines -1

; 1-time declarations
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetTitleMatchMode, 3
SetTitleMatchMode, Fast
SetNumlockState, AlwaysOn
SetCapsLockState, AlwaysOff
SetScrollLockState, AlwaysOff

Loop
{
WinSet, AlwaysOnTop, On, Rechner
WinSet, AlwaysOnTop, On, Calculator
WinSet, AlwaysOnTop, On, Bild-in-Bild
WinSet, AlwaysOnTop, On, Picture-in-Picture
}

;----------------------------------------------------------------------------
; Google for last copied clipboard text with Shift + F4
+F4::
    ClipWait  ; Wait for the clipboard to contain text.
    Run, https://www.google.de/search?q=%clipboard%
return

;----------------------------------------------------------------------------
; Execute last copied clipboard text as admin in cmd with Shift + F6
+F6::
    ClipWait
    Run *RunAs cmd.exe
    WinActivate, ahk_exe cmd.exe
    WinWaitActive, ahk_exe cmd.exe
    Send {Blind}{Text}%clipboard%
    Send {Enter}
return

;----------------------------------------------------------------------------
; Shift + F1 Minimizes the active window
+F1::
    WinGet, active_id, ID, A
    WinMinimize, ahk_id %active_id%
Return

;----------------------------------------------------------------------------
;Volume mixer, Shift + F2 opens it
+F2::Run SndVol.exe
		
;----------------------------------------------------------------------------
; Empties the clipboard and recycle bin, Shift + F3 
+F3::
    FileRecycleEmpty
    clipboard := ""   ; Empty the clipboard.
Return

;----------------------------------------------------------------------------
; Open GUI Shift + F7
+F7::Run, "C:\Users\janni\Documents\Scripts\GUI_Laptop.ahk"

;----------------------------------------------------------------------------
*PgDn::
Send jannik.joergensen15@gmail.com
Return

;----------------------------------------------------------------------------
*PgUp::
Send jannik.joergensen0@gmail.com
Return

;----------------------------------------------------------------------------
*End::
Send jannik.joergensen@outlook.de
Return

;----------------------------------------------------------------------------
*NumpadEnter::
Send Hermes01
Return

;----------------------------------------------------------------------------
;AutoCorrect 

::}ahk::autohotkey

;----------------------------------------------------------------------------
;Volume control, Alt+Scroll wheel (and Mbutton)
*!WheelUp::Volume_Up
*!WheelDown::Volume_Down
*!MButton::Volume_Mute
;----------------------------------------------------------------------------
;Fullscreen Single Key, F12
*F12::
{
KeyWait, F12
KeyWait, F12, D T.1
If (!ErrorLevel)
{
goto, double
}
Else
goto, single
}
return

single:
{
WinSet, AlwaysOnTop, On, A ; Focus
WinSet, Style, -0xC00000, A ; hide title bar
WinSet, Style, -0x800000, A ; hide thin-line border
WinSet, Style, -0x400000, A ; hide dialog frame
WinSet, Style, -0x40000, A ; hide thickframe/sizebox
WinMove, A, , 0, 0, 1920, 1080
}
return

double:
{
WinSet, AlwaysOnTop, Off, A ; Focus
WinSet, Style, +0xC00000, A ; show title bar
WinSet, Style, +0x800000, A ; show thin-line border
WinSet, Style, +0x400000, A ; show dialog frame
WinSet, Style, +0x40000, A ; show thickframe/sizebox
WinMove, A, , 0, 0, 1280, 720
}
return
;----------------------------------------------------------------------------
;Always on top, Alt+t
*!t::WinSet, AlwaysOnTop, Toggle, A

;----------------------------------------------------------------------------
; Reload script, Alt+r
*!r::Reload

;----------------------------------------------------------------------------
; F10, hide all games
*F10::
GroupAdd, Emergency, ahk_exe RoboSquare.exe
GroupAdd, Emergency, ahk_exe ShellShockLive.exe
GroupAdd, Emergency, ahk_exe steam.exe
GroupAdd, Emergency, ahk_exe parsecd.exe
SetTitleMatchMode, 2
GroupAdd, Emergency, Play online at Y8.com
WinMinimize, ahk_group Emergency
Return

;----------------------------------------------------------------------------
; Add date to selected file, Win+j
*#j::
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
; ----------------------------------------------------------------------------