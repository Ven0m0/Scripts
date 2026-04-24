#Requires AutoHotkey v2.0

global failures := 0

AssertEqual(expected, actual, testName) {
    global failures
    if (expected !== actual) {
        Print("FAILED: " . testName)
        Print("  Expected: >" . expected . "<")
        Print("  Actual:   >" . actual . "<")
        failures++
    } else {
        Print("PASSED: " . testName)
    }
}

Print(text) {
    FileAppend(text "`n", "*")
}

Test_QuotePathIfNeeded() {
    Print("Running Test_QuotePathIfNeeded...")

    ; Should add quotes to paths with spaces
    AssertEqual('"C:\Program Files\App\app.exe"', QuotePathIfNeeded('C:\Program Files\App\app.exe'), "Path with spaces")

    ; Should not add quotes if already quoted
    AssertEqual('"C:\Program Files\App\app.exe"', QuotePathIfNeeded('"C:\Program Files\App\app.exe"'), "Already quoted path with spaces")

    ; Should not add quotes to paths without spaces
    AssertEqual('C:\Tools\app.exe', QuotePathIfNeeded('C:\Tools\app.exe'), "Path without spaces")

    ; Should handle empty strings
    AssertEqual('', QuotePathIfNeeded(''), "Empty string")

    ; Should handle strings with only spaces
    AssertEqual('"   "', QuotePathIfNeeded('   '), "String with only spaces")

    ; Should handle strings that are just one space
    AssertEqual('" "', QuotePathIfNeeded(' '), "Single space")
}

Test_QuotePathIfNeeded()

if (failures > 0) {
    Print("`nTests failed: " . failures)
    ExitApp(1)
} else {
    Print("`nAll tests passed successfully.")
    ExitApp(0)
}

#Include %A_ScriptDir%\..\GUI_Shared.ahk
