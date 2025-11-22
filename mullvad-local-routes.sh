#!/bin/bash

###############################################################################
# Mullvad VPN Multi-Subnet Route Manager
# 
# This script automatically adds static routes for local subnets when Mullvad
# VPN is connected, allowing access to devices on different local networks
# while maintaining VPN security for internet traffic.
#
# Configuration: Edit the variables below for your network
###############################################################################

# Your local gateway IP (typically your router/firewall)
LOCAL_GATEWAY="192.168.1.1"

# Define your local subnets that should bypass the VPN
# Add or remove subnets as needed for your network
# Format: "SUBNET/CIDR"
LOCAL_SUBNETS=(
    "192.168.10.0/24"    # Example: Main LAN
    "192.168.20.0/24"    # Example: Server subnet
    "192.168.30.0/24"    # Example: IoT subnet
)

# Mullvad VPN interface name (usually utun6 on macOS, change if different)
VPN_INTERFACE="utun6"

###############################################################################
# DO NOT EDIT BELOW THIS LINE UNLESS YOU KNOW WHAT YOU'RE DOING
###############################################################################

# Function to check if a route exists
route_exists() {
    local subnet=$1
    netstat -rn | grep -q "^${subnet%/*}"
}

# Check if Mullvad VPN interface exists (VPN is connected)
if ifconfig "$VPN_INTERFACE" &> /dev/null; then
    # VPN is connected, check and add routes if needed
    for subnet in "${LOCAL_SUBNETS[@]}"; do
        if ! route_exists "$subnet"; then
            sudo route add -net "$subnet" "$LOCAL_GATEWAY" 2>/dev/null
        fi
    done
fi
