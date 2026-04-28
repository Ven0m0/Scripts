#Requires AutoHotkey v2.0
#Include %A_ScriptDir%\CitraConfigHelpers.ahk

; Set up headless stdout for CI
stdout := FileOpen("*", "w `n")
testsPassed := 0
testsFailed := 0

AssertEqual(actual, expected, testName) {
    global testsPassed, testsFailed, stdout
    if (actual == expected) {
        testsPassed++
        stdout.WriteLine("PASS: " . testName)
    } else {
        testsFailed++
        stdout.WriteLine("FAIL: " . testName . " - Expected: '" . expected . "', Actual: '" . actual . "'")
    }
}

TestRegExEscape() {
    global stdout
    stdout.WriteLine("Running TestRegExEscape...")

    ; Test 1: Empty string
    AssertEqual(RegExEscape(""), "", "RegExEscape handles empty string")

    ; Test 2: No special characters
    AssertEqual(RegExEscape("hello"), "hello", "RegExEscape leaves alphanumeric characters unchanged")

    ; Test 3: Some special characters
    AssertEqual(RegExEscape("h.e*l+l?o"), "h\.e\*l\+l\?o", "RegExEscape escapes dot, star, plus, question mark")

    ; Test 4: Brackets and braces
    AssertEqual(RegExEscape("(hello)[world]{test}"), "\(hello\)\[world\]\{test\}", "RegExEscape escapes brackets and braces")

    ; Test 5: Caret, dollar, pipe, backslash
    AssertEqual(RegExEscape("^hello$|world\"), "\^hello\$\|world\\", "RegExEscape escapes caret, dollar, pipe, backslash")
}

TestReplaceInFile() {
    global stdout
    stdout.WriteLine("Running TestReplaceInFile...")

    testFile := A_ScriptDir . "\test_replace_file.txt"

    ; Setup: Create test file
    if FileExist(testFile)
        FileDelete(testFile)
    if FileExist(testFile . ".bak")
        FileDelete(testFile . ".bak")

    ; Test 1: File doesn't exist
    result := ReplaceInFile(testFile, "search", "replace")
    AssertEqual(result, 0, "ReplaceInFile returns false for non-existent file")

    ; Test 2: File is empty
    FileAppend("", testFile)
    result := ReplaceInFile(testFile, "search", "replace")
    AssertEqual(result, 0, "ReplaceInFile returns false for empty file")
    FileDelete(testFile)

    ; Test 3: Happy path
    FileAppend("hello world`nhello citra", testFile)
    result := ReplaceInFile(testFile, "hello", "goodbye")
    AssertEqual(result, 1, "ReplaceInFile returns true on success")

    ; Verify content
    content := FileRead(testFile)
    AssertEqual(content, "goodbye world`ngoodbye citra", "ReplaceInFile correctly replaces text")

    ; Test 4: Text not found (should succeed but make no changes)
    result := ReplaceInFile(testFile, "notfound", "replace")
    AssertEqual(result, 1, "ReplaceInFile returns true when text not found")

    ; Verify content remains unchanged
    content := FileRead(testFile)
    AssertEqual(content, "goodbye world`ngoodbye citra", "ReplaceInFile leaves content unchanged when text not found")

    ; Cleanup
    if FileExist(testFile)
        FileDelete(testFile)
    if FileExist(testFile . ".bak")
        FileDelete(testFile . ".bak")
}

TestRegExEscape()
TestReplaceInFile()

stdout.WriteLine("Tests Passed: " . testsPassed)
stdout.WriteLine("Tests Failed: " . testsFailed)

if (testsFailed > 0)
    ExitApp(1)
ExitApp(0)
