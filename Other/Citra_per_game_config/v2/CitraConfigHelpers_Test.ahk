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

TestSetKey() {
    global stdout
    stdout.WriteLine("Running TestSetKey...")

    ; Test 1: Add new key
    content := "key1=value1"
    result := SetKey(content, "key2", "value2")
    AssertEqual(result, "key1=value1`nkey2=value2", "SetKey appends new key")

    ; Test 2: Update existing key
    content := "key1=value1`nkey2=old_value"
    result := SetKey(content, "key2", "new_value")
    AssertEqual(result, "key1=value1`nkey2=new_value", "SetKey updates existing key")

    ; Test 3: Update key with special regex characters
    content := "my.key[1]=old"
    result := SetKey(content, "my.key[1]", "new")
    AssertEqual(result, "my.key[1]=new", "SetKey escapes special regex characters in key")

    ; Test 4: Add to empty config
    content := ""
    result := SetKey(content, "key", "value")
    AssertEqual(result, "`nkey=value", "SetKey handles empty config")

    ; Test 5: Handle spaces before equals sign
    content := "key    = old"
    result := SetKey(content, "key", "new")
    AssertEqual(result, "key=new", "SetKey handles spaces before equals sign")
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

TestReplaceInFile()
TestSetKey()

stdout.WriteLine("Tests Passed: " . testsPassed)
stdout.WriteLine("Tests Failed: " . testsFailed)

if (testsFailed > 0)
    ExitApp(1)
ExitApp(0)
