# Repository Structure

```
mullvad-multisubnet-router/
├── README.md                           # Main documentation
├── LICENSE                             # MIT License
├── CHANGELOG.md                        # Version history
├── CONTRIBUTING.md                     # Contribution guidelines
├── EXAMPLES.md                         # Network configuration examples
├── .gitignore                          # Git ignore rules
├── mullvad-local-routes.sh            # Main routing script
├── com.mullvad.local-routes.plist     # LaunchAgent configuration
└── install.sh                          # Quick installation script
```

## File Descriptions

### Core Files

**mullvad-local-routes.sh**
- The main bash script that manages routes
- Configurable via variables at the top of the file
- Runs every 60 seconds via LaunchAgent
- Checks for Mullvad VPN connection and adds routes

**com.mullvad.local-routes.plist**
- LaunchAgent property list file
- Configures automatic execution via macOS launchd
- Sets execution interval and logging paths

### Documentation

**README.md**
- Complete project documentation
- Installation instructions
- Configuration guide
- Troubleshooting section
- Network topology examples

**EXAMPLES.md**
- Pre-configured network examples
- Common home lab setups
- Enterprise-style configurations
- How to find your network settings

**CHANGELOG.md**
- Version history
- Feature additions
- Bug fixes
- Upcoming features

**CONTRIBUTING.md**
- Guidelines for contributors
- Code style requirements
- Testing checklist
- Development setup

### Automation

**install.sh**
- Automated installation script
- Checks prerequisites
- Configures sudo permissions
- Installs and loads LaunchAgent
- Verifies installation

### Configuration

**.gitignore**
- Prevents committing personal configurations
- Excludes log files and system files

**LICENSE**
- MIT License terms

## Quick Start

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/mullvad-multisubnet-router.git
   cd mullvad-multisubnet-router
   ```

2. **Configure the script:**
   ```bash
   nano mullvad-local-routes.sh
   # Edit LOCAL_GATEWAY and LOCAL_SUBNETS
   ```

3. **Run the installer:**
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

## For GitHub Users

### To Use This Project

1. Fork or clone the repository
2. Edit `mullvad-local-routes.sh` with your network settings
3. Run `install.sh` or follow manual installation in README.md
4. Star ⭐ the repo if you find it useful!

### To Contribute

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

See CONTRIBUTING.md for detailed guidelines.

## Support

- **Issues:** Use GitHub Issues for bug reports
- **Questions:** Open a GitHub Discussion or Issue
- **Security:** Email security concerns (don't post publicly)

## Project Status

**Current Version:** 1.0.0
**Status:** Active development
**Tested On:** macOS 13.x - 26.x (Tahoe)

## Credits

Created to solve the multi-subnet limitation of Mullvad VPN's "Local Network Sharing" feature on macOS.
