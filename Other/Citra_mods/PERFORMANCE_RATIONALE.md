# Performance Optimization: Disable Batch Lines

**Change:** Added `SetBatchLines, -1` to the auto-execute section of `Citra_3DS_Manager.ahk`.

**Why:** By default, AutoHotkey v1 uses `SetBatchLines, 20`, which makes the script sleep for 10ms after every 20 lines of execution to avoid monopolizing the CPU. This behavior, while friendly to single-core systems of the past, introduces significant latency in loops and string processing tasks.

**Impact:** `SetBatchLines, -1` disables this sleep behavior, allowing the script to run as fast as possible. This is particularly effective for:
- `Loop, Read` (file reading)
- `Loop, Files` (file scanning)
- String manipulation (RegEx, parsing)

**Measurement Note:** Due to the current Linux environment lacking a Windows execution compatibility layer (Wine) for AutoHotkey, a direct runtime benchmark could not be performed. However, this is a standard and well-documented optimization for AHK v1 scripts, with expected speedups of 100% or more in tight loops.
