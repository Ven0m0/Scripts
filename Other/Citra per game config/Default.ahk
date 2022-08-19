#SingleInstance Force
; #Warn  ; Enable warnings to assist with detecting common errors. Warn needs to be off for tf library.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#KeyHistory 0
#include %A_ScriptDir%\tf.ahk
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
DetectHiddenText, Off
DetectHiddenWindows, Off
ListLines Off ; ListLines and #KeyHistory are functions used to "log your keys". Disable them as they're only useful for debugging purposes.
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0 ; Even though SendInput ignores SetKeyDelay, SetMouseDelay and SetDefaultMouseSpeed, having these delays at -1 improves SendEvent's speed just in case SendInput is not available and falls back to SendEvent.
SetWinDelay, -1
SetControlDelay, -1 ; SetWinDelay and SetControlDelay may affect performance depending on the script.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetTitleMatchMode, 3 ; Use SetTitleMatchMode 2 when you want to use wintitle that contains text anywhere in the title

; Internal Resolution to 10x
TF_RegExReplace("!C:\Users\janni\OneDrive\Backup\Game\Emul\Citra\nightly-mingw\user\config\qt-config.ini","resolution_factor=([2-9]|10|1)","resolution_factor=10")

; Texture Filter to XBRZ Freescale
TF_Replace("!C:\Users\janni\OneDrive\Backup\Game\Emul\Citra\nightly-mingw\user\config\qt-config.ini","texture_filter_name=none","texture_filter_name=xBRZ freescale")
TF_Replace("!C:\Users\janni\OneDrive\Backup\Game\Emul\Citra\nightly-mingw\user\config\qt-config.ini","texture_filter_name\default=true","texture_filter_name\default=false")

; Shader to Bump Mapping AA Optimize
TF_Replace("!C:\Users\janni\OneDrive\Backup\Game\Emul\Citra\nightly-mingw\user\config\qt-config.ini","pp_shader_name=none (builtin)","pp_shader_name=Bump_Mapping_AA_optimize")
TF_Replace("!C:\Users\janni\OneDrive\Backup\Game\Emul\Citra\nightly-mingw\user\config\qt-config.ini","pp_shader_name\default=true","pp_shader_name\default=false")

; Preloading on
TF_Replace("!C:\Users\janni\OneDrive\Backup\Game\Emul\Citra\nightly-mingw\user\config\qt-config.ini","preload_textures\default=true","preload_textures\default=false")
TF_Replace("!C:\Users\janni\OneDrive\Backup\Game\Emul\Citra\nightly-mingw\user\config\qt-config.ini","preload_textures=false","preload_textures=true")

; Emulation Speed to 125%
TF_Replace("!C:\Users\janni\OneDrive\Backup\Game\Emul\Citra\nightly-mingw\user\config\qt-config.ini","cpu_clock_percentage=25","cpu_clock_percentage=125")

; Layout to Large screen
TF_Replace("!C:\Users\janni\OneDrive\Backup\Game\Emul\Citra\nightly-mingw\user\config\qt-config.ini","layout_option=0","layout_option=2")