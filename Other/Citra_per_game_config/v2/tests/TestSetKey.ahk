#Requires AutoHotkey v2.0
#Include ../CitraConfigHelpers.ahk

; Simple test framework
global testsPassed := 0
global testsFailed := 0

AssertEqual(expected, actual, testName) {
    global testsPassed, testsFailed
    if (expected == actual) {
        testsPassed++
        FileAppend("PASS: " . testName . "`n", "*")
    } else {
        testsFailed++
        FileAppend("FAIL: " . testName . "`n", "*")
        FileAppend("  Expected: " . expected . "`n", "*")
        FileAppend("  Actual:   " . actual . "`n", "*")
    }
}

; Test Setup
RunTests() {
    global testsPassed, testsFailed

    ; 1. Happy path: Key exists and is replaced
    content1 := "key1=value1`nkey2=value2"
    expected1 := "key1=new_value`nkey2=value2"
    AssertEqual(expected1, SetKey(content1, "key1", "new_value"), "Key exists")

    ; 2. Happy path: Key does not exist and is appended
    content2 := "key1=value1"
    expected2 := "key1=value1`nkey2=value2"
    AssertEqual(expected2, SetKey(content2, "key2", "value2"), "Key does not exist")

    ; 3. Edge case: Empty content
    content3 := ""
    expected3 := "`nkey1=value1"
    AssertEqual(expected3, SetKey(content3, "key1", "value1"), "Empty content")

    ; 4. Edge case: Key with surrounding spaces
    ; INI keys can have spaces before =. SetKey regex uses \s*=.*
    content4 := "key1 = value1"
    expected4 := "key1=new_value"
    AssertEqual(expected4, SetKey(content4, "key1", "new_value"), "Key with spaces before equals")

    ; 5. Edge case: Key containing regex special characters
    content5 := "key[1].test=value1"
    expected5 := "key[1].test=new_value"
    AssertEqual(expected5, SetKey(content5, "key[1].test", "new_value"), "Key with regex characters")

    ; 6. Edge case: Multiple identical keys (should only replace the first one)
    content6 := "key1=value1`nkey1=value2"
    expected6 := "key1=new_value`nkey1=value2"
    AssertEqual(expected6, SetKey(content6, "key1", "new_value"), "Duplicate keys")

    ; 7. Edge case: Key value is empty
    content7 := "key1="
    expected7 := "key1=new_value"
    AssertEqual(expected7, SetKey(content7, "key1", "new_value"), "Empty key value")

    ; 8. Edge case: Newline at end of string
    content8 := "key1=value1`n"
    expected8 := "key1=new_value`n"
    AssertEqual(expected8, SetKey(content8, "key1", "new_value"), "Trailing newline")

    ; Print Summary
    FileAppend("`nTest Summary: " . testsPassed . " passed, " . testsFailed . " failed.`n", "*")

    if (testsFailed > 0) {
        ExitApp(1)
    }
}

RunTests()
