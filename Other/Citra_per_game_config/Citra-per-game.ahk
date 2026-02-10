#include %A_ScriptDir%\CitraConfigBase.ahk
; Unified per-game Citra config applicator
; Usage: Run this script with first arg = game key (see list in ShowHelp()).

;--- Helpers ---------------------------------------------------------------
SetRes(f){
  global ConfigText
  ConfigText := TF_RegExReplace(ConfigText, "resolution_factor=([2-9]|10|1)", "resolution_factor=" f)
}
SetFilter(name, isDefaultTrue){
  global ConfigText
  if (name="none")
    ConfigText := TF_Replace(ConfigText, "texture_filter_name=xBRZ freescale", "texture_filter_name=none")
  else if (name="xBRZ freescale")
    ConfigText := TF_Replace(ConfigText, "texture_filter_name=none", "texture_filter_name=xBRZ freescale")
  ConfigText := TF_Replace(ConfigText, "texture_filter_name\\default=" (isDefaultTrue ? "false" : "true"), "texture_filter_name\\default=" (isDefaultTrue ? "true" : "false"))
}
SetShader(name, wantDefaultFalse){
  global ConfigText
  if (name="none (builtin)")
    ConfigText := TF_Replace(ConfigText, "pp_shader_name=Bump_Mapping_AA_optimize", "pp_shader_name=none (builtin)")
  else if (name="Bump_Mapping_AA_optimize")
    ConfigText := TF_Replace(ConfigText, "pp_shader_name=none (builtin)", "pp_shader_name=Bump_Mapping_AA_optimize")
  ConfigText := TF_Replace(ConfigText, "pp_shader_name\\default=" (wantDefaultFalse ? "true" : "false"), "pp_shader_name\\default=" (wantDefaultFalse ? "false" : "true"))
}
SetPreload(on){
  global ConfigText
  ConfigText := TF_Replace(ConfigText, "preload_textures\\default=" (on ? "true" : "false"), "preload_textures\\default=" (on ? "false" : "true"))
  ConfigText := TF_Replace(ConfigText, "preload_textures=" (on ? "false" : "false"), "preload_textures=" (on ? "true" : "false"))
}
SetClock(pct){
  global ConfigText
  ConfigText := TF_Replace(ConfigText, "cpu_clock_percentage=125", "cpu_clock_percentage=" pct)
  ConfigText := TF_Replace(ConfigText, "cpu_clock_percentage=25", "cpu_clock_percentage=" pct)
}
SetLayout(opt){
  global ConfigText
  ConfigText := TF_Replace(ConfigText, "layout_option=2", "layout_option=" opt)
  ConfigText := TF_Replace(ConfigText, "layout_option=0", "layout_option=" opt)
}

NormKey(k){
  StringLower, k, k
  StringReplace, k, k, %A_Space%, _, All
  StringReplace, k, k, -, _, All
  StringReplace, k, k, "'", , All
  Return k
}

ShowHelp(){
  MsgBox, 48, CitraPerGame, Usage:`n  %A_ScriptName% <game_key>`n`nKeys:`n  default`n  3d_land`n  hd_texture_pack`n  luigi_s_mansion_2`n  mario_kart_7`n  mario_luigi_bowser_s_inside_story`n  mario_luigi`n  no_preloading`n  nsmb2
  ExitApp 1
}

;--- Main ------------------------------------------------------------------
if (0 < 1)
  ShowHelp()

game := NormKey(%1%)
; Aliases
if (game="luigi_mansion_2")
  game := "luigi_s_mansion_2"
else if (game="mario_luigi_bis")
  game := "mario_luigi_bowser_s_inside_story"
else if (game="mario_luigi_bowsers_inside_story")
  game := "mario_luigi_bowser_s_inside_story"

; Read config file once
global ConfigText
FileRead, ConfigText, %CitraConfigFile%

; Apply configs
if (game="default"){
  SetRes(10)
  SetFilter("xBRZ freescale", false)
  SetShader("Bump_Mapping_AA_optimize", true)
  SetPreload(true)
  SetClock(125)
  SetLayout(2)
} else if (game="3d_land"){
  SetRes(8)
  SetFilter("none", true)
  SetShader("none (builtin)", false)
  SetPreload(false)
} else if (game="hd_texture_pack"){
  SetRes(4)
  SetFilter("none", true)
  SetShader("none (builtin)", false)
  SetPreload(false)
} else if (game="luigi_s_mansion_2"){
  SetRes(6)
  SetClock(25)
} else if (game="mario_kart_7"){
  SetRes(5)
  SetFilter("none", true)
  SetPreload(false)
} else if (game="mario_luigi_bowser_s_inside_story"){
  SetLayout(0)
  SetFilter("none", true)
  SetShader("none (builtin)", false)
  SetPreload(false)
} else if (game="mario_luigi"){
  SetLayout(0)
} else if (game="no_preloading"){
  SetRes(10)
  SetFilter("xBRZ freescale", false)
  SetShader("Bump_Mapping_AA_optimize", true)
  SetPreload(false)
} else if (game="nsmb2"){
  SetRes(10)
  SetFilter("none", true)
  SetShader("none (builtin)", false)
  SetPreload(false)
} else {
  ShowHelp()
}

; Save config file once
TF_Save(ConfigText, CitraConfigFile)

MsgBox, 64, CitraPerGame, Applied config for '%game%'.
ExitApp 0
