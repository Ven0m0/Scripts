; ============================================================================
; Test_CitraConfigHelpers.ahk
; Tests for CitraConfigHelpers.ahk functions
; ============================================================================

#Requires AutoHotkey v2.0

#Include "../CitraConfigHelpers.ahk"

global g_TestsPassed := 0
global g_TestsFailed := 0

AssertEqual(expected, actual, testName) {
    global g_TestsPassed, g_TestsFailed
    if (expected == actual) {
        g_TestsPassed++
        FileAppend("PASS: " . testName . "`n", "*")
    } else {
        g_TestsFailed++
        FileAppend("FAIL: " . testName . "`n  Expected: " . expected . "`n  Actual:   " . actual . "`n", "*")
    }
}

RunTests() {
    global g_TestsPassed, g_TestsFailed

    FileAppend("--- Running CitraConfigHelpers Tests ---`n", "*")

    ; Test RegExEscape
    Test_RegExEscape()

    ; Print summary
    FileAppend("`n--- Test Summary ---`n", "*")
    FileAppend("Passed: " . g_TestsPassed . "`n", "*")
    FileAppend("Failed: " . g_TestsFailed . "`n", "*")

    ExitApp(g_TestsFailed > 0 ? 1 : 0)
}

Test_RegExEscape() {
    FileAppend("Testing RegExEscape...`n", "*")

    ; Empty string
    AssertEqual("", RegExEscape(""), "Empty string")

    ; No special characters
    AssertEqual("hello world", RegExEscape("hello world"), "No special characters")
    AssertEqual("1234567890", RegExEscape("1234567890"), "Numbers only")
    AssertEqual("abc_def-ghi", RegExEscape("abc_def-ghi"), "Normal symbols")

    ; Individual special characters
    AssertEqual("\\", RegExEscape("\"), "Backslash")
    AssertEqual("\(", RegExEscape("("), "Open parenthesis")
    AssertEqual("\)", RegExEscape(")"), "Close parenthesis")
    AssertEqual("\[", RegExEscape("["), "Open bracket")
    AssertEqual("\]", RegExEscape("]"), "Close bracket")
    AssertEqual("\{", RegExEscape("{"), "Open brace")
    AssertEqual("\}", RegExEscape("}"), "Close brace")
    AssertEqual("\?", RegExEscape("?"), "Question mark")
    AssertEqual("\*", RegExEscape("*"), "Asterisk")
    AssertEqual("\+", RegExEscape("+"), "Plus sign")
    AssertEqual("\|", RegExEscape("|"), "Pipe")
    AssertEqual("\^", RegExEscape("^"), "Caret")
    AssertEqual("\$", RegExEscape("$"), "Dollar sign")
    AssertEqual("\.", RegExEscape("."), "Dot")

    ; Mixed characters and real-world examples
    AssertEqual("C:\\Path\\To\\File\.txt", RegExEscape("C:\Path\To\File.txt"), "Windows path")
    AssertEqual("\^\(hello\)\$", RegExEscape("^(hello)$"), "Anchored parens")
    AssertEqual("resolution_factor=1\.5", RegExEscape("resolution_factor=1.5"), "INI setting")
    AssertEqual("\[Renderer\]", RegExEscape("[Renderer]"), "INI section")
}

; Execute tests
if (A_LineFile == A_ScriptFullPath) {
    RunTests()
}
