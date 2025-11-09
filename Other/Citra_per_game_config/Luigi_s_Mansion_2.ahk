#include %A_ScriptDir%\CitraConfigBase.ahk

; Internal Resolution to 6x
TF_RegExReplace(CitraConfigFile,"resolution_factor=([2-9]|10|1)","resolution_factor=6")

; Emulation Speed to 25%
TF_Replace(CitraConfigFile,"cpu_clock_percentage=125","cpu_clock_percentage=25")