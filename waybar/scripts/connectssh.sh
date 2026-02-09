#!/bin/bash

# Set your hostname in the appropriate file
# disable in waybar if not needed


hostname=$(cat $HOME/.config/.secrets/hostname.txt)
ip=$(tailscale ip -4 "$hostname")

echo "Connecting to $hostname: $ip..."
read -p "Enter username: " username

ssh "$username"@"$ip"

