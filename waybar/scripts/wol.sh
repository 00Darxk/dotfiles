#!/bin/bash

# Set your ip and mac address in appropriate files
# disable in waybar if not needed

IPFile="$HOME/.config/.secrets/ip-address.txt"
read -d $'\x04' IPAddress < "$IPFile"

MACFile="$HOME/.config/.secrets/mac-address.txt"
read -d $'\x04' MACAddress < "$MACFile"

/usr/bin/wol --wait=1 --host="$IPAddress" --port=9 "$MACAddress"