#Requires AutoHotkey v2.0

; TestKit - shared assertions and exit-code reporting for tests/*_Test.ahk

global testsPassed := 0
global testsFailed := 0
global testOut := FileOpen("*", "w `n")

; An uncaught error would open a dialog and stall CI until its timeout
OnError(ReportUncaught)

ReportUncaught(err, mode) {
    global testOut
    testOut.WriteLine("ERROR: " . err.Message . " (line " . err.Line . ")")
    testOut.Close()
    ExitApp(1)
}

AssertEqual(expected, actual, context) {
    global testsPassed, testsFailed, testOut
    expectedStr := TestValueToString(expected)
    actualStr := TestValueToString(actual)
    if (expectedStr == actualStr) {
        testsPassed++
        testOut.WriteLine("PASS: " . context)
    } else {
        testsFailed++
        testOut.WriteLine("FAIL: " . context . " - Expected '" . expectedStr . "', but got '" . actualStr . "'")
    }
}

TestValueToString(value) {
    if !IsObject(value)
        return value
    if (Type(value) == "Array") {
        str := "["
        for v in value
            str .= TestValueToString(v) . ", "
        return RTrim(str, ", ") . "]"
    }
    return Type(value)
}

FinishTests() {
    global testsPassed, testsFailed, testOut
    testOut.WriteLine("---")
    testOut.WriteLine("Tests Passed: " . testsPassed)
    testOut.WriteLine("Tests Failed: " . testsFailed)
    testOut.Close()
    ExitApp(testsFailed > 0 ? 1 : 0)
}
