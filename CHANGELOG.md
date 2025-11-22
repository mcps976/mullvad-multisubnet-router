# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-23

### Added
- Initial release
- Automatic route management for multiple subnets while using Mullvad VPN
- LaunchAgent for background execution
- Configuration-based setup for easy customization
- Comprehensive documentation and examples
- Quick install script
- Support for macOS 13+ (Ventura, Sonoma, Sequoia, Tahoe)

### Features
- Checks every 60 seconds for Mullvad VPN connection
- Automatically adds routes for configured local subnets
- Runs silently in background
- Survives system reboots
- Zero-configuration after initial setup
- Minimal resource usage

### Documentation
- Complete README with installation guide
- Network topology examples
- Troubleshooting guide
- Contributing guidelines
- MIT License

## [Unreleased]

### Planned
- GUI configuration tool
- Support for dynamic gateway detection
- Enhanced logging options
- Homebrew formula for easier installation
- IPv6 support
- Configuration validation script
