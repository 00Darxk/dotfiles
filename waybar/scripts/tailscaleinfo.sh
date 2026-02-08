#!/bin/bash

# Set your hostname in the appropriate file
# disable in waybar if not needed

hostnames=($(cat "$HOME/.config/.secrets/hostnames.txt")) 
sshhost=($(cat "$HOME/.config/.secrets/hostname.txt")) 

if [ -z $hostnames ] ; then
    hostnames=$sshhost
fi

for i in "${!hostnames[@]}"; do
    hostname="${hostnames[$i]}"

    ip=$(tailscale ip -4 "$hostname")
    status=$(tailscale status | awk -v h="$hostname" '$0 ~ h {print $NF}')

    if [ "$status" = "offline" ]; then
        if [ "$sshhost" = "$hostname" ]; then
            css_class=red
        fi
        status_icon=""
    else
        css_class=green
        status_icon=""
    fi

    if [ "$sshhost" = "$hostname" ]; then
        text+=">  <span foreground = \"${css_class}\">${hostname}: ${ip} ${status_icon} </span>"
    else
        text+="   <span foreground = \"${css_class}\">${hostname}: ${ip} ${status_icon} </span>"
    fi

    # dumb way to do this, i'm tired don't judge me ;_;
    let "j=i+1"
    if [ $j -lt ${#hostnames[@]} ]; then
        text+=$'\n'
    fi
done

jq -nc \
        --arg text "$text" \
        --arg tooltip ""\
        --arg class "$css_class" \
        '{
            text: $text,
            tooltip: $tooltip,
            class: $class
        }'