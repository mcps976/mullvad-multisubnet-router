# Example Network Configurations
# Copy the relevant example below into your mullvad-local-routes.sh

##############################################################################
# Example 1: Simple Home Network with Server Subnet
##############################################################################
# Topology:
#   - Main network: 192.168.1.0/24 (Mac is here)
#   - Server network: 192.168.10.0/24 (NAS, Plex, etc.)
#   - Gateway: 192.168.1.1

LOCAL_GATEWAY="192.168.1.1"
LOCAL_SUBNETS=(
    "192.168.10.0/24"
)

##############################################################################
# Example 2: Multi-VLAN Home Lab
##############################################################################
# Topology:
#   - Management: 10.0.1.0/24 (Mac is here)
#   - Servers: 10.0.10.0/24
#   - Storage: 10.0.20.0/24
#   - IoT: 10.0.30.0/24
#   - Gateway: 10.0.1.1

LOCAL_GATEWAY="10.0.1.1"
LOCAL_SUBNETS=(
    "10.0.10.0/24"
    "10.0.20.0/24"
    "10.0.30.0/24"
)

##############################################################################
# Example 3: pfSense/OPNsense with Multiple Subnets
##############################################################################
# Topology:
#   - LAN: 192.168.1.0/24 (Mac is here)
#   - DMZ: 10.10.10.0/24
#   - Guest: 192.168.99.0/24
#   - Servers: 172.16.0.0/24
#   - Gateway: 192.168.1.1

LOCAL_GATEWAY="192.168.1.1"
LOCAL_SUBNETS=(
    "10.10.10.0/24"
    "192.168.99.0/24"
    "172.16.0.0/24"
)

##############################################################################
# Example 4: UniFi Network with VLANs
##############################################################################
# Topology:
#   - Default: 192.168.1.0/24 (Mac is here)
#   - VLAN 10 (Servers): 192.168.10.0/24
#   - VLAN 20 (IoT): 192.168.20.0/24
#   - VLAN 30 (Guest): 192.168.30.0/24
#   - Gateway: 192.168.1.1

LOCAL_GATEWAY="192.168.1.1"
LOCAL_SUBNETS=(
    "192.168.10.0/24"
    "192.168.20.0/24"
    "192.168.30.0/24"
)

##############################################################################
# Example 5: Enterprise-Style Network with /16 Supernets
##############################################################################
# Topology:
#   - Workstations: 10.10.0.0/16
#   - Servers: 10.20.0.0/16
#   - Management: 10.30.0.0/16
#   - Mac is on: 10.10.50.0/24
#   - Gateway: 10.10.1.1

LOCAL_GATEWAY="10.10.1.1"
LOCAL_SUBNETS=(
    "10.20.0.0/16"
    "10.30.0.0/16"
)

##############################################################################
# Example 6: Docker/Container Network Access
##############################################################################
# Topology:
#   - Home network: 192.168.1.0/24 (Mac is here)
#   - Docker host network: 192.168.50.0/24
#   - Docker bridge: 172.17.0.0/16
#   - Gateway: 192.168.1.1

LOCAL_GATEWAY="192.168.1.1"
LOCAL_SUBNETS=(
    "192.168.50.0/24"
    "172.17.0.0/16"
)

##############################################################################
# How to Find Your Network Information
##############################################################################

# Find your gateway:
#   netstat -rn | grep default
#   Look for the IP in the "gateway" column

# Find your local subnets:
#   netstat -rn
#   Look for entries showing your local networks (usually 192.168.x.x or 10.x.x.x)

# Find your Mac's IP and subnet:
#   ifconfig | grep "inet " | grep -v 127.0.0.1
#   This shows your Mac's IP address

# Test if a subnet is reachable:
#   ping [IP_ADDRESS_ON_THAT_SUBNET]
#   If it times out with Mullvad connected, you need to add that subnet
