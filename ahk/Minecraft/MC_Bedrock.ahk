#Requires AutoHotkey v2.0

; ============================================================================
; MC_Bedrock.ahk - Minecraft Bedrock Edition launcher with audio setup
; Version: 2.1.0 (Migrated to AHK v2)
; ============================================================================

#Include %A_ScriptDir%\..\..\Lib\v2\AHK_Common.ahk
InitScript(false, false, true)

#SingleInstance Force
Persistent

; Locate SoundVolumeView
svv := FindExe("SoundVolumeView.exe", [
    A_ScriptDir . "\..\..\Other\SoundVolumeView\SoundVolumeView.exe",
    A_ScriptDir . "\..\..\Other\Playnite_fullscreen\SoundVolumeView\SoundVolumeView.exe"
])

; Launch Minecraft Bedrock Edition
Run("shell:AppsFolder\Microsoft.MinecraftUWP_8wekyb3d8bbwe!App")
DllCall("kernel32.dll\Sleep", "UInt", 250)

; Set default audio devices (requires SoundVolumeView)
if (svv != "") {
    try {
        RunWait(svv . ' /SetDefault "THX Spatial - Synapse"')
        DllCall("kernel32.dll\Sleep", "UInt", 250)
        RunWait(svv . ' /SetDefault "Razer Audio Controller - Game"')
    } catch Error as err {
        ; Error executing SoundVolumeView - continue anyway
    }
}
