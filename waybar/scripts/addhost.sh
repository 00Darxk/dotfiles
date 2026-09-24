#!/bin/bash

knownHosts="Known hosts"
addNewHost="Add new host"
updating="added, updating list"

cur=("$(cat $HOME/.config/.secrets/hostnames.txt)")
echo "$knownHosts: \"'${cur[*]}'\""
read -rep "$addNewHost: " new
echo "'$new' $updating"

echo -en "\n$new" >> "$HOME/.config/.secrets/hostnames.txt"
sleep 0.5