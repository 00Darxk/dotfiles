#!/bin/bash

threshhold_green=0
threshhold_yellow=5
threshhold_red=50

token=`cat ~/.config/.secrets/notifications.token`
count=`curl -u 00Darxk:${token} https://api.github.com/notifications | jq '. | length'`

css_class="green"

if [ "$count" -gt $threshhold_yellow ]; then
    css_class="yellow"
fi

if [ "$count" -gt $threshhold_red ]; then
    css_class="red"
fi


printf '{"text": "%d","tooltip":"$tooltip","class": "%s"}' "$count" "$css_class"

