#!/bin/bash

# Set your hostname in the appropriate file
# disable in waybar if not needed

hostnameFile="$HOME/.config/.secrets/hostname.txt"
read -d $'\x04' hostname < "$hostnameFile"

ip=$(tailscale ip -4 "$hostname")

echo "Connecting to $hostname: $ip..."
read -p "Enter username: " username

ssh "$username"@"$ip"

