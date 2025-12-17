#Include %A_ScriptDir%\..\..\Lib\v1\AHK_Common.ahk
InitScript(true, true)  ; UIA + Admin required

#SingleInstance Force
#Persistent
#NoEnv  ; v1 compatibility
#Warn
SetBatchLines -1
SetTitleMatchMode, 3
SetTitleMatchMode, Fast

global gButtonActions := {}
global gActionCount := 0
global DEFAULT_WAIT_TIMEOUT := 30

CreateLauncherGui(tabLabels, buttonSets, windowTitle := "My Codes") {
  global gButtonActions, gActionCount
  ResetActions()

  Gui, New, +AlwaysOnTop -MinimizeBox, % windowTitle
  Gui, Add, Tab2,, % tabLabels

  for index, buttons in buttonSets {
    Gui, Tab, %index%
    AddButtons(buttons)
  }

  Gui, Tab
  Gui, Add, Button, default xm, OK
  Gui, Show
}

AddButtons(buttons) {
  for _, button in buttons {
    AddButton(button)
  }
}

AddButton(button) {
  global gActionCount, gButtonActions
  gActionCount++
  controlName := "Action" gActionCount
  Gui, Add, Button, % "v" controlName " gHandleAction w80 h50 x" button.x " y" button.y, % button.label
  gButtonActions[controlName] := button.action
}

HandleAction:
  global gButtonActions
  action := gButtonActions[A_GuiControl]
  PerformAction(action)
return

PerformAction(action) {
  if (!IsObject(action))
    return

  if (action.HasKey("run")) {
    pid := 0
    pidVar := action.HasKey("storePidVar") ? action.storePidVar : ""
    target := QuotePathIfNeeded(action.run)

    Run, %target%, , , pid
    if (pidVar != "")
      SetEnv, %pidVar%, %pid%

    if (action.HasKey("waitExe")) {
      timeout := action.HasKey("waitTimeout") ? action.waitTimeout : DEFAULT_WAIT_TIMEOUT
      WinWait, % action.waitExe, , %timeout%
      if (ErrorLevel) {
        MsgBox, 16, Window Not Found, % "Timed out waiting for " action.waitExe " after " timeout " seconds."
        return
      }
      WinGet, waitedPid, PID, % action.waitExe
      pid := waitedPid
      if (pidVar != "")
        SetEnv, %pidVar%, %pid%
    }

    if (action.HasKey("priority") && pid) {
      Process, Priority, %pid%, % action.priority
    }

    ActivateIfNeeded(action)
    return
  }

  if (action.HasKey("killPidVar")) {
    pidVar := action.killPidVar
    pid := %pidVar%
    if (pid)
      WinKill, ahk_pid %pid%
    return
  }

  if (action.HasKey("killWinTitle")) {
    WinKill, % action.killWinTitle
    return
  }

  ActivateIfNeeded(action)
}

ButtonOK:
GuiClose:
  ExitApp

ResetActions() {
  global gButtonActions, gActionCount
  gButtonActions := {}
  gActionCount := 0
}

QuotePathIfNeeded(target) {
  if (!target)
    return target
  firstChar := SubStr(target, 1, 1)
  lastChar := SubStr(target, StrLen(target), 1)
  if (InStr(target, " ") && firstChar != """" && lastChar != """")
    return """" target """"
  return target
}

ActivateIfNeeded(action) {
  if (!action.HasKey("activateTitle") && !action.HasKey("sendKeys"))
    return

  if (action.HasKey("activateTitle")) {
    IfWinExist, % action.activateTitle
    {
      WinActivate, % action.activateTitle
    }
  }

  if (action.HasKey("sendKeys")) {
    Send, % action.sendKeys
  }
}
