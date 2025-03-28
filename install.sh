#!/bin/bash

# The following will attempt to install all needed packages to run Hyprland
# Packages and a description can be found on https://github.com/00Darxk/dotfiles?tab=readme-ov-file#dependencies
# This is a quick and dirty script there are no error checking
# This script is meant to run on a clean fresh system

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
    ttf-jetbrains-mono-nerd polkit-gnome starship \
    swappy grim slurp pamixer brightnessctl gvfs \
    bluez bluez-utils nwg-look xfce4-settings \
    dracula-gtk-theme dracula-icons-git xdg-desktop-portal-hyprland \
    wl-gammarelay hyfetch power-profiles-daemon sddm \
    ttf-fira-code ttf-font-awesome jq fzf btop \

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

    # Set some files as exactable 
    chmod +x ~/.config/hypr/xdg-portal-hyprland
    chmod +x ~/.config/waybar/scripts/*
fi

### Configure WoL in waybar ### TODO test and configure correctly
read -n1 -rep 'Would you like to install and configure wake on lan with waybar? (y,n)' WOL
if [[ $WOL == "Y" || $WOL == "y" ]]; then
    yay -S --noconfirm wol
    mkdir -p "~/.secrets"
    read -p "Enter IP Address: " IPAddress
    read -p "Enter MAC Address: " MACAddress
    echo -e "$IPAddress" > ~/.secrets/ip-address.txt
    echo -e "$MACAddress" > ~/.secrets/mac-address.txt
fi

### Configure tailscale in waybar ### TODO test and configure correctly
read -n1 -rep 'Would you like to install and configure tailscale with waybar? (y,n)' TAIL
if [[ $TAIL == "Y" || $TAIL == "y" ]]; then
    echo "Installing tailscale..."
    yay -S --noconfirm tailscale
    mkdir -p "~/.secrets"
    read -p "Enter hostname: " hostname
    echo -e "$hostname" > ~/.secrets/hostname.txt
    echo -e "Enable tailscale:"
    sudo systemctl enable --now tailscaled
    echo -e "Connecting to your tailscale network..."
    sudo tailscale up
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

### Install optionals programs ###
read -n1 -rep 'Would you like to install optional programs? (y,n)' APP
if [[ $APP == "Y" || $APP == "y" ]]; then
    yay -S --noconfirm telegram-desktop notion-app-electron \
    discord steam spotify-launcher chromium vscodium-bin \
    whatdesk-bin \

fi


### Script is done ###
echo -e "Script had completed.\n"
echo -e "You can start Hyprland by typing Hyprland (note the capital H).\n"
read -n1 -rep 'Would you like to start Hyprland now? (y,n)' HYP
if [[ $HYP == "Y" || $HYP == "y" ]]; then
    exec Hyprland
else
    exit
fi