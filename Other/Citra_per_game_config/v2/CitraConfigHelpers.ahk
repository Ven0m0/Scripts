; ============================================================================
; CitraConfigHelpers.ahk - v2 Helper Functions for Citra Configuration
; Replaces tf.ahk dependency with native v2 functions
; Author: Migrated from v1 - 2025-12-26
; ============================================================================

#Requires AutoHotkey v2.0

; ============================================================================
; RegExEscape(str) - Escape regex special characters
;
; Escapes special regex characters to allow literal string matching
;
; Parameters:
;   str - String to escape
;
; Returns:
;   Escaped string safe for use in regex patterns
; ============================================================================
RegExEscape(str) {
    return RegExReplace(str, "([\\()\[\]{}?*+|^$.])", "\$1")
}

; ============================================================================
; SetKey(content, key, value) - Set or replace INI key value
;
; Modifies an INI-style configuration string by setting a key=value pair.
; If the key exists, replaces its value. If not, appends the key=value.
;
; Parameters:
;   content - Configuration file content as string
;   key - Key name (e.g., "resolution_factor")
;   value - Value to set
;
; Returns:
;   Modified configuration content
; ============================================================================
SetKey(content, key, value) {
    pat := "m)^(" . RegExEscape(key) . ")\s*=.*$"
    if RegExMatch(content, pat)
        return RegExReplace(content, pat, "$1=" value, , 1)
    else
        return content "`n" key "=" value
}

; ============================================================================
; LoadConfig(configFile) - Load configuration file
;
; Reads configuration file into string for manipulation
;
; Parameters:
;   configFile - Path to configuration file
;
; Returns:
;   File content as string, or empty string if file doesn't exist
; ============================================================================
LoadConfig(configFile) {
    cfg := ""
    if FileExist(configFile)
        cfg := FileRead(configFile)
    return cfg
}

; ============================================================================
; SaveConfig(cfg, configFile) - Save configuration file
;
; Writes configuration string to file with backup
;
; Parameters:
;   cfg - Configuration content to write
;   configFile - Path to configuration file
;
; Returns:
;   true on success, false on failure
; ============================================================================
SaveConfig(cfg, configFile) {
    ; Create backup before modifying
    if FileExist(configFile) {
        try {
            FileCopy(configFile, configFile . ".bak", 1)
        } catch {
            ; Backup failed, but continue anyway
        }
    }

    ; Write new config
    try {
        if FileExist(configFile)
            FileDelete(configFile)
        FileAppend(cfg, configFile)
        return true
    } catch as err {
        MsgBox("Error saving config: " . err.Message, "Config Save Error", 16)
        return false
    }
}

; ============================================================================
; ReplaceInFile(filePath, searchText, replaceText) - Replace text in file
;
; Simplified replacement of TF_Replace functionality
; Replaces all occurrences of searchText with replaceText in a file
;
; Parameters:
;   filePath - Path to file to modify
;   searchText - Text to search for
;   replaceText - Text to replace with
;
; Returns:
;   true on success, false on failure
; ============================================================================
ReplaceInFile(filePath, searchText, replaceText) {
    try {
        cfg := LoadConfig(filePath)
        if (cfg = "")
            return false

        cfg := StrReplace(cfg, searchText, replaceText)
        return SaveConfig(cfg, filePath)
    } catch {
        return false
    }
}
