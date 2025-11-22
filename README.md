# Mullvad VPN Multi-Subnet Router for macOS

Automatically maintain access to your local network devices across multiple subnets while using Mullvad VPN on macOS.

## Problem Statement

Mullvad VPN's "Local Network Sharing" feature only works for devices on the **same subnet** as your Mac. If you have a multi-subnet home network (common with VLANs, separate IoT networks, or segmented server infrastructure), you lose access to devices on other subnets when connected to Mullvad VPN.

This tool solves that problem by automatically adding static routes for your specified local subnets, ensuring continuous access to all your local devices while maintaining VPN security for internet traffic.

## Features

- ✅ Automatic route management when Mullvad connects/disconnects
- ✅ Runs silently in the background via LaunchAgent
- ✅ Checks every 60 seconds and restores routes if needed
- ✅ Survives reboots (starts automatically at login)
- ✅ Configurable for any network topology
- ✅ Zero performance impact
- ✅ Works with macOS 13+ (Ventura, Sonoma, Sequoia, Tahoe)

## How It Works

1. A background script checks every 60 seconds if Mullvad VPN is connected
2. When connected, it adds static routes for your configured local subnets
3. Traffic to your local subnets bypasses the VPN tunnel and goes through your local gateway
4. All other traffic (internet) continues through the Mullvad VPN tunnel
5. Routes are automatically removed when Mullvad disconnects

## Requirements

- macOS 13.0 or later
- Mullvad VPN app installed
- Multiple subnets in your local network
- Basic terminal knowledge

## Installation

### Step 1: Download the Files

Clone this repository or download these two files:
- `mullvad-local-routes.sh`
- `com.mullvad.local-routes.plist`

### Step 2: Configure the Script

Edit `mullvad-local-routes.sh` and update these variables for your network:

```bash
# Your local gateway IP (usually your router/firewall)
LOCAL_GATEWAY="192.168.1.1"

# Your local subnets
LOCAL_SUBNETS=(
    "192.168.10.0/24"    # Example: Main LAN
    "192.168.20.0/24"    # Example: Server subnet
    "192.168.30.0/24"    # Example: IoT subnet
)
```

**Finding your gateway:** Run `netstat -rn | grep default` and look for your gateway IP.

**Finding your subnets:** Run `netstat -rn` and look for your local network ranges.

### Step 3: Install the Script

```bash
# Copy script to system location
sudo cp mullvad-local-routes.sh /usr/local/bin/

# Make it executable
sudo chmod 755 /usr/local/bin/mullvad-local-routes.sh

# Test it manually
sudo /usr/local/bin/mullvad-local-routes.sh
```

### Step 4: Configure Passwordless Sudo

The script needs to run `route` commands without password prompts.

```bash
# Edit sudoers file
sudo visudo
```

Add this line at the bottom (replace `YOUR_USERNAME` with your actual username):

```
YOUR_USERNAME ALL=(ALL) NOPASSWD: /sbin/route
```

**To find your username:** Run `whoami`

**In visudo:**
1. Press `o` to create a new line
2. Type the line above
3. Press `Esc`
4. Type `:wq` and press Enter

### Step 5: Install the LaunchAgent

```bash
# Copy LaunchAgent to your user LaunchAgents directory
cp com.mullvad.local-routes.plist ~/Library/LaunchAgents/

# Load the LaunchAgent
launchctl load ~/Library/LaunchAgents/com.mullvad.local-routes.plist

# Verify it's loaded
launchctl list | grep mullvad
```

You should see `local.mullvad.routes` in the output.

## Testing

### Test 1: Manual Script Execution

```bash
# Connect to Mullvad VPN first
# Then run the script
sudo /usr/local/bin/mullvad-local-routes.sh

# Check if routes were added
netstat -rn | grep "192.168"
```

You should see routes for your configured subnets pointing to your LOCAL_GATEWAY.

### Test 2: Automatic Route Restoration

```bash
# Delete a route (replace with your actual subnet)
sudo route delete -net 192.168.20.0/24

# Verify it's gone
netstat -rn | grep "192.168.20"

# Wait 65 seconds
sleep 65

# Check if it came back automatically
netstat -rn | grep "192.168.20"
```

The route should automatically reappear!

### Test 3: Connectivity

```bash
# Ping a device on another subnet (replace with your device IP)
ping 192.168.20.10
```

You should be able to reach devices on all configured subnets.

## Troubleshooting

### Routes not being added?

**Check LaunchAgent status:**
```bash
launchctl list | grep mullvad
cat /tmp/mullvad-routes.error.log
```

**Common issues:**
- Script permissions: Run `ls -l /usr/local/bin/mullvad-local-routes.sh` - should show `-rwxr-xr-x`
- Sudo configuration: Test with `sudo route -n get default` - should run without password prompt
- LaunchAgent not loaded: Reload with `launchctl unload` then `launchctl load`

### Routes disappear?

The script only maintains routes **while Mullvad VPN is connected**. When you disconnect from Mullvad, the routes are removed (this is by design - you don't need them without VPN).

### Mullvad interface not utun6?

Check your Mullvad interface name:
```bash
ifconfig | grep utun
```

Update the `VPN_INTERFACE` variable in the script if different.

### Still can't access local devices?

1. Verify Mullvad is connected: `ifconfig utun6`
2. Verify routes exist: `netstat -rn | grep "192.168"`
3. Check firewall rules on your router/firewall
4. Verify "Local Network Sharing" is enabled in Mullvad app

## Uninstallation

```bash
# Unload LaunchAgent
launchctl unload ~/Library/LaunchAgents/com.mullvad.local-routes.plist

# Remove files
rm ~/Library/LaunchAgents/com.mullvad.local-routes.plist
sudo rm /usr/local/bin/mullvad-local-routes.sh

# Remove sudoers rule
sudo visudo
# Delete the line you added, save and exit
```

## Network Topology Examples

### Example 1: Home Lab with Separate Networks

```
Internet
   ↓
Mullvad VPN (on Mac)
   ↓
Router/Firewall (192.168.1.1)
   ├─ Main Network: 192.168.1.0/24 (Mac is here)
   ├─ Server Network: 192.168.10.0/24 (NAS, servers)
   └─ IoT Network: 192.168.20.0/24 (smart home devices)
```

**Configuration:**
```bash
LOCAL_GATEWAY="192.168.1.1"
LOCAL_SUBNETS=(
    "192.168.10.0/24"
    "192.168.20.0/24"
)
```

### Example 2: VLAN-Segmented Network

```
Internet
   ↓
Mullvad VPN (on Mac)
   ↓
OPNsense Firewall (10.0.1.1)
   ├─ VLAN 10 (Workstations): 10.0.10.0/24 (Mac is here)
   ├─ VLAN 20 (Servers): 10.0.20.0/24
   ├─ VLAN 30 (Storage): 10.0.30.0/24
   └─ VLAN 40 (Management): 10.0.40.0/24
```

**Configuration:**
```bash
LOCAL_GATEWAY="10.0.1.1"
LOCAL_SUBNETS=(
    "10.0.20.0/24"
    "10.0.30.0/24"
    "10.0.40.0/24"
)
```

## Technical Details

### How macOS Routing Works

When Mullvad VPN connects, it creates a `utun` interface and adds a default route that captures all traffic. This is the "full tunnel" mode that routes everything through the VPN.

Static routes with more specific destinations (like `192.168.20.0/24`) take precedence over the default route (`0.0.0.0/0`), allowing us to selectively bypass the VPN for local traffic.

### Why Not Use Mullvad's Split Tunneling?

Mullvad's macOS app has split tunneling, but it works at the **application level** (excluding specific apps), not at the **network level** (excluding specific subnets). You'd have to exclude every app that needs local network access, which is impractical.

### Security Implications

- ✅ Internet traffic still goes through Mullvad VPN
- ✅ DNS queries still go through Mullvad (unless you've configured local DNS)
- ✅ Only explicitly configured local subnets bypass the VPN
- ⚠️ Devices on your local subnets can see your real IP address
- ⚠️ Local network traffic is not encrypted by the VPN

This is the same behavior as Mullvad's "Local Network Sharing" - it just extends it to multiple subnets.

## Performance

- **CPU Usage:** Negligible (~0.1 seconds per check, once per minute)
- **Memory Usage:** <1 MB
- **Network Impact:** None (only modifies routing table)
- **Battery Impact:** None (script sleeps between checks)

## Compatibility

| macOS Version | Status |
|---------------|--------|
| macOS 13 (Ventura) | ✅ Tested |
| macOS 14 (Sonoma) | ✅ Tested |
| macOS 15 (Sequoia) | ✅ Tested |
| macOS 26 (Tahoe) | ✅ Tested |

**Note:** macOS 13+ is required for the script syntax. Earlier versions may work with modifications.

## Contributing

Contributions welcome! Please open an issue or pull request.

## License

MIT License - see LICENSE file for details

## Acknowledgments

- Inspired by the limitations of Mullvad VPN's single-subnet "Local Network Sharing"
- Built on macOS's standard `launchd` and routing capabilities

## Support

If you find this useful, please ⭐ star this repo!

For issues or questions, please open a GitHub issue.

---

**Disclaimer:** This tool modifies your system's routing table. While it's designed to be safe, use at your own risk. Always test in a non-production environment first.
