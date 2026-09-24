# This code is almost entirely taken from Mr. Cejas's blog: https://fernandocejas.com/blog/engineering/2022-03-30-arch-linux-system-maintance/
updating="Updating system"
clear="Clearing pacman cache"
space="Space saved"
orphans="Removing orphans packages"
clearing="Clearing"
logs="Clearing system logs"

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


