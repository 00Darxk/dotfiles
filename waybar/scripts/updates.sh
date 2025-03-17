threshhold_green=0
threshhold_yellow=15
threshhold_red=100

# -------------------------------------------------------
# Calculate the available updates pacman and aur (with trizen)
# -------------------------------------------------------

# TODO aggiungere lista degli aggiornamenti a tooltip
# devono essere sulla stessa linea, separati da un "\n"
#list_updates_arch=$(checkupdates);
#list_updates_aur=$(trizen -Su --aur --quiet);

if ! updates_arch=$(checkupdates | wc -l); then
    updates_arch=0
fi

if ! updates_aur=$(trizen -Su --aur --quiet | wc -l); then
    updtates_aur=0
fi


updates=$(("$updates_arch" + "$updates_aur"))

# -------------------------------------------------------
# Output in JSON format for Waybar Module custom-updates
# -------------------------------------------------------

css_class="green"

if [ "$updates" -gt $threshhold_yellow ]; then
    css_class="yellow"
fi

if [ "$updates" -gt $threshhold_red ]; then
    css_class="red"
fi

if [ "$updates" -gt $threshhold_green ]; then
    printf '{"text": "%s", "alt": "%s", "tooltip": "%s Updates", "class": "%s"}' "$updates" "$updates" "$updates" "$css_class"
else 
    printf '{"text": "0", "alt": "0", "tooltip": "0 Updates", "class": "green"}'
fi

