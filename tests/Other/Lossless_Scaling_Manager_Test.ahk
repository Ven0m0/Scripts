#Requires AutoHotkey v2.0
#SingleInstance Force

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

#Include %A_ScriptDir%\..\..\Other\Lossless_Scaling_Manager.ahk

global mockProcessExistCalled := 0
global mockProcessExistArg := ""
global mockProcessExistResult := 0

global mockStartLSCalled := 0
global mockStopLSCalled := 0

MockProcessExist(exeName) {
    global mockProcessExistCalled, mockProcessExistArg, mockProcessExistResult
    mockProcessExistCalled++
    mockProcessExistArg := exeName
    return mockProcessExistResult
}

MockStartLS() {
    global mockStartLSCalled
    mockStartLSCalled++
}

MockStopLS() {
    global mockStopLSCalled
    mockStopLSCalled++
}

ResetMocks() {
    global mockProcessExistCalled := 0
    global mockProcessExistArg := ""
    global mockProcessExistResult := 0
    global mockStartLSCalled := 0
    global mockStopLSCalled := 0
}

try {
    stdout.WriteLine("Starting ToggleLS tests...")

    ; Test 1: Process exists, should call StopLS
    ResetMocks()
    mockProcessExistResult := 1234 ; some PID
    ToggleLS(MockProcessExist, MockStopLS, MockStartLS)
    AssertEqual(1, mockProcessExistCalled, "ToggleLS checks if process exists")
    AssertEqual("LosslessScaling.exe", mockProcessExistArg, "ToggleLS checks for LosslessScaling.exe")
    AssertEqual(1, mockStopLSCalled, "StopLS called when process exists")
    AssertEqual(0, mockStartLSCalled, "StartLS NOT called when process exists")

    ; Test 2: Process does NOT exist, should call StartLS
    ResetMocks()
    mockProcessExistResult := 0 ; 0 means process not found
    ToggleLS(MockProcessExist, MockStopLS, MockStartLS)
    AssertEqual(1, mockProcessExistCalled, "ToggleLS checks if process exists")
    AssertEqual("LosslessScaling.exe", mockProcessExistArg, "ToggleLS checks for LosslessScaling.exe")
    AssertEqual(0, mockStopLSCalled, "StopLS NOT called when process does not exist")
    AssertEqual(1, mockStartLSCalled, "StartLS called when process does not exist")

    ; Final Results
    stdout.WriteLine("---")
    stdout.WriteLine("Tests Passed: " . testsPassed)
    stdout.WriteLine("Tests Failed: " . testsFailed)
} catch Error as err {
    stdout.WriteLine("Test script threw an error: " . err.Message)
    testsFailed++
}

if (testsFailed > 0) {
    ExitApp(1)
}

ExitApp(0)
