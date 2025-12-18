#Requires AutoHotkey v2.0

#SingleInstance Force
SendMode "Input"
SetWorkingDir A_ScriptDir

#Include %A_ScriptDir%\..\Lib\v2\AHK_Common.ahk
InitScript(true, false, false)  ; UIA required, no admin, manual tuning

KeyHistory(0)
ListLines False
SetBatchLines(-1)
SetKeyDelay(-1, -1)
SetMouseDelay(-1)
SetDefaultMouseSpeed(0)
SetWinDelay(-1)
SetControlDelay(-1)
SetTitleMatchMode(3)
SetTitleMatchMode("Fast")
SetNumLockState("AlwaysOn")
SetCapsLockState("AlwaysOff")
SetScrollLockState("AlwaysOff")

; Monitor metrics
mw := GetMonitorWidth()
mh := GetMonitorHeight()
pw := mw / 3
ph := mh / 3
lw := (2 * pw > 1024) ? 1024 : 2 * pw
rw := mw - lw
positions := Map()

; Keep Calculator always on top while it exists
SetTimer(SetAlwaysOnTop, 1000)

; Tray documentation entry
A_TrayMenu.Add("Documentation", ShowDocumentation)

#HotIf !WinActive("ahk_exe Explorer.EXE")
+F1::WinMinimize("A")
#HotIf

+F2:: {
  FileRecycleEmpty()
  A_Clipboard := ""
}

*!WheelUp::Send("{Media_Next}")
*!WheelDown::Send("{Media_Prev}")
*!MButton::Send("{Media_Play_Pause}")
*F24::Send("{Media_Play_Pause}")

*!t::WinSetAlwaysOnTop("Toggle", "A")

#j::AddDateToSelection()

#Left::MoveWindowLeft()
#Right::MoveWindowRight()
#Down::RestoreWindowPosition()

; ---------------------------------------------------------------------------
; Timers / Helpers
; ---------------------------------------------------------------------------

SetAlwaysOnTop(*) {
  if WinExist("Calculator") {
    WinSetAlwaysOnTop("On", "Calculator")
  } else {
    SetTimer(SetAlwaysOnTop, 0)
  }
}

AddDateToSelection() {
  selection := Explorer_GetSelection()
  if !selection {
    MsgBox("No files were selected", "Selection Required", "Icon!")
    return
  }

  for Fn in StrSplit(selection, "`n", "`r") {
    created := FileGetTime(Fn, "C")
    SplitPath(Fn, , &dir, &ext, &nameNoExt)
    stamp := FormatTime(created, "yyyyMMdd")
    newName := dir . "\" . stamp . "_" . nameNoExt . "." . ext
    FileMove(Fn, newName, 1)
  }
}

MoveWindowLeft() {
  global lw, mh
  SaveWindowPosition()
  if IsResizable() {
    WinMove(0, 0, lw, mh, "A")
  } else {
    WinMove(0, 0, , , "A")
  }
}

MoveWindowRight() {
  global lw, rw, mh
  SaveWindowPosition()
  if IsResizable() {
    WinMove(lw, 0, rw, mh, "A")
  } else {
    WinMove(lw, 0, , , "A")
  }
}

RestoreWindowPosition() {
  global positions
  hwnd := WinExist("A")
  if !positions.Has(hwnd)
    return

  pos := positions[hwnd]
  WinMove(pos[1], pos[2], pos[3], pos[4], "A")
}

SaveWindowPosition() {
  global positions
  hwnd := WinExist("A")
  WinGetPos(&x, &y, &w, &h, "A")
  positions[hwnd] := [x, y, w, h]
}

GetMonitorWidth() {
  MonitorGetWorkArea(1, &left, &top, &right, &bottom)
  return right - left
}

GetMonitorHeight() {
  MonitorGetWorkArea(1, &left, &top, &right, &bottom)
  return bottom - top
}

IsResizable() {
  style := WinGetStyle("A")
  return (style & 0x00040000) != 0  ; WS_SIZEBOX
}

Explorer_GetSelection() {
  hwnd := WinExist("A")
  winClass := WinGetClass("ahk_id " hwnd)
  shell := ComObject("Shell.Application")
  doc := ""

  for window in shell.Windows {
    try {
      if (window.HWND = hwnd) {
        doc := window.Document
        break
      }
    } catch {
      continue
    }
  }

  if !doc && RegExMatch(winClass, "Progman|WorkerW") {
    try doc := shell.Windows.Item(0).Document
  }

  if !doc
    return ""

  result := ""
  for item in doc.SelectedItems
    result .= (result ? "`n" : "") . item.Path

  if !result
    result := doc.Folder.Self.Path

  return result
}

; ---------------------------------------------------------------------------
; Documentation GUI
; ---------------------------------------------------------------------------

ShowDocumentation(*) {
  docGui := Gui("+AlwaysOnTop", "Documentation")
  tabs := docGui.Add("Tab3", , ["Hotkeys", "Functions", "Links"])

  tabs.UseTab(1)
  docGui.Add("Text", , "Shift + F1 Minimizes the active window.")
  docGui.Add("Text", , "Shift + F2 Empties the clipboard and recycle bin")
  docGui.Add("Text", , "Alt + Mousewheel Gives media control")
  docGui.Add("Text", , "Alt + T Sets the active window on top.")
  docGui.Add("Text", , "End makes the active window fullscreen.")
  docGui.Add("Text", , "Win + J adds the creation date to the selected file.")
  docGui.Add("Text", , "Win + Left snaps the active window to the left.")
  docGui.Add("Text", , "Win + Right snaps the active window to the right.")
  docGui.Add("Text", , "Win + Down Restores the active window to the position before the snapping.")

  tabs.UseTab(2)
  docGui.Add("Text", , "The script sets the calculator to always on top.")

  tabs.UseTab(3)
  docGui.Add("Button", "x25 y120 w80", "LinkTree").OnEvent("Click", (*) => Run("https://linktr.ee/Ven0m0"))
  docGui.Add("Button", "x115 y120 w80", "Github").OnEvent("Click", (*) => Run("https://github.com/Ven0m0"))
  docGui.Add("Button", "x205 y120 w80", "Youtube").OnEvent("Click", (*) => Run("https://www.youtube.com/@ven0m017"))
  docGui.Add("Text", "x25 y165", "Email:")
  docGui.Add("Edit", "x65 y160 w230 ReadOnly", "ven0m0.wastaken@gmail.com")

  tabs.UseTab()
  docGui.Show("Center")
}
