#!/bin/bash

###############################################################################
# Mullvad VPN Multi-Subnet Router - Quick Install Script
# 
# This script automates the installation process
###############################################################################

set -e  # Exit on error

SCRIPT_NAME="mullvad-local-routes.sh"
PLIST_NAME="com.mullvad.local-routes.plist"
INSTALL_PATH="/usr/local/bin/$SCRIPT_NAME"
LAUNCHAGENT_PATH="$HOME/Library/LaunchAgents/$PLIST_NAME"

echo "=========================================="
echo "Mullvad Multi-Subnet Router - Installer"
echo "=========================================="
echo ""

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ Error: This script only works on macOS"
    exit 1
fi

# Check if Mullvad is installed
if [ ! -d "/Applications/Mullvad VPN.app" ]; then
    echo "⚠️  Warning: Mullvad VPN app not found. Please install it first."
    echo "   Download from: https://mullvad.net/download/macos"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo "Step 1: Checking for required files..."

if [ ! -f "$SCRIPT_NAME" ]; then
    echo "❌ Error: $SCRIPT_NAME not found in current directory"
    echo "   Please run this script from the repository directory"
    exit 1
fi

if [ ! -f "$PLIST_NAME" ]; then
    echo "❌ Error: $PLIST_NAME not found in current directory"
    exit 1
fi

echo "✅ Files found"
echo ""

echo "Step 2: Configuration check..."
echo ""
echo "⚠️  IMPORTANT: Have you edited $SCRIPT_NAME with your network settings?"
echo "   You need to set:"
echo "   - LOCAL_GATEWAY (your router IP)"
echo "   - LOCAL_SUBNETS (your subnet list)"
echo ""
read -p "Have you configured the script? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "Please edit $SCRIPT_NAME first, then run this installer again."
    echo "See EXAMPLES.md for configuration examples."
    exit 1
fi
echo ""

echo "Step 3: Installing script to $INSTALL_PATH..."
sudo cp "$SCRIPT_NAME" "$INSTALL_PATH"
sudo chmod 755 "$INSTALL_PATH"
echo "✅ Script installed"
echo ""

echo "Step 4: Configuring passwordless sudo for route command..."
echo ""
USERNAME=$(whoami)
SUDOERS_LINE="$USERNAME ALL=(ALL) NOPASSWD: /sbin/route"

# Check if rule already exists
if sudo grep -q "$SUDOERS_LINE" /etc/sudoers 2>/dev/null; then
    echo "✅ Sudo rule already configured"
else
    echo "Adding sudo rule for $USERNAME..."
    echo "$SUDOERS_LINE" | sudo tee -a /etc/sudoers > /dev/null
    echo "✅ Sudo rule added"
fi
echo ""

echo "Step 5: Testing sudo configuration..."
if sudo -n route -n get default > /dev/null 2>&1; then
    echo "✅ Sudo configuration working"
else
    echo "❌ Sudo test failed - manual configuration needed"
    echo "   Run: sudo visudo"
    echo "   Add: $SUDOERS_LINE"
    exit 1
fi
echo ""

echo "Step 6: Installing LaunchAgent..."
mkdir -p "$HOME/Library/LaunchAgents"
cp "$PLIST_NAME" "$LAUNCHAGENT_PATH"
echo "✅ LaunchAgent file installed"
echo ""

echo "Step 7: Loading LaunchAgent..."
launchctl unload "$LAUNCHAGENT_PATH" 2>/dev/null || true
launchctl load "$LAUNCHAGENT_PATH"
echo "✅ LaunchAgent loaded"
echo ""

echo "Step 8: Verifying installation..."
if launchctl list | grep -q "local.mullvad.routes"; then
    echo "✅ LaunchAgent is running"
else
    echo "❌ LaunchAgent failed to load"
    exit 1
fi
echo ""

echo "Step 9: Testing (requires Mullvad to be connected)..."
if ifconfig utun6 > /dev/null 2>&1; then
    echo "✅ Mullvad is connected"
    echo "   Running script manually..."
    sudo "$INSTALL_PATH"
    echo "   Checking routes..."
    sleep 2
    if netstat -rn | grep -q "192.168\|10."; then
        echo "✅ Routes appear to be configured"
    else
        echo "⚠️  No routes detected - check your configuration"
    fi
else
    echo "⚠️  Mullvad not connected - skipping route test"
    echo "   Connect to Mullvad and wait 60 seconds to test"
fi
echo ""

echo "=========================================="
echo "✅ Installation Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Connect to Mullvad VPN (if not already)"
echo "2. Wait 60 seconds for routes to be added"
echo "3. Test connectivity: ping [device-on-other-subnet]"
echo ""
echo "Logs are available at:"
echo "  /tmp/mullvad-routes.log"
echo "  /tmp/mullvad-routes.error.log"
echo ""
echo "To uninstall, run:"
echo "  launchctl unload $LAUNCHAGENT_PATH"
echo "  sudo rm $INSTALL_PATH"
echo "  rm $LAUNCHAGENT_PATH"
echo ""
