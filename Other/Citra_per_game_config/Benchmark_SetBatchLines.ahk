#NoEnv
#SingleInstance Force

; Benchmark for SetBatchLines
; This script compares the performance of the default SetBatchLines (10ms)
; versus the optimized SetBatchLines, -1.

Iterations := 200000

; --- Test 1: Default (10ms) ---
SetBatchLines, 10ms
Start1 := A_TickCount
Loop, %Iterations%
{
    var := "The quick brown fox jumps over the lazy dog"
    StringReplace, var, var, o, 0, All
    StringReplace, var, var, e, 3, All
}
Time1 := A_TickCount - Start1

; --- Test 2: Optimized (-1) ---
SetBatchLines, -1
Start2 := A_TickCount
Loop, %Iterations%
{
    var := "The quick brown fox jumps over the lazy dog"
    StringReplace, var, var, o, 0, All
    StringReplace, var, var, e, 3, All
}
Time2 := A_TickCount - Start2

; Report results
Improvement := Round((Time1 - Time2) / Time1 * 100, 1)
MsgBox, Performance Benchmark Results:`n`nDefault (10ms): %Time1% ms`nOptimized (-1): %Time2% ms`n`nSpeed Improvement: %Improvement%`%
