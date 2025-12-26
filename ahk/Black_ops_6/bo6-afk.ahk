#Requires AutoHotkey v2.0
#SingleInstance Force
ProcessSetPriority("High")
ListLines False

; Hotkeys (default bindings):
;   F1 – Toggle Balcony loop
;   F2 – Toggle Bank Roof (basic) loop
;   F3 – Toggle Bank Roof + Loot loop
;   F4 – Toggle Bank Roof Always (continuous fire) loop
;   F5 – Toggle Hold LMB (press/release)
;   F7 – Stop all
;   F9 – Exit
;
; To reuse this file from wrapper scripts:
;   - Set g_registerDefaultHotkeys := false before #Including
;   - Optionally set g_autostartMode := "<mode>" to auto-start a loop

if !IsSet(g_registerDefaultHotkeys)
    g_registerDefaultHotkeys := true

if !IsSet(g_autostartMode)
    g_autostartMode := ""

global runningMode := ""
global runId := 0
global ModeHandlers := Map(
    "balcony", BalconyLoop,
    "bank_basic", BankRoofCleanLoop,
    "bank_loot", BankRoofLootLoop,
    "bank_always", BankRoofAlwaysLoop,
    "hold_click", HoldClickLoop
)

StopAll() {
    global runningMode, runId
    runningMode := ""
    runId++  ; invalidate any running loop
    Send("{LButton up}")  ; ensure button released
}

StartMode(mode) {
    global runningMode, runId, ModeHandlers
    if !ModeHandlers.Has(mode)
        return

    runner := ModeHandlers[mode]
    if (runningMode = mode) {
        StopAll()
        return
    }

    StopAll()
    runningMode := mode
    thisId := ++runId
    ; launch asynchronously so hotkey returns immediately
    SetTimer(() => runner(thisId), -10)
}

RegisterDefaultHotkeys() {
    global g_registerDefaultHotkeys
    if !g_registerDefaultHotkeys
        return

    Hotkey("F1", (*) => StartMode("balcony"))
    Hotkey("F2", (*) => StartMode("bank_basic"))
    Hotkey("F3", (*) => StartMode("bank_loot"))
    Hotkey("F4", (*) => StartMode("bank_always"))
    Hotkey("F5", (*) => StartMode("hold_click"))
    Hotkey("F7", (*) => StopAll())
    Hotkey("F9", (*) => ExitApp())
}

; ---------------- Loops ----------------

BalconyLoop(id) {
    global runningMode, runId
    while (runId = id && runningMode = "balcony") {
        rand := Random(250, 2001)
        Sleep(rand)
        Send("{p}")
        Sleep(1001)
        Send("{2}")
        Sleep(1001)
        Send("{RButton down}")
        Sleep(1001)
        Send("{RButton up}")
        Sleep(3001)
        Send("{c}")
        Sleep(1001)
        Send("{p}")
        Sleep(75001)
    }
}

BankRoofCleanLoop(id) {
    global runningMode, runId
    while (runId = id && runningMode = "bank_basic") {
        start := A_TickCount
        while (runId = id && runningMode = "bank_basic" && A_TickCount - start < 40000) {
            rand := Random(0, 20)
            DllCall("Sleep", "UInt", rand)
            Send("{LButton}")
            Sleep(10)
            Send("{g}")
            Sleep(100)
        }
        if (runId != id || runningMode != "bank_basic")
            break
        CleanUpZombies()
        Sleep(2000)
        CleanUpZombies()
        Sleep(12000)
    }
}

BankRoofLootLoop(id) {
    global runningMode, runId
    while (runId = id && runningMode = "bank_loot") {
        start := A_TickCount
        walked20 := false, walked35 := false
        while (runId = id && runningMode = "bank_loot" && A_TickCount - start < 40000) {
            rand := Random(0, 20)
            DllCall("Sleep", "UInt", rand)
            Send("{LButton}")
            Sleep(10)
            Send("{g}")
            Sleep(100)
            elapsed := A_TickCount - start
            if (!walked20 && elapsed >= 20000 && elapsed < 21000) {
                WalkForwardAndBack()
                walked20 := true
            }
            if (!walked35 && elapsed >= 35000 && elapsed < 36000) {
                WalkForwardAndBack()
                walked35 := true
            }
        }
        if (runId != id || runningMode != "bank_loot")
            break
        CleanUpZombies()
        Sleep(2000)
        CleanUpZombies()
        Sleep(12000)
    }
}

BankRoofAlwaysLoop(id) {
    global runningMode, runId
    while (runId = id && runningMode = "bank_always") {
        rand := Random(0, 20)
        DllCall("Sleep", "UInt", rand)
        Send("{LButton}")
        Sleep(10)
        Send("{g}")
        Sleep(90) ; ~120ms per cycle
    }
}

HoldClickLoop(id) {
    global runningMode, runId
    Send("{LButton down}")
    while (runId = id && runningMode = "hold_click") {
        Sleep(100) ; light yield
    }
    Send("{LButton up}")
}

; ---------------- Helpers ----------------

WalkForwardAndBack() {
    Send("{W down}")
    Sleep(500)
    Send("{W up}")
    Sleep(50)
    Send("{S down}")
    Sleep(600)
    Send("{S up}")
    Sleep(50)
}

CleanUpZombies() {
    Loop 5 {
        Send("{LButton}")
        Sleep(50)
    }
}

; ---------------- Dispatch ----------------

RegisterDefaultHotkeys()

if (g_autostartMode != "" && ModeHandlers.Has(g_autostartMode)) {
    SetTimer(() => StartMode(g_autostartMode), -10)
}
