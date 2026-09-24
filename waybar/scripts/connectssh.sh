#!/bin/bash

# Set your hostname in the appropriate file
# disable in waybar if not needed

connecting="Connecting to"
user="Enter username"

hostname=$(cat $HOME/.config/.secrets/hostname.txt)
ip=$(tailscale ip -4 "$hostname")

echo "$connecting $hostname: $ip..."
read -p "$user: " username

ssh "$username"@"$ip"
