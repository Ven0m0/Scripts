#include %A_ScriptDir%\CitraConfigBase.ahk

; Internal Resolution to 10x
TF_RegExReplace(CitraConfigFile, "resolution_factor=([2-9]|10|1)", "resolution_factor=10")

; Texture Filter to XBRZ Freescale
TF_Replace(CitraConfigFile, "texture_filter_name=none", "texture_filter_name=xBRZ freescale")
TF_Replace(CitraConfigFile, "texture_filter_name\default=true", "texture_filter_name\default=false")

; Shader to Bump Mapping AA Optimize
TF_Replace(CitraConfigFile, "pp_shader_name=none (builtin)", "pp_shader_name=Bump_Mapping_AA_optimize")
TF_Replace(CitraConfigFile, "pp_shader_name\default=true", "pp_shader_name\default=false")

; Preloading on
TF_Replace(CitraConfigFile, "preload_textures\default=true", "preload_textures\default=false")
TF_Replace(CitraConfigFile, "preload_textures=false", "preload_textures=true")

; Emulation Speed to 125%
TF_Replace(CitraConfigFile, "cpu_clock_percentage=25", "cpu_clock_percentage=125")

; Layout to Large screen
TF_Replace(CitraConfigFile, "layout_option=0", "layout_option=2")