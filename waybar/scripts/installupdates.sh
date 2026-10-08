#!/bin/bash

update=$(jq -r '."waybar.scripts.installupdates.update"' $HOME/.config/dotlang/lang.jsonc)

read -n1 -rep "$update (Y,n)" UPD
if [[ $UPD == "Y" || $UPD == "y" ]] || [ -z "$UPD" ]; then
    yay --noconfirm -Syu
fi