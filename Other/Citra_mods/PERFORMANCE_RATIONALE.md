# Performance Optimization: Disable Batch Lines

**Change (legacy AHK v1 script):** Added `SetBatchLines, -1` to the auto-execute section of `Citra_3DS_Manager.ahk`.

**Why:** In AutoHotkey v1, the default setting is `SetBatchLines, 20`, which makes the script pause for 10ms after every 20 lines of code are executed to avoid monopolizing the CPU. This behavior, while friendly to single-core systems of the past, introduces significant latency in tight loops and string processing tasks.

**Impact (AHK v1):** `SetBatchLines, -1` disables this pause behavior in v1, allowing the script to run as fast as possible. This is particularly effective for:
- `Loop, Read` (file reading)
- `Loop, Files` (file scanning)
- String manipulation (RegEx, parsing)

**AHK v2 Note:** AutoHotkey v2 removed `SetBatchLines`; scripts already run at full speed by default. This optimization is therefore only relevant for legacy v1 versions of the script and should not be added to v2 code.

**Measurement Note:** Due to the current Linux environment lacking a Windows execution compatibility layer (Wine) for AutoHotkey, a direct runtime benchmark of the v1 behavior could not be performed. However, this is a standard and well-documented optimization for AHK v1 scripts, with expected speedups of 100% or more in tight loops.
