#!/bin/bash

# Edited from https://github.com/SolDoesTech/hyprland
# The following will attempt to install all needed packages to run Hyprland
# Packages and a description can be found on https://github.com/00Darxk/dotfiles?tab=readme-ov-file#dependencies
# This is a quick and dirty script there are some error checking
# This script is meant to run on a clean fresh system

set -euo pipefail

usercfg=""
if ! [ -z "${1++}" ] ; then
    usercfg=$1
fi

check_git() {
    which git > /dev/null 2>&1 || 
    echo -e "Git binary not found. Exiting..." &&
    echo -en "Please install git" &&
    exit
}

check_user() {
    if id "$1" >/dev/null 2>&1; then
        echo "User '$1' exists"
    else
        echo "User '$1' does not exists. Are you sure you want to use '$1'? [y/N]" ; read user
        if ! [[ $user == 'Y' || $user == 'y' ]] ; then
            echo "Please create the user (and home directory) with 'useradd -m $1'."
            echo "Set a password for the new user with 'passwd $1'"
            echo "Exiting..."
            exit
    fi
}

home=$HOME
check_home() {
    user=($(whoami))
    if ([ $user = "root" ] && [ -z $1 ]) || [ $1 = "root" ] ; then
        echo "You are currently root or provided a root user, please change to or specify a non-root-user."
        echo "If you wish to continue and install under '$1', press 'Y': " ; read -rep root 
        if [ $root != 'Y' ] ; then
            echo "Exiting..."
            exit
        fi
    fi
    
    # check for user
    if [ ! -z $1 ] ; then
        check_user $1
        user=$1
    fi
    echo "Installing for user $1, checking searching for home directory"
    
    # check for home directory
    home="/home/$user"
    if [ ! -d "$home" ] ; then
        echo -e "Home directory not found under user '$user'. Attempting to create."
        sudo mkdir "$home" > /dev/null || echo -e "Failed to create home directory. Exiting..." && exit
    fi
    echo -e "Home directory under user '$user' found."
}


#### Check for yay ####
check_yay() {
    if [ ! -f "/sbin/yay" ] ; then 
        echo "Installing yay"

        git clone https://aur.archlinux.org/yay.git # > /dev/null 2>&1 # todo add logging
        cd yay
        makepkg -si --noconfirm # > /dev/null 2>&1 # todo add logging
    
        if [ -f "/sbin/yay" ] ; then 
            cd ..
            echo "Updating yay database"
            yay -Suy --noconfirm # > /dev/null 2>&1 # todo add logging
            echo "yay updated"
        else
            echo "yay install failed. Exiting..."
            exit
        fi
    fi 
}

net=""
check_network_manager() {
    echo "Checking for NetworkManager"
    echo "sudo systemctl status NetworkManager.service"
    sudo systemctl status NetworkManager.service > /dev/null && 
    net="NetworkManager" ||
    (echo "(Active) NetworkManager not found" 
    echo "Checking for iwd" 
    echo "sudo systemctl status iwd.service" 
    sudo systemctl status iwd.service > /dev/null &&
    net="iwd") ||
    (echo "(Active) iwd not found" 
    echo "Disable powersave manually, by using udev rules or your installed network manager:" 
    echo "https://wiki.archlinux.org/title/Power_management#Network_interfaces" 
    net="" )
}


### Disable wifi powersave mode ###
disable_wifi_powersave() {
    read -rep 'Would you like to disable wifi powersave? [Y/n]' WIFI
    if [[ $WIFI == "Y" || $WIFI == "y" ]] || [ -z "$WIFI" ] ; then
        check_network_manager
        net=iwd
        case $net in
            NetworkManager)
                confloc="/etc/NetworkManager/conf.d/wifi-powersave-off.conf"
                netloc="/etc/NetworkManager/conf.d/"
                conf="[connection]\nwifi.powersave = 2"
                ;;
            iwd)
                confloc="/etc/iwd/main.conf"
                netloc="/etc/iwd/"
                conf="[DriverQuirks]\nPowerSaveDisable=*"
                ;;
            *)
                net=""
                ;;
        esac


        if [ ! -z $net ] ; then
            echo "Checking for '$netloc'"
            if [ ! -d $netloc ] ; then
                echo "Directory not found, attempting to create."
                sudo mkdir -p $netloc > /dev/null ||
                echo "Failed to create directory" 
            fi

            if [ -d $netloc ] ; then
                echo -e "The following has been added to '$confloc':"
                echo -e $conf | sudo tee -a $confloc

                echo -e "\nRestarting $net service...\n"
                sudo systemctl restart $net
                sleep 3
                echo "$net restarted"
            fi
        fi
    fi
}

### Install dependencies ###
install_dependencies() {
    read -rep 'Would you like to install the packages? [Y/n]' INST
    if [[ $INST == "Y" || $INST == "y" ]] || [ -z "$INST" ] ; then
        cat dependencies | sed 's/#.*//' | yay -S --noconfirm
        
        # Start the bluetooth service
        echo -e "Starting the Bluetooth Service...\n"
        sudo systemctl enable --now bluetooth.service
        sleep 2
        
        # Clean out other portals
        echo -e "Cleaning out conflicting xdg portals...\n"
        yay -R --noconfirm xdg-desktop-portal-gnome xdg-desktop-portal-gtk
    fi
}

### Copy Config Files ###
copy_configs() {
    read -rep 'Would you like to copy config files? [Y/n]' CFG
    if [[ $CFG == "Y" || $CFG == "y" ]] || [ -z "$CFG" ] ; then
        echo -e "Would you like to backup existing configs? [Y/n]" ; read -n1 -rep bak
        if [ "$bak" = Y ] || [ "$bak" = y ] || [ -z "$bak" ] ; then
            echo -e "Backing up existing config files...\n"
            backup_configs
        fi

        echo -e "Copying config files...\n"
        cp -R hypr kitty neofetch swaylock waybar wlogout rofi hyfetch.json "$home/.config/"

        # Set some files as exactable 
        chmod +x "$home/.config/hypr/scripts*"
        chmod +x "$home/.config/waybar/scripts/*"
    fi
}

backup_configs() {
    for cfg in hypr kitty neofetch swaylock waybar wlogout rofi hyfetch.json; do
        mv "$home/.config/$cfg" "$home/.config/$cfg.bak"
    done
}

### Configure WoL in waybar 
enable_wol_waybar() {
    read -rep 'Would you like to install and configure wake on lan with waybar? [y/N]' WOL
    if [[ $WOL == "Y" || $WOL == "y" ]]; then
        echo -e "Installing wol package"
        yay -S --noconfirm wol
        
        sed -r -i "s|(^.*)//[ ]*([^$]*wol.*$)|\1\2|" "$home/.config/waybar/config.jsonc"

        mkdir -p "$home/.config/.secrets"
        read -p "Enter IP Address: " IPAddress
        read -p "Enter MAC Address: " MACAddress
        echo -e "$IPAddress" > "$home/.config/.secrets/ip-address.txt"
        echo -e "$MACAddress" > "$home/.config/.secrets/mac-address.txt"
    fi
}

### Configure tailscale in waybar 
enable_tailscale_waybar() {
    read -rep 'Would you like to install and configure tailscale with waybar? [y/N]' TAIL
    if [[ $TAIL == "Y" || $TAIL == "y" ]] ; then
        echo "Installing tailscale package"
        yay -S --noconfirm tailscale
        
        sed -r -i "s|(^.*)//[ ]*([^$]*tailscale.*$)|\1\2|" "$home/.config/waybar/config.jsonc"

        mkdir -p "$home/.config/.secrets"
        read -p "Enter hostname: " hostname
        echo -e "$hostname" > "$home/.config/.secrets/hostname.txt"
        cat "$home/.config/.secrets/hostname.txt" > "$home/.config/.secrets/hostnames.txt"
        
        echo -e "Enable tailscale:"
        sudo systemctl enable --now tailscaled
        
        echo -e "Connecting to your tailscale network..."
        sudo tailscale up
        sleep 3

        read -n1 -rep 'Would you like to add more machine statuses to the tooltip? [y,N]' TAIL
        if [[ $TAIL == "Y" || $TAIL == "y" ]]; then
            tailstatus=("$(tailscale status)")
            echo "$tailstatus"
            while :
            do
                printf "Enter hostname ('q' or enter to stop): " ; read -r host
                if [ "$host" = "q" ] || [ "$host" = "Q" ] || [ -z "${host}" ]; then
                    break
                fi

                if ! grep -q "$host" "$tailstatus" ; then
                    echo "Host '$host' not in tailnet"
                else
                    echo "Added '$host'"
                    echo "$host" >> "$home/.config/.secrets/hostnames.txt"
                fi 
            done
        fi
    fi
}

### Install the starship shell ###
install_starship() {
    read -rep 'Would you like to install the starship shell? [Y/n]' STAR
    if [[ $STAR == "Y" || $STAR == "y" ]] || [ -z "$STAR" ] ; then
        # install the starship shell
        echo -e "Backing up existing .bashrc and starship files"
        mv "$home/.bashrc" "$home/.bashrc.bak"
        mv "$home/.config/starship.toml" "$home/.config/starship.toml.bak"  
        echo -e "Updating .bashrc"
        echo -e '\neval "$(starship init bash)"' >> ".bashrc"
        echo -e "copying starship config file to '$home/.config' ...\n"
        cp .bashrc "$home/.bashrc"
        cp starship.toml "$home/.config/starship.toml"
    fi
}

### Install optionals programs ###
install_apps() {
    read -rep 'Would you like to install optional programs? [y/N]' APP
    if [[ $APP == "Y" || $APP == "y" ]] ; then
        cat applications | sed 's/#.*//' | yay -S --noconfirm
        # todo config hypr keybinds in with 'applications' file
    fi
}

### Script is done ###
close_script() {
    echo -e "Script has completed.\n"
    echo -e "You can start Hyprland by typing Hyprland (note the capital H).\n"
    read -n1 -rep 'Would you like to start Hyprland now? [Y/n]' HYP
    if [[ $HYP == "Y" || $HYP == "y" ]] || [ -z "$HYP" ] ; then
        exec Hyprland
    else
        exit
    fi
}

main() {
    echo -en "Initial checks"
    check_home $1
    echo -en "Will attempt to install the configs in $home"

    check_git
    check_yay

    disable_wifi_powersave

    echo -en "Starting installation"

    install_dependencies
    copy_configs

    enable_wol_waybar
    enable_tailscale_waybar

    install_starship
    install_apps

    close_script
}

main $usercfg
