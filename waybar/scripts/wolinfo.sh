#!/bin/bash

set -euo pipefail

ip=("$(cat "$HOME/.config/.secrets/ip-address.txt")")
mac=("$(cat "$HOME/.config/.secrets/mac-address.txt")")

if [ -z "$ip" ] || [[ "$ip" == *"255" ]] ; then
    ip=$(arp | grep "$mac" | awk ' { print $1 } ') ||
    ip+="Unknown Addr"
fi

if ping -c 1 -W 1 "$ip" > /dev/null 2>&1 ; then
    css_class="green"
    status_icon=""
else
    css_class="red"
    # status_icon="X"
    status_icon=""
fi

tooltip+="Sveglia Host:"$'\n'"<small><span foreground = \"${css_class}\">${ip} (${mac})</span></small>"

jq -nc \
        --arg text "$status_icon" \
        --arg tooltip "$tooltip"\
        --arg class "$css_class" \
        '{
            text: $text,
            tooltip: $tooltip,
            class: $class
        }'
