# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- GitHub Actions CI/CD workflows for automated testing and releases
- Automatic changelog generation using git-cliff
- Version file for semantic versioning
- Placeholder text in search interface
- Comprehensive README with installation and usage instructions

### Performance
- Caching system for tmux session data and TOML parsing (7x startup improvement)
- Lazy loading for saved sessions
- Optimized string processing and function calls

### Features
- Smart prioritization: Current client's session appears first
- Enhanced color coding: All attached sessions show in green
- Improved session management with better visual indicators

### Documentation
- Detailed installation instructions (install script + manual)
- Keyboard shortcuts reference
- Configuration examples
- Development and release guidelines

## [0.1.0] - 2024-12-25

### Added
- Initial release of hop - fast tmux session manager
- Fuzzy search with fzf integration
- Saved session templates in TOML format
- Session creation, renaming, detaching, and killing
- Color-coded session status indicators
- Random session name generation
- Basic CLI interface with keyboard shortcuts