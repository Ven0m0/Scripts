; ============================================================================
; Default.ahk - Apply default Citra configuration (v2)
; Migrated from v1: 2025-12-26
; Changes: Eliminated tf.ahk dependency, modernized v2 syntax
; ============================================================================

#Include CitraConfigBase.ahk

; Load current configuration
cfg := LoadConfig(CitraConfigFile)

; Internal Resolution to 10x
cfg := RegExReplace(cfg, "m)^resolution_factor=([2-9]|10|1)$", "resolution_factor=10")

; Texture Filter to XBRZ Freescale
cfg := StrReplace(cfg, "texture_filter_name=none", "texture_filter_name=xBRZ freescale")
cfg := StrReplace(cfg, "texture_filter_name\default=true", "texture_filter_name\default=false")

; Shader to Bump Mapping AA Optimize
cfg := StrReplace(cfg, "pp_shader_name=none (builtin)", "pp_shader_name=Bump_Mapping_AA_optimize")
cfg := StrReplace(cfg, "pp_shader_name\default=true", "pp_shader_name\default=false")

; Preloading on
cfg := StrReplace(cfg, "preload_textures\default=true", "preload_textures\default=false")
cfg := StrReplace(cfg, "preload_textures=false", "preload_textures=true")

; Emulation Speed to 125%
cfg := StrReplace(cfg, "cpu_clock_percentage=25", "cpu_clock_percentage=125")

; Layout to Large screen
cfg := StrReplace(cfg, "layout_option=0", "layout_option=2")

; Save configuration
if SaveConfig(cfg, CitraConfigFile) {
    MsgBox("Default Citra configuration applied successfully!", "Config Applied", 64)
} else {
    MsgBox("Failed to apply configuration. Please check file permissions.", "Error", 16)
    ExitApp 1
}

ExitApp 0
