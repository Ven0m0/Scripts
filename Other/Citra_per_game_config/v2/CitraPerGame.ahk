; ============================================================================
; CitraPerGame.ahk - Unified per-game Citra config applicator (v2)
; Usage: Run this script with first arg = game key (see list in ShowHelp()).
; Migrated from v1: 2025-12-26
; Changes: Eliminated tf.ahk dependency, modernized v2 syntax
; ============================================================================

#Include CitraConfigBase.ahk

;--- Helpers ---------------------------------------------------------------

SetRes(f) {
    global CitraConfigFile
    cfg := LoadConfig(CitraConfigFile)
    ; Replace resolution_factor with value f (supports 1-10)
    cfg := RegExReplace(cfg, "m)^resolution_factor=([2-9]|10|1)$", "resolution_factor=" f)
    SaveConfig(cfg, CitraConfigFile)
}

SetFilter(name, isDefaultTrue) {
    global CitraConfigFile
    cfg := LoadConfig(CitraConfigFile)

    if (name = "none")
        cfg := StrReplace(cfg, "texture_filter_name=xBRZ freescale", "texture_filter_name=none")
    else if (name = "xBRZ freescale")
        cfg := StrReplace(cfg, "texture_filter_name=none", "texture_filter_name=xBRZ freescale")

    cfg := StrReplace(cfg, "texture_filter_name\default=" (isDefaultTrue ? "false" : "true"), "texture_filter_name\default=" (isDefaultTrue ? "true" : "false"))
    SaveConfig(cfg, CitraConfigFile)
}

SetShader(name, wantDefaultFalse) {
    global CitraConfigFile
    cfg := LoadConfig(CitraConfigFile)

    if (name = "none (builtin)")
        cfg := StrReplace(cfg, "pp_shader_name=Bump_Mapping_AA_optimize", "pp_shader_name=none (builtin)")
    else if (name = "Bump_Mapping_AA_optimize")
        cfg := StrReplace(cfg, "pp_shader_name=none (builtin)", "pp_shader_name=Bump_Mapping_AA_optimize")

    cfg := StrReplace(cfg, "pp_shader_name\default=" (wantDefaultFalse ? "true" : "false"), "pp_shader_name\default=" (wantDefaultFalse ? "false" : "true"))
    SaveConfig(cfg, CitraConfigFile)
}

SetPreload(on) {
    global CitraConfigFile
    cfg := LoadConfig(CitraConfigFile)

    cfg := StrReplace(cfg, "preload_textures\default=" (on ? "true" : "false"), "preload_textures\default=" (on ? "false" : "true"))
    cfg := StrReplace(cfg, "preload_textures=" (on ? "false" : "false"), "preload_textures=" (on ? "true" : "false"))
    SaveConfig(cfg, CitraConfigFile)
}

SetClock(pct) {
    global CitraConfigFile
    cfg := LoadConfig(CitraConfigFile)

    cfg := StrReplace(cfg, "cpu_clock_percentage=125", "cpu_clock_percentage=" pct)
    cfg := StrReplace(cfg, "cpu_clock_percentage=25", "cpu_clock_percentage=" pct)
    SaveConfig(cfg, CitraConfigFile)
}

SetLayout(opt) {
    global CitraConfigFile
    cfg := LoadConfig(CitraConfigFile)

    cfg := StrReplace(cfg, "layout_option=2", "layout_option=" opt)
    cfg := StrReplace(cfg, "layout_option=0", "layout_option=" opt)
    SaveConfig(cfg, CitraConfigFile)
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

; Apply configs
if (game = "default") {
    SetRes(10)
    SetFilter("xBRZ freescale", false)
    SetShader("Bump_Mapping_AA_optimize", true)
    SetPreload(true)
    SetClock(125)
    SetLayout(2)
} else if (game = "3d_land") {
    SetRes(8)
    SetFilter("none", true)
    SetShader("none (builtin)", false)
    SetPreload(false)
} else if (game = "hd_texture_pack") {
    SetRes(4)
    SetFilter("none", true)
    SetShader("none (builtin)", false)
    SetPreload(false)
} else if (game = "luigi_s_mansion_2") {
    SetRes(6)
    SetClock(25)
} else if (game = "mario_kart_7") {
    SetRes(5)
    SetFilter("none", true)
    SetPreload(false)
} else if (game = "mario_luigi_bowser_s_inside_story") {
    SetLayout(0)
    SetFilter("none", true)
    SetShader("none (builtin)", false)
    SetPreload(false)
} else if (game = "mario_luigi") {
    SetLayout(0)
} else if (game = "no_preloading") {
    SetRes(10)
    SetFilter("xBRZ freescale", false)
    SetShader("Bump_Mapping_AA_optimize", true)
    SetPreload(false)
} else if (game = "nsmb2") {
    SetRes(10)
    SetFilter("none", true)
    SetShader("none (builtin)", false)
    SetPreload(false)
} else {
    ShowHelp()
}

MsgBox("Applied config for '" game "'.", "CitraPerGame", 64)
ExitApp 0
