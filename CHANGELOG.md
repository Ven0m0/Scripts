# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- CONTRIBUTING.md - Comprehensive contribution guidelines
- CODE_OF_CONDUCT.md - Community standards and enforcement guidelines
- CHANGELOG.md - Version history tracking

### Changed
- Enhanced documentation structure across the repository

## [2.0.0] - 2025-12-17

### Added
- AutoHotkey v2.0 migration for 45+ scripts
- Dual library architecture (Lib/v1/ and Lib/v2/)
- AutoStartManager.ahk - Unified data-driven auto-fullscreen launcher
- AutoStartConfig.ini - Centralized emulator configuration
- GUI_Shared.ahk - Shared GUI framework for launchers
- Comprehensive v2 migration documentation in CLAUDE.md
- Enhanced CLAUDE.md with 1700+ lines of developer documentation
- GEMINI.md - Additional AI assistant instructions

### Changed
- Migrated all AFK macros to AutoHotkey v2 (Black Ops 6, Minecraft)
- Migrated all GUI scripts to v2 (GUI_PC, GUI_Laptop, GUI_Shared, WM)
- Migrated all Playnite launcher variants to v2 (4 scripts)
- Migrated utility scripts to v2 (ControllerQuit, Powerplan, Fullscreen, etc.)
- Updated CI/CD workflow for automatic v1/v2 version detection
- Improved README.md with enhanced structure and migration details

### Fixed
- Command injection vulnerability in YouTube downloader
- Command injection vulnerability in Spotify downloader
- Command injection vulnerability in combined YT/Spotify downloader
- Hardcoded user paths in Ryujinx_LDN.ahk using OneDrive environment variable
- Hardcoded user paths in RemotePlay_Whatever.ahk
- Missing mouse button release in AFK_Hold_Click.ahk

### Removed
- 9 duplicate auto-start scripts (consolidated into AutoStartManager)
- 3 duplicate fullscreen variants (unified into single implementation)
- 4 duplicate downloader draft files
- 7 deprecated auto-start v1 files
- 4 deprecated v1 utility files
- 1 deprecated Playnite_fullscreen/ directory

### Security
- Added input validation to prevent command injection in downloader scripts
- Fixed arbitrary command execution vulnerabilities

## [1.0.0] - 2025-11-19

### Added
- Initial release of Scripts repository
- Window management utilities (Fullscreen, Keys.ahk)
- Emulator automation scripts for 15+ emulators
- AFK macros for Black Ops 6 and Minecraft
- YouTube and Spotify downloader GUIs
- Citra 3DS mod manager and per-game configurations
- Playnite fullscreen automation
- Power plan automation
- Controller quit functionality
- 7zEmuPrepper integration
- Shared library framework (Lib/)
  - AHK_Common.ahk
  - WindowManager.ahk
  - AutoStartHelper.ahk
- GUI launchers for PC and Laptop configurations
- Robocopy wrapper scripts
- Documentation (README.md, CLAUDE.md)

### Features

#### Window Management
- Borderless fullscreen toggle (multi-monitor aware)
- Window snapping with Win+Arrow keys
- Always-on-top window management
- Multi-monitor detection and positioning

#### Emulator Support
- Auto-fullscreen for Citra, Yuzu, Ryujinx, RPCS4
- Bluestacks rotation automation
- Per-game configuration profiles for Citra
- Integration with Playnite launcher

#### Gaming Utilities
- AFK farming macros for Black Ops 6
- AFK fishing/farming for Minecraft
- Controller-based application quit
- Power plan switching based on game detection

#### Media Tools
- YouTube video/audio downloader with quality selection
- Spotify playlist/track downloader
- Combined media downloader GUI
- Integration with yt-dlp and spotdl

#### System Enhancement
- Comprehensive hotkey suite (file renaming, media control)
- Power plan automation
- Lossless scaling integration

## Version History Notes

### Breaking Changes in 2.0.0

- Scripts now require AutoHotkey v2.0.19+ for v2 scripts
- Legacy scripts still require AutoHotkey v1.1.37.02+
- Function call syntax changed from v1 command style to v2 function style
- Some auto-start scripts consolidated - use AutoStartManager.ahk instead

### Migration Path from 1.x to 2.x

1. Install AutoHotkey v2.0.19+
2. Update script includes to use Lib/v2/ for new scripts
3. For auto-start scripts, migrate to AutoStartManager.ahk + AutoStartConfig.ini
4. Update function calls from v1 syntax to v2 syntax
5. See CLAUDE.md for detailed migration guide

### Compatibility Notes

- Both v1 and v2 scripts are maintained for compatibility
- Legacy v1 scripts in Other/Citra_* and Other/Downloader/ remain functional
- Dual library architecture allows gradual migration
- CI/CD automatically detects and compiles correct version

## Links

- [Repository](https://github.com/Ven0m0/Scripts)
- [Issues](https://github.com/Ven0m0/Scripts/issues)
- [AutoHotkey Documentation](https://www.autohotkey.com/docs/)

## Contributors

- **Ven0m0** - Initial work and maintenance (ven0m0.wastaken@gmail.com)

---

**Note**: For detailed technical changes and development notes, see [CLAUDE.md](CLAUDE.md).
