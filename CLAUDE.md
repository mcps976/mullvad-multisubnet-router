# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Purpose

This project provides static route management so local subnet traffic bypasses the Mullvad VPN tunnel. Without it, Mullvad's kill switch blocks access to local network devices (NAS, cameras, etc.) when the VPN is active.

## Architecture

The solution is a bash script run on a timer that checks whether Mullvad is connected and, if so, ensures static routes exist for configured local subnets.

**macOS (primary):**
- `mullvad-local-routes.sh` — checks for the Mullvad VPN interface (`utun6`), then adds missing static routes via `LOCAL_GATEWAY` for each `LOCAL_SUBNETS` entry
- `com.mullvad.local-routes.plist` — LaunchAgent that runs the script every 60 seconds, logging to `/tmp/mullvad-routes.log`
- `install.sh` — automates installation: copies script to `/usr/local/bin/`, configures passwordless sudo for the `route` command, loads the LaunchAgent

**Linux (secondary):**
- `linux/10-mullvad-routes` — NetworkManager dispatcher script; dynamically detects Mullvad's `ip rule` priority and inserts routes accordingly
- `linux/mullvad-routes.service` — systemd service that requires `mullvad-daemon.service`, ensuring correct startup order

## Key Configuration

Both `mullvad-local-routes.sh` and `linux/10-mullvad-routes` require the user to edit two variables before use:
- `LOCAL_GATEWAY` — the LAN gateway IP
- `LOCAL_SUBNETS` — space-separated list of CIDR subnets to route locally

## Installation

```bash
chmod +x install.sh
./install.sh
```

## Manual Testing

```bash
# Run script directly after connecting to Mullvad
sudo /usr/local/bin/mullvad-local-routes.sh

# Verify routes were added
netstat -rn | grep "192.168"

# Check LaunchAgent is running
launchctl list | grep mullvad

# Inspect logs
cat /tmp/mullvad-routes.log
cat /tmp/mullvad-routes.error.log
```

## Homelab Infrastructure

This project runs across the following environment — relevant when reasoning about subnets, hostnames, or target platforms:

| Device | Role |
|--------|------|
| Protectli VP2420 | OPNsense router — Suricata IDS, Unbound DNS, HAProxy |
| Terramaster F4-423 | TrueNAS — SMB shares, Nextcloud, Dockge with full ARR stack (Sonarr, Radarr, Lidarr, Prowlarr, Jellyfin, Jellyseerr, Audiobookshelf, Homarr) |
| Beelink SER | Primary Linux workstation — Debian with KDE |
| Beelink (separate) | Bitcoin node — Ubuntu, Mempool.space, Alby Hub |
| MacBook Pro M3 Pro | Primary Mac workstation |

Remote access via Tailscale; Mullvad VPN runs on all devices.

## Git Remotes

- `origin` — GitHub (`mcps976`)
- `truenas` — TrueNAS bare repos at `/mnt/tank/git-repos/`

## Code Style

- Target bash 5.x on Debian/Ubuntu for Linux scripts
- Shell scripts should be linted with `shellcheck` before submitting PRs
- Scripts must remain dependency-free (only standard Unix utilities)
- macOS scripts use `netstat`/`ifconfig`/`route`; Linux scripts use `ip rule`/`ip route`
