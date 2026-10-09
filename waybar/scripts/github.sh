#!/bin/bash

threshhold_green=0
threshhold_yellow=5
threshhold_red=50

user=`git config --get user.name`
token=`cat ~/.config/.secrets/notifications.token`
count=`curl -u ${user}:${token} https://api.github.com/notifications | jq '. | length'`
tooltip=$(jq -r '."waybar.modules.custom.github.tooltip-format"' "${HOME}/.config/dotlang/lang.jsonc")

css_class="green"

if [ "$count" -gt $threshhold_yellow ]; then
    css_class="yellow"
fi

if [ "$count" -gt $threshhold_red ]; then
    css_class="red"
fi


jq -nc \
        --arg text "$count" \
        --arg tooltip "$tooltip"\
        --arg class "$css_class" \
        '{
            text: $text,
            tooltip: $tooltip,
            class: $class
        }'

