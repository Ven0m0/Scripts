; UIA check
if !InStr(A_AhkPath, "_UIA.exe") {
    Run, % A_AhkPath . " U" (32 << A_Is64bitOS) "_UIA.exe"
    ExitApp
}

#SingleInstance, Force
#NoEnv
#KeyHistory 0 
#Warn
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
DetectHiddenText, Off
DetectHiddenWindows, Off
ListLines Off
SetBatchLines, 10ms
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1
SetControlDelay, -1
SendMode Input
SetTitleMatchMode, 3
SetTitleMatchMode, Fast
SetNumlockState, AlwaysOn
SetCapsLockState, AlwaysOff
SetScrollLockState, AlwaysOff
Menu, Tray, Add, Documentation, Item1

; GLobal Variables for window snapping
mw := GetMonitorWidth()             ; Monitor width
mh := GetMonitorHeight()            ; Monitor height
pw := mw / 3                        ; 1 / 3 of monitor width
ph := mh / 3                        ; 1 / 3 of monitor height
lw := 2 * pw > 1024 ? 1024: 2 * pw  ; Left side width (1024 is preffered)
rw := mw - lw                       ; Right side width
th := round(2 * ph)                 ; Top side height
bh := ceil(ph)                      ; Bottom side height
positions := {}                     ; Saves Window position before snapping

; Set windows on top
SetTimer, SetAlwaysOnTop, 1000
Return
	SetAlwaysOnTop(){
		WinSet, AlwaysOnTop, On, Calculator
	}

; Shift + F1 Minimizes the active window
#IfWinNotActive ahk_exe Explorer.EXE
$*+F1::WinMinimize,A
#IfWinNotActive

; Empties the clipboard and recycle bin, Shift + F2
$*+F2::
FileRecycleEmpty
clipboard := ""   ; Empty the clipboard.
Return

;Media control, Alt+Scroll wheel (and Mbutton)
$*!WheelUp::Media_Next
$*!WheelDown::Media_Prev
$*!MButton::Media_Play_Pause
$*F24::Media_Play_Pause

;Always on top, Alt+t
$*!t::WinSet, AlwaysOnTop, Toggle, A

;----------------------------------------------------------------------------
; Add date to selected file, Win+j
$*#j::
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
   
   result := ""
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

; Window Snapping to left and right
#Left::MoveWindowLeft()
#Right::MoveWindowRight()
#Down::RestoreWindowPosition()

SaveWindowPosition() {
    global positions
    hwnd := WinExist("A")
    WinGetPos, x, y, w, h, A
    positions[hwnd] := [x, y, w, h]
}

RestoreWindowPosition() {
    global positions
    hwnd := WinExist("A")
    pos := positions[hwnd]
    WinMove, A, , pos[1], pos[2], pos[3], pos[4]
}

MoveWindowLeft() {
    global
    SaveWindowPosition()
    if (IsResizable()) {
        WinMove, A,, 0, 0, lw, mh
    } else {
        WinMove, A,, 0, 0
    }
}

MoveWindowRight() {
    global
    SaveWindowPosition()
    if (IsResizable()) {
        WinMove, A,, lw, 0, rw, mh
    } else {
        WinMove, A,, lw, 0
    }
}

; Helper functions
GetMonitorWidth() {
    SysGet, mon, MonitorWorkArea
    return monRight - monLeft
}

GetMonitorHeight() {
    SysGet, mon, MonitorWorkArea
    return monBottom - monTop
}

IsResizable() {
    WinGet, Style, Style, A
    return (Style & 0x40000) ; WS_SIZEBOX
}

Item1:
Gui +AlwaysOnTop
Gui, Add, Tab3,, Hotkeys|Functions|Links
Gui, Add, Text,, Shift + F1 Minimizes the active window.
Gui, Add, Text,, Shift + F2 Empties the clipboard and recycle bin
Gui, Add, Text,, Alt + Mousewheel Gives media control
Gui, Add, Text,, Alt + T Sets the active window on top.
Gui, Add, Text,, End makes the active window fullscreen.
Gui, Add, Text,, Win + J adds the creation date to the selected file.
Gui, Add, Text,, Win + Left snaps the active window to the left.
Gui, Add, Text,, Win + Right snaps the active window to the right.
Gui, Add, Text,, Win + Down Restores the active window to the position before the snapping.
Gui, Tab, 2
Gui, Add, Text,, The script sets the calculator to always on top.
Gui, Tab, 3
Gui, Add, Button, gTLink, LinkTree
Gui, Add, Button, gGLink, Github
Gui, Add, Button, gYLink, Youtube
Gui, Add, Text, x25 y125, Email:
Gui, Add, Edit, x55 y120 ReadOnly, ven0m0.wastaken@gmail.com
Gui, Tab
Gui, Show, Center, Documentation
return

TLink:
Run, https://linktr.ee/Ven0m0
return

GLink:
Run, https://github.com/Ven0m0
return

YLink:
Run, https://www.youtube.com/@ven0m017
return
