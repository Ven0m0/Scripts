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
    step := 1
    NextStep() {
        if (runId != id || runningMode != "balcony") {
            ; Cleanup if aborted mid-sequence
            if (step > 4 && step <= 5) {
                Send("{RButton up}")
            }
            return
        }

        if (step == 1) {
            rand := Random(250, 2001)
            SetTimer(NextStep, -rand)
            step := 2
        } else if (step == 2) {
            Send("{p}")
            SetTimer(NextStep, -1001)
            step := 3
        } else if (step == 3) {
            Send("{2}")
            SetTimer(NextStep, -1001)
            step := 4
        } else if (step == 4) {
            Send("{RButton down}")
            SetTimer(NextStep, -1001)
            step := 5
        } else if (step == 5) {
            Send("{RButton up}")
            SetTimer(NextStep, -3001)
            step := 6
        } else if (step == 6) {
            Send("{c}")
            SetTimer(NextStep, -1001)
            step := 7
        } else if (step == 7) {
            Send("{p}")
            SetTimer(NextStep, -75001)
            step := 1
        }
    }
    NextStep()
}

BankRoofCleanLoop(id) {
    global runningMode, runId
    start := A_TickCount
    phase := "shoot"

    Tick() {
        if (runId != id || runningMode != "bank_basic")
            return

        if (phase == "shoot") {
            if (A_TickCount - start < 40000) {
                rand := Random(0, 20)
                if (rand > 0)
                    DllCall("Sleep", "UInt", rand)
                Send("{LButton}")
                Sleep(10)
                Send("{g}")
                SetTimer(Tick, -100)
            } else {
                phase := "cleanup1"
                CleanUpZombies()
                SetTimer(Tick, -2000)
            }
        } else if (phase == "cleanup1") {
            CleanUpZombies()
            phase := "cleanup2"
            SetTimer(Tick, -12000)
        } else if (phase == "cleanup2") {
            start := A_TickCount
            phase := "shoot"
            SetTimer(Tick, -10)
        }
    }
    Tick()
}

BankRoofLootLoop(id) {
    global runningMode, runId
    start := A_TickCount
    walked20 := false
    walked35 := false
    phase := "shoot"

    Tick() {
        if (runId != id || runningMode != "bank_loot") {
            ; Cleanup if aborted mid-sequence (WalkForwardAndBack could be holding W or S,
            ; but since it's synchronous and blocks, AHK thread is busy during it.
            ; The only thing we must clean up is if we were interrupted.)
            return
        }

        if (phase == "shoot") {
            elapsed := A_TickCount - start
            if (elapsed < 40000) {
                if (!walked20 && elapsed >= 20000 && elapsed < 21000) {
                    WalkForwardAndBack()
                    walked20 := true
                }
                if (!walked35 && elapsed >= 35000 && elapsed < 36000) {
                    WalkForwardAndBack()
                    walked35 := true
                }

                rand := Random(0, 20)
                if (rand > 0)
                    DllCall("Sleep", "UInt", rand)
                Send("{LButton}")
                Sleep(10)
                Send("{g}")
                SetTimer(Tick, -100)
            } else {
                phase := "cleanup1"
                CleanUpZombies()
                SetTimer(Tick, -2000)
            }
        } else if (phase == "cleanup1") {
            CleanUpZombies()
            phase := "cleanup2"
            SetTimer(Tick, -12000)
        } else if (phase == "cleanup2") {
            start := A_TickCount
            walked20 := false
            walked35 := false
            phase := "shoot"
            SetTimer(Tick, -10)
        }
    }
    Tick()
}

BankRoofAlwaysLoop(id) {
    global runningMode, runId

    Tick() {
        if (runId != id || runningMode != "bank_always")
            return

        rand := Random(0, 20)
        if (rand > 0)
            DllCall("Sleep", "UInt", rand)
        Send("{LButton}")
        Sleep(10)
        Send("{g}")
        SetTimer(Tick, -90)
    }
    Tick()
}

HoldClickLoop(id) {
    global runningMode, runId
    Send("{LButton down}")

    Tick() {
        if (runId != id || runningMode != "hold_click") {
            ; Since StopAll() already sends {LButton up}, we don't need to do it here
            ; UNLESS we are doing it via natural expiry, but this runs infinitely.
            ; StopAll() already handles cleanup, so we can just return.
            return
        }
        SetTimer(Tick, -100)
    }
    Tick()
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
