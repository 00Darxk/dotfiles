threshhold_green=0
threshhold_yellow=15
threshhold_red=100

# -------------------------------------------------------
# Calculate the available updates pacman and aur (with yay)
# -------------------------------------------------------

# TODO aggiungere lista degli aggiornamenti a tooltip
# devono essere sulla stessa linea, separati da un "\n"
list_updates_arch=$(checkupdates | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2};?)?)?[mGK]//g");
list_updates_aur=$(yay -Qua | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2};?)?)?[mGK]//g");

if ! updates_arch=$(checkupdates | wc -l); then
    updates_arch=0
fi

if ! updates_aur=$(yay -Qua | wc -l); then
    updtates_aur=0
fi

list_updates=""

if [ "$updates_arch" -gt 0 ]; then
    list_updates+="${list_updates_arch//$'\n'/\\n}"
    if [ "$updates_aur" -gt 0 ]; then ## TODO sistemare brutto
        list_updates+="\n"
    fi
fi

if [ "$updates_aur" -gt 0 ]; then
        list_updates+="${list_updates_aur//$'\n'/\\n}"
fi

# -------------------------------------------------------
# Output in JSON format for Waybar Module custom-updates
# -------------------------------------------------------
## TODO fix HTML tag, something about escaping right idfk
updates=$(("$updates_arch" + "$updates_aur"))
tooltip="Aggiorna il Sistema\n<span size=\\\"small\\\">${updates} Pacchetti</span>:\n${list_updates}"

css_class="green"

if [ "$updates" -gt $threshhold_yellow ]; then
    css_class="yellow"
fi

if [ "$updates" -gt $threshhold_red ]; then
    css_class="red"
fi

if [ "$updates" -gt $threshhold_green ]; then
    printf '{"text": "%s", "alt": "%s", "tooltip": "%s", "class": "%s"}' "$updates" "$updates" "$tooltip" "$css_class"
else 
    printf '{"text": "0", "alt": "0", "tooltip": "%s", "class": "green"}' "$tooltip"
fi
