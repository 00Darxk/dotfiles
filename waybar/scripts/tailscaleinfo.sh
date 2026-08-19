#!/bin/bash

set -euo pipefail

# Set your hostname in the appropriate file
# disable in waybar if not needed

hostnames=($(cat "$HOME/.config/.secrets/hostnames.txt"))
sshhost=($(cat "$HOME/.config/.secrets/hostname.txt"))

if [ -z $hostnames ]; then
  hostnames=$sshhost
fi

for i in "${!hostnames[@]}"; do
  hostname="${hostnames[$i]}"

  ip=$(tailscale ip -4 "$hostname")
  status=$(tailscale ping -c 1 --until-direct=false --timeout=1s "$hostname" >/dev/null 2>&1 || echo $?)

  if ! [ -z "$status" ]; then
    if [ "$sshhost" = "$hostname" ]; then
      css_class=red
    fi
    css_class_hostname=red
    status_icon=""
  else
    if [ "$sshhost" = "$hostname" ]; then
      css_class=green
    fi
    css_class_hostname=green
    status_icon=""
  fi

  if [ "$sshhost" = "$hostname" ]; then
    text+=">  <span foreground = \"${css_class_hostname}\">${hostname}: ${ip} ${status_icon} </span>"
  else
    text+="   <span foreground = \"${css_class_hostname}\">${hostname}: ${ip} ${status_icon} </span>"
  fi

  # dumb way to do this, i'm tired don't judge me ;_;
  let "j=i+1"
  if [ $j -lt ${#hostnames[@]} ]; then
    text+=$'\n'
  fi
done

jq -nc \
  --arg text "$text" \
  --arg tooltip "" \
  --arg class "$css_class" \
  '{
            text: $text,
            tooltip: $tooltip,
            class: $class
        }'
