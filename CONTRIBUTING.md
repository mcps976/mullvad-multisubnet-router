# Contributing to Mullvad VPN Multi-Subnet Router

Thank you for your interest in contributing! This project welcomes contributions from the community.

## How to Contribute

### Reporting Issues

- Check if the issue already exists
- Include your macOS version
- Include your Mullvad VPN app version
- Provide clear steps to reproduce the problem
- Include relevant log output from `/tmp/mullvad-routes.error.log`

### Suggesting Enhancements

- Open an issue describing the enhancement
- Explain why it would be useful
- Provide examples of how it would work

### Code Contributions

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Test thoroughly on your system
5. Commit with clear messages (`git commit -m 'Add amazing feature'`)
6. Push to your branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Testing Checklist

Before submitting a PR, please verify:

- [ ] Script runs without errors
- [ ] Routes are added correctly
- [ ] Routes are removed when VPN disconnects
- [ ] LaunchAgent loads successfully
- [ ] No syntax errors in bash script
- [ ] No syntax errors in plist file
- [ ] Documentation is updated if needed
- [ ] Works on at least one version of macOS

### Code Style

- Use descriptive variable names
- Comment complex logic
- Follow existing code formatting
- Keep functions focused and simple
- Use shellcheck for bash scripts

### Documentation

- Update README.md for user-facing changes
- Add inline comments for complex code
- Include examples for new features
- Update troubleshooting section if relevant

## Development Setup

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/mullvad-multisubnet-router.git

# Create a branch
cd mullvad-multisubnet-router
git checkout -b my-feature

# Make changes and test
sudo ./mullvad-local-routes.sh

# Commit and push
git add .
git commit -m "Description of changes"
git push origin my-feature
```

## Questions?

Feel free to open an issue for any questions about contributing!

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
