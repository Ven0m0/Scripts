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

    AssertEqual(RegExEscape("normal"), "normal", "RegExEscape normal string")
    AssertEqual(RegExEscape("backslash\"), "backslash\\", "RegExEscape backslash")
    AssertEqual(RegExEscape("(parens)"), "\(parens\)", "RegExEscape parens")
    AssertEqual(RegExEscape("[brackets]"), "\[brackets\]", "RegExEscape brackets")
    AssertEqual(RegExEscape("{braces}"), "\{braces\}", "RegExEscape braces")
    AssertEqual(RegExEscape("dot.dot"), "dot\.dot", "RegExEscape dot")
    AssertEqual(RegExEscape("star*"), "star\*", "RegExEscape star")
    AssertEqual(RegExEscape("plus+"), "plus\+", "RegExEscape plus")
    AssertEqual(RegExEscape("question?"), "question\?", "RegExEscape question")
    AssertEqual(RegExEscape("pipe|pipe"), "pipe\|pipe", "RegExEscape pipe")
    AssertEqual(RegExEscape("^start"), "\^start", "RegExEscape caret")
    AssertEqual(RegExEscape("end$"), "end\$", "RegExEscape dollar")

    allSpecials := "\()[]{}?*+|^$."
    expectedAll := "\\\(\)\[\]\{\}\?\*\+\|\^\$\."
    AssertEqual(RegExEscape(allSpecials), expectedAll, "RegExEscape all special characters")
}

TestSetKey() {
    global stdout
    stdout.WriteLine("Running TestSetKey...")

    content := "key1=value1`nkey2 = value2`n[Section]`nkey.with.dot=val"

    ; Test 1: Update existing key
    result := SetKey(content, "key1", "new_val")
    AssertEqual(InStr(result, "key1=new_val") > 0, true, "SetKey updates existing key")
    AssertEqual(InStr(result, "key1=value1") == 0, true, "SetKey removes old value")

    ; Test 2: Update key with spaces in source
    result := SetKey(content, "key2", "new_val2")
    AssertEqual(InStr(result, "key2=new_val2") > 0, true, "SetKey updates key with spaces")

    ; Test 3: Add new key
    result := SetKey(content, "key3", "value3")
    AssertEqual(InStr(result, "key3=value3") > 0, true, "SetKey adds new key")

    ; Test 4: Update key with special regex characters
    result := SetKey(content, "key.with.dot", "new_dot_val")
    AssertEqual(InStr(result, "key.with.dot=new_dot_val") > 0, true, "SetKey updates key with dots")
    AssertEqual(InStr(result, "key.with.dot=val") == 0, true, "SetKey removes old value with dots")

    ; Test 5: Key with backslashes
    content2 := "path\to\file=exists`n"
    result := SetKey(content2, "path\to\file", "updated")
    AssertEqual(InStr(result, "path\to\file=updated") > 0, true, "SetKey updates key with backslashes")
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
TestReplaceInFile()

stdout.WriteLine("Tests Passed: " . testsPassed)
stdout.WriteLine("Tests Failed: " . testsFailed)

if (testsFailed > 0)
    ExitApp(1)
ExitApp(0)
