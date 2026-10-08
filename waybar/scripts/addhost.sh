#!/bin/bash

knownHosts=$(jq -r '."waybar.scripts.addhost.knownHosts"' $HOME/.config/dotlang/lang.jsonc)
addNewHost=$(jq -r '."waybar.scripts.addhost.addNewHost"' $HOME/.config/dotlang/lang.jsonc)
updating=$(jq -r '."waybar.scripts.addhost.updating"' $HOME/.config/dotlang/lang.jsonc)

cur=("$(cat $HOME/.config/.secrets/hostnames.txt)")
echo "$knownHosts: \"'${cur[*]}'\""
read -rep "$addNewHost: " new
echo "'$new' $updating"

echo -en "\n$new" >> "$HOME/.config/.secrets/hostnames.txt"
sleep 0.5