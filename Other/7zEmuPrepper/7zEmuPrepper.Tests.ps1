$ErrorActionPreference = 'Stop'
. $PSScriptRoot\7zEmuPrepper.ps1

Describe 'Find-LaunchFile' {
    BeforeEach {
        $testDir = "TestDrive:\ArchiveContent"
        New-Item -ItemType Directory -Path $testDir -Force | Out-Null
    }

    AfterEach {
        Remove-Item -Path "TestDrive:\ArchiveContent\*" -Recurse -Force -ErrorAction SilentlyContinue
    }

    It 'finds a file directly in the extraction directory' {
        New-Item -ItemType File -Path "TestDrive:\ArchiveContent\Game.iso" | Out-Null

        $result = Find-LaunchFile -dir "TestDrive:\ArchiveContent" -extensions @('.iso')

        $result | Should -Not -BeNullOrEmpty
        $result | Should -Match 'Game\.iso$'
    }

    It 'finds a file in a subdirectory of the extraction directory (edge case)' {
        $subDir = "TestDrive:\ArchiveContent\SubFolder"
        New-Item -ItemType Directory -Path $subDir | Out-Null
        New-Item -ItemType File -Path "$subDir\Game.iso" | Out-Null

        $result = Find-LaunchFile -dir "TestDrive:\ArchiveContent" -extensions @('.iso')

        $result | Should -Not -BeNullOrEmpty
        $result | Should -Match 'Game\.iso$'
    }

    It 'returns null if no matching extension is found' {
        New-Item -ItemType File -Path "TestDrive:\ArchiveContent\Game.txt" | Out-Null

        $result = Find-LaunchFile -dir "TestDrive:\ArchiveContent" -extensions @('.iso', '.bin')

        $result | Should -BeNullOrEmpty
    }

    It 'prioritizes extensions in the order they are provided' {
        New-Item -ItemType File -Path "TestDrive:\ArchiveContent\Game.bin" | Out-Null
        New-Item -ItemType File -Path "TestDrive:\ArchiveContent\Game.iso" | Out-Null

        # Should pick .iso first because it's first in the array
        $result = Find-LaunchFile -dir "TestDrive:\ArchiveContent" -extensions @('.iso', '.bin')

        $result | Should -Match '\.iso$'
    }
}

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