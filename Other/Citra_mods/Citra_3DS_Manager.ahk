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
RegExEscape(str){
  static specials := "()[]{}?*+|^$.\"
  out := ""
  Loop, Parse, str
    out .= InStr(specials, A_LoopField) ? "\" A_LoopField : A_LoopField
  return out
}

SetKey(content, key, value){
  pat := "m)^(" . RegExEscape(key) . ")\s*=.*$"
  if (RegExMatch(content, pat))
    return RegExReplace(content, pat, "$1=" value, , 1)
  else
    return content "`n" key "=" value
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
  ; defaults
  cfg := SetKey(cfg, "resolution_factor", "10")
  cfg := SetKey(cfg, "texture_filter_name", "xBRZ freescale")
  cfg := SetKey(cfg, "texture_filter_name\\default", "false")
  cfg := SetKey(cfg, "pp_shader_name", "Bump_Mapping_AA_optimize")
  cfg := SetKey(cfg, "pp_shader_name\\default", "false")
  cfg := SetKey(cfg, "preload_textures\\default", "false")
  cfg := SetKey(cfg, "preload_textures", "true")
  cfg := SetKey(cfg, "cpu_clock_percentage", "125")
  cfg := SetKey(cfg, "layout_option", "2")

  if (norm = "3d_land"){
    cfg := SetKey(cfg, "resolution_factor", "8")
    cfg := SetKey(cfg, "texture_filter_name", "none")
    cfg := SetKey(cfg, "texture_filter_name\\default", "true")
    cfg := SetKey(cfg, "pp_shader_name", "none (builtin)")
    cfg := SetKey(cfg, "pp_shader_name\\default", "false")
    cfg := SetKey(cfg, "preload_textures", "false")
    cfg := SetKey(cfg, "preload_textures\\default", "true")
  } else if (norm = "hd_texture_pack"){
    cfg := SetKey(cfg, "resolution_factor", "4")
    cfg := SetKey(cfg, "texture_filter_name", "none")
    cfg := SetKey(cfg, "texture_filter_name\\default", "true")
    cfg := SetKey(cfg, "pp_shader_name", "none (builtin)")
    cfg := SetKey(cfg, "pp_shader_name\\default", "false")
    cfg := SetKey(cfg, "preload_textures", "false")
    cfg := SetKey(cfg, "preload_textures\\default", "true")
  } else if (norm = "luigi_s_mansion_2"){
    cfg := SetKey(cfg, "resolution_factor", "6")
    cfg := SetKey(cfg, "cpu_clock_percentage", "25")
  } else if (norm = "mario_kart_7"){
    cfg := SetKey(cfg, "resolution_factor", "5")
    cfg := SetKey(cfg, "texture_filter_name", "none")
    cfg := SetKey(cfg, "texture_filter_name\\default", "true")
    cfg := SetKey(cfg, "preload_textures", "false")
    cfg := SetKey(cfg, "preload_textures\\default", "true")
  } else if (norm = "mario_luigi_bowser_s_inside_story"){
    cfg := SetKey(cfg, "layout_option", "0")
    cfg := SetKey(cfg, "texture_filter_name", "none")
    cfg := SetKey(cfg, "texture_filter_name\\default", "true")
    cfg := SetKey(cfg, "pp_shader_name", "none (builtin)")
    cfg := SetKey(cfg, "pp_shader_name\\default", "false")
    cfg := SetKey(cfg, "preload_textures", "false")
    cfg := SetKey(cfg, "preload_textures\\default", "true")
  } else if (norm = "mario_luigi"){
    cfg := SetKey(cfg, "layout_option", "0")
  } else if (norm = "no_preloading"){
    cfg := SetKey(cfg, "preload_textures", "false")
    cfg := SetKey(cfg, "preload_textures\\default", "true")
  } else if (norm = "nsmb2"){
    cfg := SetKey(cfg, "resolution_factor", "10")
    cfg := SetKey(cfg, "texture_filter_name", "none")
    cfg := SetKey(cfg, "texture_filter_name\\default", "true")
    cfg := SetKey(cfg, "pp_shader_name", "none (builtin)")
    cfg := SetKey(cfg, "pp_shader_name\\default", "false")
    cfg := SetKey(cfg, "preload_textures", "false")
    cfg := SetKey(cfg, "preload_textures\\default", "true")
  }

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
  vCount := 0
  Loop, Files, %tgtDir%\*, DF
    vCount++
  if (vCount)
    return "Dir has " vCount " item(s). Can't copy"

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
