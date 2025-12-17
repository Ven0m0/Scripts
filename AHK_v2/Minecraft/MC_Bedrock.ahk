#Requires AutoHotkey v2.0

; ============================================================================
; MC_Bedrock.ahk - Minecraft Bedrock Edition launcher with audio setup
; Version: 2.0.0 (Migrated to AHK v2)
;
; WARNING: This script contains hardcoded paths that need customization:
;   - ToolDir variable points to specific user directory
;   - Adjust paths before use
; ============================================================================

#Include %A_ScriptDir%\..\..\Lib\v2\AHK_Common.ahk
InitScript(false, false, true)

#SingleInstance Force
Persistent

; TODO: Update this path to match your system
; Original: C:\Users\janni\OneDrive\Backup\Optimal\Scripts\Other\Playnite\Playnite Fullscreen
ToolDir := A_ScriptDir . "\..\..\Other\Playnite_fullscreen"

; Launch Minecraft Bedrock Edition
Run("shell:AppsFolder\Microsoft.MinecraftUWP_8wekyb3d8bbwe!App")
DllCall("kernel32.dll\Sleep", "UInt", 250)

; Set default audio devices (requires SoundVolumeView)
try {
    RunWait(ToolDir . "\SoundVolumeView\SoundVolumeView.exe /SetDefault `"THX Spatial - Synapse`"")
    DllCall("kernel32.dll\Sleep", "UInt", 250)
    RunWait(ToolDir . "\SoundVolumeView\SoundVolumeView.exe /SetDefault `"Razer Audio Controller - Game`"")
} catch Error as err {
    ; SoundVolumeView not found or error - continue anyway
}
