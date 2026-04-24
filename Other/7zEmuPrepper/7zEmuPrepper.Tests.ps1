$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Get-Item "$here/7zEmuPrepper.ps1").FullName

Describe "Normalize-Extensions" {
    BeforeAll {
        . $sut
    }

    It "Adds a dot to a single extension without one" {
        Normalize-Extensions "iso" | Should -Be ".iso"
    }

    It "Preserves a dot if already present" {
        Normalize-Extensions ".bin" | Should -Be ".bin"
    }

    It "Handles multiple comma-separated extensions" {
        $result = Normalize-Extensions "iso,.bin,zip"
        $result.Count | Should -Be 3
        $result[0] | Should -Be ".iso"
        $result[1] | Should -Be ".bin"
        $result[2] | Should -Be ".zip"
    }

    It "Trims whitespace from extensions" {
        $result = Normalize-Extensions "  iso  ,  .bin  "
        $result.Count | Should -Be 2
        $result[0] | Should -Be ".iso"
        $result[1] | Should -Be ".bin"
    }

    It "Ignores empty extensions in the list" {
        $result = Normalize-Extensions "iso,,.bin"
        $result.Count | Should -Be 2
        $result[0] | Should -Be ".iso"
        $result[1] | Should -Be ".bin"
    }

    It "Throws an error if the extension string is empty" {
        { Normalize-Extensions "" } | Should -Throw "No launch extensions provided."
    }

    It "Throws an error if the extension string contains only whitespace" {
        { Normalize-Extensions "   " } | Should -Throw "No launch extensions provided."
    }

    It "Throws an error if the extension string contains only commas" {
        { Normalize-Extensions ",,," } | Should -Throw "No launch extensions provided."
    }
}
