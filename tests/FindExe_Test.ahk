#Requires AutoHotkey v2.0
#SingleInstance Force

#Include %A_ScriptDir%\..\Lib\v2\AHK_Common.ahk

InitScript(false, false, false) ; disable UIA, Admin, and optimization for the test

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

; Setup Mock Environment
originalPath := EnvGet("PATH")
testBaseDir := A_Temp . "\FindExe_Tests_" . A_TickCount

DirCreate(testBaseDir)
DirCreate(testBaseDir . "\PathDir1")
DirCreate(testBaseDir . "\PathDir2")
DirCreate(testBaseDir . "\FallbackDir")

; Create dummy files
FileAppend("", testBaseDir . "\PathDir2\tool.exe")
FileAppend("", testBaseDir . "\FallbackDir\fbtool.exe")
FileAppend("", testBaseDir . "\direct.exe")

mockPath := testBaseDir . "\PathDir1;" . testBaseDir . "\PathDir2"
EnvSet("PATH", mockPath)

try {
    stdout.WriteLine("Starting tests...")

    ; Test 1: Direct file path
    directPath := testBaseDir . "\direct.exe"
    AssertEqual(directPath, FindExe(directPath), "Should return the exact path if it exists")

    ; Test 2: Found in PATH
    AssertEqual(testBaseDir . "\PathDir2\tool.exe", FindExe("tool.exe"), "Should resolve tool.exe from PATH")

    ; Test 3: Not in PATH, found in fallback
    fallbacks := [testBaseDir . "\FallbackDir\fbtool.exe"]
    AssertEqual(testBaseDir . "\FallbackDir\fbtool.exe", FindExe("fbtool.exe", fallbacks), "Should resolve fbtool.exe from fallbacks")

    ; Test 4: File not found anywhere
    AssertEqual("", FindExe("nonexistent.exe", [testBaseDir . "\FallbackDir\missing.exe"]), "Should return empty string if not found anywhere")

    ; Test 5: Empty PATH entries (should skip gracefully)
    EnvSet("PATH", ";;" . mockPath . ";;")
    AssertEqual(testBaseDir . "\PathDir2\tool.exe", FindExe("tool.exe"), "Should handle empty entries in PATH")

    ; MustGetExe Tests

    ; Test 6: MustGetExe success path
    AssertEqual(directPath, MustGetExe(directPath), "MustGetExe should return path if found")

    ; Test 7: MustGetExe failure path
    mockState := Map("msgBoxCalled", false, "exitAppCalled", false, "exitCode", "")

    mockMsgBox(msg) {
        mockState["msgBoxCalled"] := true
    }

    mockExitApp(code) {
        mockState["exitAppCalled"] := true
        mockState["exitCode"] := code
    }

    ; Attempt to find a non-existent file with no fallbacks
    try {
        MustGetExe("definitely_nonexistent.exe", [], mockMsgBox, mockExitApp)
    }

    AssertEqual(1, mockState["msgBoxCalled"], "MustGetExe should call MsgBox on failure")
    AssertEqual(1, mockState["exitAppCalled"], "MustGetExe should call ExitApp on failure")
    AssertEqual(1, mockState["exitCode"], "MustGetExe should exit with code 1 on failure")

    ; Final Results
    stdout.WriteLine("---")
    stdout.WriteLine("Tests Passed: " . testsPassed)
    stdout.WriteLine("Tests Failed: " . testsFailed)

} finally {
    ; Teardown
    EnvSet("PATH", originalPath)
    DirDelete(testBaseDir, true)
}

if (testsFailed > 0) {
    ExitApp(1)
}

ExitApp(0)
