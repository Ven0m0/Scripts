#include %A_ScriptDir%\CitraConfigBase.ahk

; Internal Resolution to 4x
TF_RegExReplace(CitraConfigFile,"resolution_factor=([2-9]|10|1)","resolution_factor=4")

; Texture Filter to none
TF_Replace(CitraConfigFile,"texture_filter_name=xBRZ freescale","texture_filter_name=none")
TF_Replace(CitraConfigFile,"texture_filter_name\default=false","texture_filter_name\default=true")

; Shader to none
TF_Replace(CitraConfigFile,"pp_shader_name=Bump_Mapping_AA_optimize","pp_shader_name=none (builtin)")
TF_Replace(CitraConfigFile,"pp_shader_name\default=true","pp_shader_name\default=false")

; Preloading off
TF_Replace(CitraConfigFile,"preload_textures\default=false","preload_textures\default=true")
TF_Replace(CitraConfigFile,"preload_textures=false","preload_textures=false")