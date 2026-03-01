#SingleInstance Force
#Warn
#NoEnv
SetBatchLines, -1
SetWorkingDir %A_ScriptDir%
ListLines Off
DetectHiddenWindows, Off
DetectHiddenText, Off

;----------------- Paths -----------------
EnvGet, OneDriveDir, OneDrive
if (!OneDriveDir)
  OneDriveDir := A_ScriptDir  ; fallback if OneDrive not set

BaseDir     := OneDriveDir "\Backup\Game\Emul\Citra\nightly-mingw"
ModRoot     := BaseDir "\Mods"
ModTarget   := BaseDir "\user\load\mods"
ConfigFile  := BaseDir "\user\config\qt-config.ini"
DestCsv     := A_ScriptDir "\Destination.csv"

;----------------- Data -----------------
global DestMap := {}
global Mods := []  ; each: {game, mod, title, src}

LoadDestinations(){
  global DestMap, DestCsv
  DestMap := {}
  if !FileExist(DestCsv)
    return
  Loop, Read, %DestCsv%
  {
    line := Trim(A_LoopReadLine)
    if (line = "" || !InStr(line, ","))
      continue
    StringSplit, p, line, `,
    g := Trim(p1), t := Trim(p2)
    if (g != "" && t != "")
      DestMap[g] := t
  }
}

ScanMods(){
  global Mods, ModRoot, DestMap
  Mods := []
  if !FileExist(ModRoot)
    return
  Loop, Files, %ModRoot%\*.*, D
  {
    game := A_LoopFileName
    title := DestMap.HasKey(game) ? DestMap[game] : ""
    Loop, Files, %A_LoopFileFullPath%\*.*, D
      Mods.Push({game: game, mod: A_LoopFileName, title: title, src: A_LoopFileFullPath})
  }
}

;----------------- Config Helpers -----------------
UpdateConfig(content, updates){
  newContent := ""
  remaining := updates.Clone()

  Loop, Parse, content, `n, `r
  {
    line := A_LoopField
    pos := InStr(line, "=")
    if (pos > 1){
      keyCandidate := RTrim(SubStr(line, 1, pos-1))
      if (remaining.HasKey(keyCandidate)){
        val := remaining[keyCandidate]
        line := keyCandidate "=" val
        remaining.Delete(keyCandidate)
      }
    }
    newContent .= line "`n"
  }

  for k, v in remaining {
     newContent .= k "=" v "`n"
  }

  return SubStr(newContent, 1, -1)
}

LoadConfig(){
  global ConfigFile
  cfg := ""
  if FileExist(ConfigFile)
    FileRead, cfg, %ConfigFile%
  return cfg
}

SaveConfig(cfg){
  global ConfigFile
  if FileExist(ConfigFile)
    FileCopy, %ConfigFile%, %ConfigFile%.bak, 1
  f := FileOpen(ConfigFile, "w")
  if (!IsObject(f))
    return false
  f.Write(cfg)
  f.Close()
  return true
}

ApplyPreset(game){
  cfg := LoadConfig()
  if (cfg = "")
    return "Config missing"

  norm := NormKey(game)
  updates := {}

  ; defaults
  updates["resolution_factor"] := "10"
  updates["texture_filter_name"] := "xBRZ freescale"
  updates["texture_filter_name\\default"] := "false"
  updates["pp_shader_name"] := "Bump_Mapping_AA_optimize"
  updates["pp_shader_name\\default"] := "false"
  updates["preload_textures\\default"] := "false"
  updates["preload_textures"] := "true"
  updates["cpu_clock_percentage"] := "125"
  updates["layout_option"] := "2"

  if (norm = "3d_land"){
    updates["resolution_factor"] := "8"
    updates["texture_filter_name"] := "none"
    updates["texture_filter_name\\default"] := "true"
    updates["pp_shader_name"] := "none (builtin)"
    updates["pp_shader_name\\default"] := "false"
    updates["preload_textures"] := "false"
    updates["preload_textures\\default"] := "true"
  } else if (norm = "hd_texture_pack"){
    updates["resolution_factor"] := "4"
    updates["texture_filter_name"] := "none"
    updates["texture_filter_name\\default"] := "true"
    updates["pp_shader_name"] := "none (builtin)"
    updates["pp_shader_name\\default"] := "false"
    updates["preload_textures"] := "false"
    updates["preload_textures\\default"] := "true"
  } else if (norm = "luigi_s_mansion_2"){
    updates["resolution_factor"] := "6"
    updates["cpu_clock_percentage"] := "25"
  } else if (norm = "mario_kart_7"){
    updates["resolution_factor"] := "5"
    updates["texture_filter_name"] := "none"
    updates["texture_filter_name\\default"] := "true"
    updates["preload_textures"] := "false"
    updates["preload_textures\\default"] := "true"
  } else if (norm = "mario_luigi_bowser_s_inside_story"){
    updates["layout_option"] := "0"
    updates["texture_filter_name"] := "none"
    updates["texture_filter_name\\default"] := "true"
    updates["pp_shader_name"] := "none (builtin)"
    updates["pp_shader_name\\default"] := "false"
    updates["preload_textures"] := "false"
    updates["preload_textures\\default"] := "true"
  } else if (norm = "mario_luigi"){
    updates["layout_option"] := "0"
  } else if (norm = "no_preloading"){
    updates["preload_textures"] := "false"
    updates["preload_textures\\default"] := "true"
  } else if (norm = "nsmb2"){
    updates["resolution_factor"] := "10"
    updates["texture_filter_name"] := "none"
    updates["texture_filter_name\\default"] := "true"
    updates["pp_shader_name"] := "none (builtin)"
    updates["pp_shader_name\\default"] := "false"
    updates["preload_textures"] := "false"
    updates["preload_textures\\default"] := "true"
  }

  cfg := UpdateConfig(cfg, updates)

  if (!SaveConfig(cfg))
    return "Failed to write config"
  return ""
}

NormKey(k){
  StringLower, k, k
  StringReplace, k, k, %A_Space%, _, All
  StringReplace, k, k, -, _, All
  StringReplace, k, k, ', , All
  return k
}

;----------------- Mod Copy -----------------
CopyMod(idx){
  global Mods, ModTarget
  if (idx < 1 || idx > Mods.Length())
    return "Select a mod"
  m := Mods[idx]
  if (m.title = "")
    return "Destination.csv missing title for " m.game

  target := ModTarget "\" m.title "\" m.mod
  src    := m.src

  ; ensure target parent exists
  SplitPath, target, , tgtDir
  FileCreateDir, %tgtDir%

  ; check emptiness of target parent dir
  isNotEmpty := false
  Loop, Files, %tgtDir%\*, DF
  {
    isNotEmpty := true
    break
  }
  if (isNotEmpty)
    return "Dir not empty. Can't copy"

  FileCopyDir, %src%, %target%, 1
  if (ErrorLevel)
    return "Copy failed"
  return ""
}

;----------------- GUI -----------------
Gui, New, -MinimizeBox, Citra 3DS Manager
Gui, Add, Text, xm ym, Base: %BaseDir%
Gui, Add, ListView, xm w700 h280 vLVMods gOnPick AltSubmit, Game|Mod|TitleID|Source
Gui, Add, Button, xm w100 gDoMod, Apply Mod
Gui, Add, Button, x+10 w110 gDoConfig, Apply Config
Gui, Add, Button, x+10 w110 gDoBoth, Apply Both
Gui, Add, Button, x+10 w80 gDoRefresh, Refresh
Gui, Add, Button, x+10 w120 gOpenSrc, Open Mods
Gui, Add, Button, x+10 w130 gOpenDst, Open Target
Gui, Show, , Citra 3DS Manager

ReloadData(){
  global Mods
  LV_Delete()
  LoadDestinations()
  ScanMods()
  For idx, m in Mods
    LV_Add("", m.game, m.mod, m.title, m.src)
  LV_ModifyCol()
}
ReloadData()

OnPick:
return

DoRefresh:
  ReloadData()
return

DoMod:
  Row := LV_GetNext()
  msg := CopyMod(Row)
  MsgBox % (msg="") ? "Mod copied." : msg
return

DoConfig:
  Row := LV_GetNext()
  if (!Row){
    MsgBox Select a row first.
    return
  }
  LV_GetText(g, Row, 1)
  msg := ApplyPreset(g)
  MsgBox % (msg="") ? "Config applied." : msg
return

DoBoth:
  Row := LV_GetNext()
  if (!Row){
    MsgBox Select a row first.
    return
  }
  LV_GetText(g, Row, 1)
  msg := CopyMod(Row)
  if (msg=""){
    msg := ApplyPreset(g)
    if (msg="")
      MsgBox Done: Mod + Config applied.
    else
      MsgBox Mod copied, but config error: %msg%
  } else {
    MsgBox %msg%
  }
return

OpenSrc:
  Run, %ModRoot%
return

OpenDst:
  Run, %ModTarget%
return

GuiClose:
GuiEscape:
ExitApp
