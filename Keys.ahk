; UIA check
if (!InStr(A_AhkPath, "_UIA.exe")) {
	newPath := RegExReplace(A_AhkPath, "\.exe", "U" (32 << A_Is64bitOS) "_UIA.exe")
	Run % StrReplace(DllCall("Kernel32\GetCommandLine", "Str"), A_AhkPath, newPath)
	ExitApp
}

#SingleInstance Force
#Warn  ; Enable warnings to assist with detecting common errors.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
DetectHiddenWindows, On
#KeyHistory 0 
ListLines Off ; ListLines and #KeyHistory are functions used to "log your keys". Disable them as they're only useful for debugging purposes.
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0 ; Even though SendInput ignores SetKeyDelay, SetMouseDelay and SetDefaultMouseSpeed, having these delays at -1 improves SendEvent's speed just in case SendInput is not available and falls back to SendEvent.
SetWinDelay, -1
SetControlDelay, -1 ; SetWinDelay and SetControlDelay may affect performance depending on the script.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetTitleMatchMode, 3 ; Use SetTitleMatchMode 2 when you want to use wintitle that contains text anywhere in the title
SetTitleMatchMode, Fast
SetNumlockState, AlwaysOn
SetCapsLockState, AlwaysOff
SetScrollLockState, AlwaysOff
Menu, Tray, Tip, Keys
Menu, Tray, Add
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
	Exit
		SetAlwaysOnTop(){
			WinSet, AlwaysOnTop, On, Rechner
			WinSet, AlwaysOnTop, On, Calculator
			WinSet, AlwaysOnTop, On, Bild-in-Bild
			WinSet, AlwaysOnTop, On, Picture-in-Picture
		}

; Execute last copied clipboard text as admin in cmd with App key
$*AppsKey::
ClipWait
Run *RunAs cmd.exe
WinWait, ahk_exe cmd.exe
WinActivate, ahk_exe cmd.exe
Send {Blind}{Text}%clipboard%
Send {Enter}
return

; Google for last copied clipboard text with Right Control key
$*RCtrl::
ClipWait  ; Wait for the clipboard to contain text.
run, https://www.google.de/search?q=%clipboard%
return

; SHift + F1 Minimizes the active window
#IfWinNotActive ahk_class WorkerW
$*+F1::WinMinimize,A
#IfWinNotActive

;Volume mixer, Shift + f2 opens
$*+F2::Run SndVol.exe

; Empties the clipboard and recycle bin, Shift + F3 
$*+F3::
FileRecycleEmpty
clipboard := ""   ; Empty the clipboard.
Return

;Volume control, Alt+Scroll wheel (and Mbutton)
$*!WheelUp::Volume_Up
$*!WheelDown::Volume_Down
$*!MButton::Volume_Mute

;Always on top, Alt+t
$*!t::WinSet, AlwaysOnTop, Toggle, A

; Fullscreen Single Key
ToggleFakeFullscreen()
{
CoordMode Screen, Window
static WINDOW_STYLE_UNDECORATED := -0xC40000
static savedInfo := Object() ;; Associative array!
WinGet, id, ID, A
if (savedInfo[id])
{
inf := savedInfo[id]
WinSet, Style, % inf["style"], ahk_id %id%
WinMove, ahk_id %id%,, % inf["x"], % inf["y"], % inf["width"], % inf["height"]
savedInfo[id] := ""
}
else
{
savedInfo[id] := inf := Object()
WinGet, ltmp, Style, A
inf["style"] := ltmp
WinGetPos, ltmpX, ltmpY, ltmpWidth, ltmpHeight, ahk_id %id%
inf["x"] := ltmpX
inf["y"] := ltmpY
inf["width"] := ltmpWidth
inf["height"] := ltmpHeight
WinSet, Style, %WINDOW_STYLE_UNDECORATED%, ahk_id %id%
mon := GetMonitorActiveWindow()
SysGet, mon, Monitor, %mon%
WinMove, A,, %monLeft%, %monTop%, % monRight-monLeft, % monBottom-monTop
}
}

GetMonitorAtPos(x,y)
{
;; Monitor number at position x,y or -1 if x,y outside monitors.
SysGet monitorCount, MonitorCount
i := 0
while(i < monitorCount)
{
SysGet area, Monitor, %i%
if ( areaLeft <= x && x <= areaRight && areaTop <= y && y <= areaBottom )
{
return i
}
i := i+1
}
return -1
}

GetMonitorActiveWindow(){
;; Get Monitor number at the center position of the Active window.
WinGetPos x,y,width,height, A
return GetMonitorAtPos(x+width/2, y+height/2)
}

$*End::ToggleFakeFullscreen()

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
Gui, New, -MinimizeBox, Documentation
Gui, Add, Tab3,, Hotkeys|Functions|Links
Gui, Add, Text,, Shift + F1 Minimizes the active window.
Gui, Add, Text,, Shift + F2 Opens the volume mixer.
Gui, Add, Text,, Shift + F3 Empties the clipboard and recycle bin.
Gui, Add, Text,, Mousewheel turns the volume up, down or mutes it.
Gui, Add, Text,, Alt + T Sets the active window on top.
Gui, Add, Text,, End makes the active window fullscreen.
Gui, Add, Text,, Win + J adds the creation date to the selected file.
Gui, Add, Text,, Win + Left snaps the active window to the left.
Gui, Add, Text,, Win + Right snaps the active window to the right.
Gui, Add, Text,, Win + Down Restores the active window to the position before the snapping.
Gui, Add, Text,, Appskey executes the last copied clipboard text as admin in cmd
Gui, Add, Text,, Right Ctrl Googles for last copied clipboard text
Gui, Tab, 2
Gui, Add, Text,, The script can set the calculator and Picture-In-Picture always on top.
Gui, Tab, 3
Gui, Add, Button, gGithubLink, Github
Gui, Add, Button, gYoutubeLink, Youtube
Gui, Add, Edit, ReadOnly, Email: jannik.joergensen15@gmail.com
Gui, Tab
Gui, show
return

GithubLink:
Run, https://github.com/Ven0m0/Autohotkey-scripts
return

YoutubeLink:
Run, https://www.youtube.com/channel/UCgRZ6y1F3uDF9UR3LFRgFXg
return