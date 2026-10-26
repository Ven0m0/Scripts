#Requires AutoHotkey v2.0

#SingleInstance Force

#Include %A_ScriptDir%\..\Lib\AHK_Common.ahk
#Include %A_ScriptDir%\..\Lib\WindowManager.ahk
InitScript({titleMatch: 3})  ; exact titles, e.g. the "Calculator" timer

SetNumLockState("AlwaysOn")
SetCapsLockState("AlwaysOff")
SetScrollLockState("AlwaysOff")

; Keep Calculator always on top while it exists
SetTimer(SetAlwaysOnTop, 1000)

; Tray documentation entry
A_TrayMenu.Add("Documentation", ShowDocumentation)

#HotIf !WinActive("ahk_exe Explorer.EXE")
+F1::WinMinimize("A")
#HotIf

+F2:: {
  try FileRecycleEmpty()
  A_Clipboard := ""
}

*!WheelUp::Send("{Media_Next}")
*!WheelDown::Send("{Media_Prev}")
*!MButton::Send("{Media_Play_Pause}")
*F24::Send("{Media_Play_Pause}")

*!t::WinSetAlwaysOnTop("Toggle", "A")

#j::AddDateToSelection()

#Left::SnapWindow("left")
#Right::SnapWindow("right")
#Down::RestoreWindow()

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
