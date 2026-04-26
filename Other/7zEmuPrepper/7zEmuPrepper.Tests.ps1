$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $scriptDir '7zEmuPrepper.ps1') -SevenZipPath 'mock' -EmulatorPath 'mock' -ExtractionPath 'mock' -ArchivePath 'mock' -LaunchExtensions 'mock'

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
