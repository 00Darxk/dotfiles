#!/bin/bash

# The following will attempt to install all needed packages to run Hyprland
# This is a quick and dirty script there are no error checking
# This script is meant to run on a clean fresh system
#
# Below is a list of the packages that would be installed
#   TODO add description of packages
# hyprland: This is the Hyprland compositor
# kitty: This is the default terminal
# waybar: Waybar now has hyprland support
# swaybg: This is used to set a desktop background image
# swaylock-effects: This allows for the locking of the desktop its a fork that adds some editional visual effects
# wofi: This is an application launcher menu
# wlogout: This is a logout menu that allows for shutdown, reboot and sleep
# swaync: This is a graphical notification daemon
# thunar: This is a graphical file manager
# ttf-jetbrains-mono-nerd: Som nerd fonts for icons and overall look
# noto-fonts-emoji: fonts needed by the weather script in the top bar
# polkit-gnome: needed to get superuser access on some graphical appliaction
# starship: allows to customize the shell prompt
# swappy: This is a screenshot editor tool
# grim: This is a screenshot tool it grabs images from a Wayland compositor
# slurp: This helps with screenshots, it selects a region in a Wayland compositor
# pamixer: This helps with audio settings such as volume
# brightnessctl: used to control monitor bright level
# gvfs: adds missing functionality to thunar such as automount usb drives
# bluez: the bluetooth service
# bluez-utils: command line utilities to interact with bluettoth devices
# nwg-look: used to set GTK theme
# xfce4-settings: set of tools for xfce, needed to set GTK theme
# dracula-gtk-theme: the Dracula theme, it fits the overall look and feel
# dracula-icons-git: set of icons to go with the Dracula theme
# xdg-desktop-portal-hyprland: xdg-desktop-portal backend for hyprland
# wl-gammarelay: a client and deamon for changing color temperature and brightness under wayland
# hyfetch: neofetch with lgbtq+ flags
# power-profiles-daemon: lets you switch power profiles on the machine
# sddm: login manager
# ttf-fira-code: cool coding font
# ttf-font-awesome: fonts for waybar icons
# otf-font-awesome: fonts for waybar icons
# wol: utility to wake on lan a machine
# jq: cli json processor, to format text for custom waybar modules


#### Check for yay ####
ISYAY=/sbin/yay
if [ -f "$ISYAY" ]; then 
    echo -e "yay was located, moving on.\n"
    yay -Suy
else 
    echo -e "yay was not located, please install yay. Exiting script.\n"
    exit 
fi

### Disable wifi powersave mode ###
read -n1 -rep 'Would you like to disable wifi powersave? (y,n)' WIFI
if [[ $WIFI == "Y" || $WIFI == "y" ]]; then
    LOC="/etc/NetworkManager/conf.d/wifi-powersave.conf"
    echo -e "The following has been added to $LOC.\n"
    echo -e "[connection]\nwifi.powersave = 2" | sudo tee -a $LOC
    echo -e "\n"
    echo -e "Restarting NetworkManager service...\n"
    sudo systemctl restart NetworkManager
    sleep 3
fi

### Install all of the above pacakges ####
read -n1 -rep 'Would you like to install the packages? (y,n)' INST
if [[ $INST == "Y" || $INST == "y" ]]; then
    yay -S --noconfirm hyprland kitty waybar \
    swaybg swaylock-effects wofi wlogout swaync thunar \
    ttf-jetbrains-mono-nerd noto-fonts-emoji \
    polkit-gnome starship \
    swappy grim slurp pamixer brightnessctl gvfs \
    bluez bluez-utils nwg-look xfce4-settings \
    dracula-gtk-theme dracula-icons-git xdg-desktop-portal-hyprland \
    wl-gammarelay hyfetch power-profiles-daemon sddm \
    ttf-fira-code ttf-font-awesome otf-font-awesome \
    jq \

    # Start the bluetooth service
    echo -e "Starting the Bluetooth Service...\n"
    sudo systemctl enable --now bluetooth.service
    sleep 2
    
    # Clean out other portals
    echo -e "Cleaning out conflicting xdg portals...\n"
    yay -R --noconfirm xdg-desktop-portal-gnome xdg-desktop-portal-gtk
fi

### Copy Config Files ###
read -n1 -rep 'Would you like to copy config files? (y,n)' CFG
if [[ $CFG == "Y" || $CFG == "y" ]]; then
    echo -e "Copying config files...\n"
    cp -R hypr ~/.config/
    cp -R kitty ~/.config/
    cp -R neofetch ~/.config/
    cp -R swaylock ~/.config/
    cp -R waybar ~/.config/
    cp -R wlogout ~/.config/
    cp -R wofi ~/.config/
    cp hyfetch.json ~/.config/

    # Set some files as exacutable 
    chmod +x ~/.config/hypr/xdg-portal-hyprland
    chmod +x ~/.config/waybar/scripts/connectssh.sh
    chmod +x ~/.config/waybar/scripts/github.sh
    chmod +x ~/.config/waybar/scripts/installupdates.sh
    chmod +x ~/.config/waybar/scripts/launch.sh
    chmod +x ~/.config/waybar/scripts/mediaplayer.py
    chmod +x ~/.config/waybar/scripts/sysmaintenance.sh
    chmod +x ~/.config/waybar/scripts/tailscaleinfo.sh
    chmod +x ~/.config/waybar/scripts/updates.sh
    chmod +x ~/.config/waybar/scripts/wol.sh
fi

### Configure WoL in waybar ### TODO test and configure correctly
read -n1 -rep 'Would you like to configure wake on lan with waybar? (y,n)' WOL
if [[ $WOL == "Y" || $WOL == "y" ]]; then
    yay -S --noconfirm wol
    mkdir -p "~/.secrets"
    read -p "Enter IP Address: " IPAddress
    read -p "Enter MAC Address: " MACAddress
    echo "$IPAddress" > ~/.secrets/ip-address.txt
    echo "$MACAddress" > ~/.secrets/mac-address.txt
fi

### Configure tailscale in waybar ### TODO test and configure correctly
read -n1 -rep 'Would you like to install and configure tailscale with waybar? (y,n)' TAIL
if [[ $TAIL == "Y" || $TAIL == "y" ]]; then
    echo "Installing tailscale..."
    yay -S --noconfirm tailscale
    mkdir -p "~/.secrets"
    read -p "Enter hostname: " hostname
    echo "$hostname" > ~/.secrets/hostname.txt
    echo "Enable tailscale:"
    sudo systemctl enable --now tailscaled
    echo "After installation connect the machine to your tailscale network with sudo tailscale up"
fi


### Install the starship shell ###
read -n1 -rep 'Would you like to install the starship shell? (y,n)' STAR
if [[ $STAR == "Y" || $STAR == "y" ]]; then
    # install the starship shell
    echo -e "Updating .bashrc...\n"
    echo -e '\neval "$(starship init bash)"' >> ~/.bashrc
    echo -e "copying starship config file to ~/.confg ...\n"
    cp .bashrc ~/.bashrc
    cp starship.toml ~/.config/
fi

### Install applications ###
read -n1 -rep 'Would you like to install applications (not recommended)? (y,n)' APP
if [[ $APP == "Y" || $APP == "y" ]]; then
    yay -S --noconfirm telegram-desktop notion-app-electron \
    discord steam spotify-launcher chromium vscodium-bin \


### Script is done ###
echo -e "Script had completed.\n"
echo -e "You can start Hyprland by typing Hyprland (note the capital H).\n"
read -n1 -rep 'Would you like to start Hyprland now? (y,n)' HYP
if [[ $HYP == "Y" || $HYP == "y" ]]; then
    exec Hyprland
else
    exit
fi