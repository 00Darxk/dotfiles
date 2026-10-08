#!/bin/bash

# Set your hostname in the appropriate file
# disable in waybar if not needed

connecting=$(jq -r '."waybar.scripts.connectssh.connecting"' $HOME/.config/dotlang/lang.jsonc)
user=$(jq -r '."waybar.scripts.connectssh.user"' $HOME/.config/dotlang/lang.jsonc)

hostname=$(cat $HOME/.config/.secrets/hostname.txt)
ip=$(tailscale ip -4 "$hostname")

echo "$connecting $hostname: $ip..."
read -p "$user: " username

ssh "$username"@"$ip"
