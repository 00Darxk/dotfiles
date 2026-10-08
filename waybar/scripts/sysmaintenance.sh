#!/bin/bash

# This code is almost entirely taken from Mr. Cejas's blog: https://fernandocejas.com/blog/engineering/2022-03-30-arch-linux-system-maintance/
updating=$(jq -r '."waybar.scripts.sysmaintenance.updating"' $HOME/.config/dotlang/lang.jsonc)
clear=$(jq -r '."waybar.scripts.sysmaintenance.clear"' $HOME/.config/dotlang/lang.jsonc)
space=$(jq -r '."waybar.scripts.sysmaintenance.space"' $HOME/.config/dotlang/lang.jsonc)
orphans=$(jq -r '."waybar.scripts.sysmaintenance.orphanss"' $HOME/.config/dotlang/lang.jsonc)
clearing=$(jq -r '."waybar.scripts.sysmaintenance.updating"' $HOME/.config/dotlang/lang.jsonc)
logs=$(jq -r '."waybar.scripts.sysmaintenance.log"' $HOME/.config/dotlang/lang.jsonc)

echo "$updating"
yay -Syu

echo "$clear"
pacman_cache_space_used="$(du -sh /var/cache/pacman/pkg/)"
paccache -r 
echo "$space: $pacman_cache_space_used" 

echo "$orphans"
yay -Qdtq | yay -Rns -

echo "$clearing ~/.cache"
home_cache_used="$(du -sh ~/.cache)"
rm -rf ~/.cache/
echo "$space: $home_cache_used"

echo "$logs"
journalctl --vacuum-time=7d


