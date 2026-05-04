#Requires AutoHotkey v2.0
#SingleInstance Force

#Include %A_ScriptDir%\..\Lib\v2\AHK_Common.ahk
#Include %A_ScriptDir%\..\Lib\v2\WindowManager.ahk

InitScript(false, false, false) ; disable UIA, Admin, and optimization for the test

; Setup testing output
stdout := FileOpen("*", "w `n")
testsPassed := 0
testsFailed := 0

AssertEqual(expected, actual, context) {
    global testsPassed, testsFailed, stdout
    if (expected == actual) {
        testsPassed++
        stdout.WriteLine("PASS: " . context)
    } else {
        testsFailed++
        stdout.WriteLine("FAIL: " . context . " - Expected '" . expected . "', but got '" . actual . "'")
    }
}

class MockSystemWindowAPI {
    __New(monitors) {
        this.monitors := monitors
    }

    MonitorGetCount() {
        return this.monitors.Length
    }

    MonitorGet(N, &Left, &Top, &Right, &Bottom) {
        if (N < 1 || N > this.monitors.Length)
            return false
        mon := this.monitors[N]
        Left := mon.l
        Top := mon.t
        Right := mon.r
        Bottom := mon.b
        return true
    }
}

try {
    stdout.WriteLine("Starting GetMonitorAtPos tests...")

    ; Test Set 1: Single Monitor (0,0 to 1920,1080)
    mon1 := {l: 0, t: 0, r: 1920, b: 1080}
    apiSingle := MockSystemWindowAPI([mon1])

    AssertEqual(1, GetMonitorAtPos(960, 540, apiSingle), "Single monitor - Center")
    AssertEqual(1, GetMonitorAtPos(0, 0, apiSingle), "Single monitor - Top Left edge")
    AssertEqual(1, GetMonitorAtPos(1920, 1080, apiSingle), "Single monitor - Bottom Right edge")
    AssertEqual(-1, GetMonitorAtPos(-1, 540, apiSingle), "Single monitor - Out of bounds Left")
    AssertEqual(-1, GetMonitorAtPos(1921, 540, apiSingle), "Single monitor - Out of bounds Right")
    AssertEqual(-1, GetMonitorAtPos(960, -1, apiSingle), "Single monitor - Out of bounds Top")
    AssertEqual(-1, GetMonitorAtPos(960, 1081, apiSingle), "Single monitor - Out of bounds Bottom")

    ; Test Set 2: Multiple Monitors
    ; Mon 1: Primary 1920x1080 (0,0 to 1920,1080)
    ; Mon 2: Left 1080x1920 (-1080,0 to 0,1920)
    ; Mon 3: Right 1920x1080 (1920,0 to 3840,1080)
    ; Mon 4: Top 1920x1080 (0,-1080 to 1920,0)
    mon_multi_1 := {l: 0, t: 0, r: 1920, b: 1080}
    mon_multi_2 := {l: -1080, t: 0, r: 0, b: 1920}
    mon_multi_3 := {l: 1920, t: 0, r: 3840, b: 1080}
    mon_multi_4 := {l: 0, t: -1080, r: 1920, b: 0}
    apiMulti := MockSystemWindowAPI([mon_multi_1, mon_multi_2, mon_multi_3, mon_multi_4])

    AssertEqual(1, GetMonitorAtPos(960, 540, apiMulti), "Multi monitor - Primary Center")
    AssertEqual(2, GetMonitorAtPos(-500, 500, apiMulti), "Multi monitor - Left Monitor")
    AssertEqual(3, GetMonitorAtPos(2500, 500, apiMulti), "Multi monitor - Right Monitor")
    AssertEqual(4, GetMonitorAtPos(960, -500, apiMulti), "Multi monitor - Top Monitor")

    ; Edge case overlapping bounds (falls to first match)
    AssertEqual(1, GetMonitorAtPos(0, 0, apiMulti), "Multi monitor - Origin overlapping")
    AssertEqual(1, GetMonitorAtPos(1920, 500, apiMulti), "Multi monitor - Border overlapping Primary/Right")

    ; Out of bounds in multi-monitor setup
    AssertEqual(-1, GetMonitorAtPos(960, 2000, apiMulti), "Multi monitor - Out of bounds Bottom")
    AssertEqual(-1, GetMonitorAtPos(-2000, 500, apiMulti), "Multi monitor - Out of bounds Far Left")

    ; Test Set 3: Zero Monitors
    apiZero := MockSystemWindowAPI([])
    AssertEqual(-1, GetMonitorAtPos(0, 0, apiZero), "Zero monitors - Should return -1")

    ; Final Results
    stdout.WriteLine("---")
    stdout.WriteLine("Tests Passed: " . testsPassed)
    stdout.WriteLine("Tests Failed: " . testsFailed)

} finally {
    ; No teardown needed
}

if (testsFailed > 0) {
    ExitApp(1)
}

ExitApp(0)
