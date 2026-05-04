#Requires AutoHotkey v2.0
#SingleInstance Force

; We only include the target file to avoid full framework initialization
#Include %A_ScriptDir%\GUI_Shared.ahk

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

try {
    stdout.WriteLine("Starting tests for QuotePathIfNeeded...")

    ; Test 1: Empty string
    AssertEqual("", QuotePathIfNeeded(""), "Should return empty string for empty input")

    ; Test 2: Normal path without spaces
    AssertEqual("C:\path\to\file.exe", QuotePathIfNeeded("C:\path\to\file.exe"), "Should not quote path without spaces")

    ; Test 3: Path with spaces
    AssertEqual('"C:\Program Files\App\app.exe"', QuotePathIfNeeded("C:\Program Files\App\app.exe"), "Should quote path with spaces")

    ; Test 4: Path with spaces, already fully quoted
    AssertEqual('"C:\Program Files\App\app.exe"', QuotePathIfNeeded('"C:\Program Files\App\app.exe"'), "Should not double-quote an already quoted path")

    ; Test 5: Path with spaces, quoted only at the start (edge case based on current logic)
    AssertEqual('"C:\Program Files\App\app.exe', QuotePathIfNeeded('"C:\Program Files\App\app.exe'), "Should not double-quote if starting quote is present (current logic)")

    ; Test 6: Path with spaces, quoted only at the end (edge case based on current logic)
    AssertEqual('C:\Program Files\App\app.exe"', QuotePathIfNeeded('C:\Program Files\App\app.exe"'), "Should not double-quote if ending quote is present (current logic)")

    ; Test 7: String with only spaces
    AssertEqual('"   "', QuotePathIfNeeded("   "), "Should quote a string containing only spaces")

    ; Final Results
    stdout.WriteLine("---")
    stdout.WriteLine("Tests Passed: " . testsPassed)
    stdout.WriteLine("Tests Failed: " . testsFailed)

} catch as e {
    stdout.WriteLine("Test execution failed with error: " . e.Message)
    testsFailed++
}

if (testsFailed > 0) {
    ExitApp(1)
}

ExitApp(0)
