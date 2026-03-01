; ============================================================================
; CitraPerGame.ahk - Unified per-game Citra config applicator (v2)
; Usage: Run this script with first arg = game key (see list in ShowHelp()).
; Migrated from v1: 2025-12-26
; Changes: Eliminated tf.ahk dependency, modernized v2 syntax
; ============================================================================

#Include CitraConfigBase.ahk

;--- Helpers ---------------------------------------------------------------

SetRes(cfg, f) {
    ; Replace resolution_factor with value f (supports 1-10)
    cfg := RegExReplace(cfg, "m)^resolution_factor=([2-9]|10|1)$", "resolution_factor=" f)
    return cfg
}

SetFilter(cfg, name, isDefaultTrue) {
    if (name = "none")
        cfg := StrReplace(cfg, "texture_filter_name=xBRZ freescale", "texture_filter_name=none")
    else if (name = "xBRZ freescale")
        cfg := StrReplace(cfg, "texture_filter_name=none", "texture_filter_name=xBRZ freescale")

    cfg := StrReplace(cfg, "texture_filter_name\default=" (isDefaultTrue ? "false" : "true"), "texture_filter_name\default=" (isDefaultTrue ? "true" : "false"))
    return cfg
}

SetShader(cfg, name, wantDefaultFalse) {
    if (name = "none (builtin)")
        cfg := StrReplace(cfg, "pp_shader_name=Bump_Mapping_AA_optimize", "pp_shader_name=none (builtin)")
    else if (name = "Bump_Mapping_AA_optimize")
        cfg := StrReplace(cfg, "pp_shader_name=none (builtin)", "pp_shader_name=Bump_Mapping_AA_optimize")

    cfg := StrReplace(cfg, "pp_shader_name\default=" (wantDefaultFalse ? "true" : "false"), "pp_shader_name\default=" (wantDefaultFalse ? "false" : "true"))
    return cfg
}

SetPreload(cfg, on) {
    cfg := StrReplace(cfg, "preload_textures\default=" (on ? "true" : "false"), "preload_textures\default=" (on ? "false" : "true"))
    cfg := StrReplace(cfg, "preload_textures=" (on ? "false" : "false"), "preload_textures=" (on ? "true" : "false"))
    return cfg
}

SetClock(cfg, pct) {
    cfg := StrReplace(cfg, "cpu_clock_percentage=125", "cpu_clock_percentage=" pct)
    cfg := StrReplace(cfg, "cpu_clock_percentage=25", "cpu_clock_percentage=" pct)
    return cfg
}

SetLayout(cfg, opt) {
    cfg := StrReplace(cfg, "layout_option=2", "layout_option=" opt)
    cfg := StrReplace(cfg, "layout_option=0", "layout_option=" opt)
    return cfg
}

NormKey(k) {
    k := StrLower(k)
    k := StrReplace(k, A_Space, "_")
    k := StrReplace(k, "-", "_")
    k := StrReplace(k, "'", "")
    return k
}

ShowHelp() {
    helpText := "
    (
    Usage:
      " A_ScriptName " <game_key>

    Keys:
      default
      3d_land
      hd_texture_pack
      luigi_s_mansion_2
      mario_kart_7
      mario_luigi_bowser_s_inside_story
      mario_luigi
      no_preloading
      nsmb2
    )"
    MsgBox(helpText, "CitraPerGame", 48)
    ExitApp 1
}

;--- Main ------------------------------------------------------------------

if (A_Args.Length < 1)
    ShowHelp()

game := NormKey(A_Args[1])

; Aliases
if (game = "luigi_mansion_2")
    game := "luigi_s_mansion_2"
else if (game = "mario_luigi_bis")
    game := "mario_luigi_bowser_s_inside_story"
else if (game = "mario_luigi_bowsers_inside_story")
    game := "mario_luigi_bowser_s_inside_story"

global CitraConfigFile
cfg := LoadConfig(CitraConfigFile)

; Apply configs
if (game = "default") {
    cfg := SetRes(cfg, 10)
    cfg := SetFilter(cfg, "xBRZ freescale", false)
    cfg := SetShader(cfg, "Bump_Mapping_AA_optimize", true)
    cfg := SetPreload(cfg, true)
    cfg := SetClock(cfg, 125)
    cfg := SetLayout(cfg, 2)
} else if (game = "3d_land") {
    cfg := SetRes(cfg, 8)
    cfg := SetFilter(cfg, "none", true)
    cfg := SetShader(cfg, "none (builtin)", false)
    cfg := SetPreload(cfg, false)
} else if (game = "hd_texture_pack") {
    cfg := SetRes(cfg, 4)
    cfg := SetFilter(cfg, "none", true)
    cfg := SetShader(cfg, "none (builtin)", false)
    cfg := SetPreload(cfg, false)
} else if (game = "luigi_s_mansion_2") {
    cfg := SetRes(cfg, 6)
    cfg := SetClock(cfg, 25)
} else if (game = "mario_kart_7") {
    cfg := SetRes(cfg, 5)
    cfg := SetFilter(cfg, "none", true)
    cfg := SetPreload(cfg, false)
} else if (game = "mario_luigi_bowser_s_inside_story") {
    cfg := SetLayout(cfg, 0)
    cfg := SetFilter(cfg, "none", true)
    cfg := SetShader(cfg, "none (builtin)", false)
    cfg := SetPreload(cfg, false)
} else if (game = "mario_luigi") {
    cfg := SetLayout(cfg, 0)
} else if (game = "no_preloading") {
    cfg := SetRes(cfg, 10)
    cfg := SetFilter(cfg, "xBRZ freescale", false)
    cfg := SetShader(cfg, "Bump_Mapping_AA_optimize", true)
    cfg := SetPreload(cfg, false)
} else if (game = "nsmb2") {
    cfg := SetRes(cfg, 10)
    cfg := SetFilter(cfg, "none", true)
    cfg := SetShader(cfg, "none (builtin)", false)
    cfg := SetPreload(cfg, false)
} else {
    ShowHelp()
}

SaveConfig(cfg, CitraConfigFile)

MsgBox("Applied config for '" game "'.", "CitraPerGame", 64)
ExitApp 0
