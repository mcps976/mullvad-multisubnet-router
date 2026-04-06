# CLAUDE.md — mullvad-multisubnet-router

> For infrastructure context (hardware, networking, IPs, services) see ~/Git/CLAUDE.md

---

## Project Purpose

Static route management so local subnet traffic bypasses the Mullvad VPN
tunnel. Without this, Mullvad's kill switch blocks access to local devices
(TrueNAS, nodebox, etc.) when VPN is active.

---

## Architecture

### macOS (primary — MacBook Pro M3 Pro)
- `mullvad-local-routes.sh` — checks for Mullvad VPN interface (utun6),
  adds missing static routes via LOCAL_GATEWAY for each LOCAL_SUBNETS entry
- `com.mullvad.local-routes.plist` — LaunchAgent, runs every 60 seconds,
  logs to /tmp/mullvad-routes.log
- `install.sh` — copies script to /usr/local/bin/, configures passwordless
  sudo for route command, loads LaunchAgent

### Linux (secondary — Debian/Ubuntu)
- `linux/10-mullvad-routes` — NetworkManager dispatcher script; dynamically
  detects Mullvad's ip rule priority and inserts routes above it
- `linux/mullvad-routes.service` — systemd service requiring mullvad-daemon.service

---

## Key Configuration

Edit two variables before use (both macOS and Linux scripts):
- `LOCAL_GATEWAY` — LAN gateway IP (10.54.10.1)
- `LOCAL_SUBNETS` — space-separated CIDR list: 10.54.10.0/24 10.54.20.0/24 10.54.30.0/24

---

## Installation

```bash
chmod +x install.sh
./install.sh
```

## Testing

```bash
sudo /usr/local/bin/mullvad-local-routes.sh   # Run directly
netstat -rn | grep "10.54"                    # Verify routes added
launchctl list | grep mullvad                 # Check LaunchAgent
cat /tmp/mullvad-routes.log                   # Inspect logs
```

---

## Critical Note

Mullvad's ip rule priority changes dynamically on VPN updates. Linux scripts
must detect and insert above current priority — never hardcode priority values.

## Scripting Conventions

- macOS: netstat / ifconfig / route
- Linux: ip rule / ip route
- bash 5.x on Linux — no zsh or macOS builtins
- shellcheck before committing
- Dependency-free (standard Unix utilities only)

## Git Remotes

- `origin` → git@github.com:mcps976/mullvad-multisubnet-router.git
- `truenas` → truenas:/mnt/tank/git-repos/mullvad-multisubnet-router.git
