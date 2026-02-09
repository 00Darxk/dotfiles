#!/bin/bash

# Set your ip and mac address in appropriate files
# disable in waybar if not needed

ip=($(cat "$HOME/.config/.secrets/ip-address.txt"))
mac=($(cat "$HOME/.config/.secrets/mac-address.txt"))

/usr/bin/wol --wait=1 --host="$ip" --port=9 "$mac"