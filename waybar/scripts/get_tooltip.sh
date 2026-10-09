#!/bin/bash

jq -nc --arg tooltip "$(jq -r --arg key "$1" '.[$key]' "${HOME}/.config/dotlang/lang.jsonc")" '{tooltip: $tooltip}'