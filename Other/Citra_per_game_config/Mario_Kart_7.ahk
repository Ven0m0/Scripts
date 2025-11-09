#include %A_ScriptDir%\CitraConfigBase.ahk

; Internal Resolution to 5x
TF_RegExReplace(CitraConfigFile, "resolution_factor=([2-9]|10|1)", "resolution_factor=5")

; Texture Filter to none
TF_Replace(CitraConfigFile, "texture_filter_name=xBRZ freescale", "texture_filter_name=none")
TF_Replace(CitraConfigFile, "texture_filter_name\default=false", "texture_filter_name\default=true")

; Preloading off
TF_Replace(CitraConfigFile, "preload_textures\default=false", "preload_textures\default=true")
TF_Replace(CitraConfigFile, "preload_textures=false", "preload_textures=false")
