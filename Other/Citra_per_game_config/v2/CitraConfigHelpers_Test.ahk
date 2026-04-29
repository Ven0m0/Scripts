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

    special := "\()[]{}?*+|^$."
    escaped := RegExEscape(special)
    expected := "\\\(\)\[\]\{\}\?\*\+\|\^\$\."
    AssertEqual(escaped, expected, "RegExEscape correctly escapes special characters")
}

TestSetKey() {
    global stdout
    stdout.WriteLine("Running TestSetKey...")

    content := "a=1`nb=2`nc=3"

    ; Replace first
    result := SetKey(content, "a", "10")
    AssertEqual(result, "a=10`nb=2`nc=3", "SetKey replaces first key")

    ; Replace middle
    result := SetKey(content, "b", "20")
    AssertEqual(result, "a=1`nb=20`nc=3", "SetKey replaces middle key")

    ; Replace last
    result := SetKey(content, "c", "30")
    AssertEqual(result, "a=1`nb=2`nc=30", "SetKey replaces last key")

    ; Add new
    result := SetKey(content, "d", "4")
    AssertEqual(result, "a=1`nb=2`nc=3`nd=4", "SetKey appends new key")
}

TestLoadConfig() {
    global stdout
    stdout.WriteLine("Running TestLoadConfig...")

    testFile := A_ScriptDir . "\test_load_config.txt"
    if FileExist(testFile)
        FileDelete(testFile)

    ; Test 1: Non-existent file
    result := LoadConfig(testFile)
    AssertEqual(result, "", "LoadConfig returns empty string for non-existent file")

    ; Test 2: Existing file
    FileAppend("test content", testFile)
    result := LoadConfig(testFile)
    AssertEqual(result, "test content", "LoadConfig reads existing file correctly")

    if FileExist(testFile)
        FileDelete(testFile)
}

TestSaveConfig() {
    global stdout
    stdout.WriteLine("Running TestSaveConfig...")

    testFile := A_ScriptDir . "\test_save_config.txt"
    bakFile := testFile . ".bak"

    if FileExist(testFile)
        FileDelete(testFile)
    if FileExist(bakFile)
        FileDelete(bakFile)

    ; Test 1: Save new file
    result := SaveConfig("content 1", testFile)
    AssertEqual(result, 1, "SaveConfig returns true on success")
    AssertEqual(FileRead(testFile), "content 1", "SaveConfig writes correct content")
    AssertEqual(FileExist(bakFile), "", "SaveConfig does not create backup if file didn't exist")

    ; Test 2: Save existing file (creates backup)
    result := SaveConfig("content 2", testFile)
    AssertEqual(result, 1, "SaveConfig returns true on overwrite")
    AssertEqual(FileRead(testFile), "content 2", "SaveConfig overwrites content")
    AssertEqual(FileRead(bakFile), "content 1", "SaveConfig creates backup of previous content")

    if FileExist(testFile)
        FileDelete(testFile)
    if FileExist(bakFile)
        FileDelete(bakFile)
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
TestSetKey()
TestLoadConfig()
TestSaveConfig()
TestReplaceInFile()

stdout.WriteLine("Tests Passed: " . testsPassed)
stdout.WriteLine("Tests Failed: " . testsFailed)

if (testsFailed > 0)
    ExitApp(1)
ExitApp(0)
