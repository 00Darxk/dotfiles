#!/bin/bash

cur=("$(cat $HOME/.config/.secrets/hostnames.txt)")
echo 'Known hosts: "'${cur[*]}'"'
read -rep 'Add new host: ' new
echo "Added '$new', updating list"

echo -en "\n$new" >> "$HOME/.config/.secrets/hostnames.txt"
sleep 0.5