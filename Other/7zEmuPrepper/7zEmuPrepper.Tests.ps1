$ErrorActionPreference = 'Stop'
. $PSScriptRoot\7zEmuPrepper.ps1

Describe "7zEmuPrepper" {
    Context "Validate-Path" {
        It "Passes when -File path exists" {
            New-Item -ItemType File -Path "TestDrive:\mockfile.txt" | Out-Null
            { Validate-Path -path "TestDrive:\mockfile.txt" -File -name "TestFile" } | Should -Not -Throw
        }
        It "Throws when -File path does not exist" {
            { Validate-Path -path "TestDrive:\missingfile.txt" -File -name "TestFile" } | Should -Throw "TestFile not found: TestDrive:\missingfile.txt"
        }
        It "Passes when -Dir path exists" {
            New-Item -ItemType Directory -Path "TestDrive:\mockdir" | Out-Null
            { Validate-Path -path "TestDrive:\mockdir" -Dir -name "TestDir" } | Should -Not -Throw
        }
        It "Throws when -Dir path does not exist" {
            { Validate-Path -path "TestDrive:\missingdir" -Dir -name "TestDir" } | Should -Throw "TestDir not found: TestDrive:\missingdir"
        }
        It "Throws when -File expects leaf but gets container" {
            New-Item -ItemType Directory -Path "TestDrive:\mockdir_as_file" | Out-Null
            { Validate-Path -path "TestDrive:\mockdir_as_file" -File -name "TestFile" } | Should -Throw "TestFile not found: TestDrive:\mockdir_as_file"
        }
    }
}
