# Quick Start Guide

Get up and running in 5 minutes.

## Prerequisites

- macOS 13.0 or later
- Mullvad VPN installed
- Multiple subnets in your network
- Terminal access

## Installation (Easy Way)

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/mullvad-multisubnet-router.git
cd mullvad-multisubnet-router

# 2. Edit configuration
nano mullvad-local-routes.sh
# Update LOCAL_GATEWAY and LOCAL_SUBNETS, then save (Ctrl+X, Y, Enter)

# 3. Run installer
chmod +x install.sh
./install.sh
```

Done! Connect to Mullvad and wait 60 seconds.

## Configuration

Edit these lines in `mullvad-local-routes.sh`:

```bash
# Your router/firewall IP
LOCAL_GATEWAY="192.168.1.1"

# Your other subnets
LOCAL_SUBNETS=(
    "192.168.10.0/24"
    "192.168.20.0/24"
)
```

### How to Find These Values

**Gateway:**
```bash
netstat -rn | grep default
```
Look for the IP address in the gateway column.

**Subnets:**
```bash
netstat -rn
```
Look for your local network ranges (192.168.x.x or 10.x.x.x).

## Testing

```bash
# Connect to Mullvad VPN

# Wait 60 seconds

# Check routes
netstat -rn | grep "192.168"

# Test connectivity
ping 192.168.20.10  # Replace with a device IP on another subnet
```

## Troubleshooting

**Routes not appearing?**
```bash
# Check logs
cat /tmp/mullvad-routes.error.log

# Check LaunchAgent
launchctl list | grep mullvad
```

**Permission denied errors?**
```bash
# Fix script permissions
sudo chmod 755 /usr/local/bin/mullvad-local-routes.sh
```

**Sudo prompts for password?**
```bash
# Configure passwordless sudo
sudo visudo
# Add: yourusername ALL=(ALL) NOPASSWD: /sbin/route
```

## Need More Help?

- **Full Documentation:** See README.md
- **Configuration Examples:** See EXAMPLES.md
- **Issues:** Open a GitHub issue

## Uninstall

```bash
launchctl unload ~/Library/LaunchAgents/com.mullvad.local-routes.plist
sudo rm /usr/local/bin/mullvad-local-routes.sh
rm ~/Library/LaunchAgents/com.mullvad.local-routes.plist
```
