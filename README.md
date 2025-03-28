# My dotfiles
...and an installation script for a fresh linux with yay, hyprland and waybar. 


![screen](./showcases/moon-over-mondstat-showcase.png)
_I like rice, but i prefer pasta_    

> [!NOTE]
> This rice is heavily inspired (copied) from [SolDoesTech](https://github.com/soldoestech)'s hyprland repos, check those if you'd like a probably better tested config. If there are any issues with the [hyprland](https://wiki.hyprland.org/) and [waybar](https://github.com/Alexays/Waybar/wiki/) configuration, before opening an issue, check with the wikis as i have no idea what i'm doing, also don't trust random installation scripts online :). If there are issues with the installation scripts report it here ty. 

Clone the repository to copy and use these configuration files. 

```sh
git clone https://github.com/00Darxk/dotfiles.git
cd dotfiles
```

I will make another branch, and move the italian version there. For now you'll need to make the changes yourself to change the language in these configs: [installupdates.sh](./waybar/scripts/installaupdates.sh),  [hyprland.conf](./hypr/hyprland.conf) under input select your keyboard layout, [waybar](/waybar/modules.jsonc) modules, [wlogout](./wlogout/layout), [wofi](./wofi/config), [starship.toml](./starship.toml). These changes are purely aesthetics. 

# Installation

## Automatic

Run the [install script](./install.sh), it will try to install all needed [dependencies](#dependencies) 
> [!CAUTION]
> This script DOES NOT backup any config files you may have, it is meant for a fresh install. Use it if you know what you are doing. 

```sh
install.sh
```
Yay need to be installed, as its used by the script to install all the packages. Refer to the official [yay page](https://github.com/Jguer/yay?tab=readme-ov-file#installation) for installation.  

## Manual

Below a table of each package that should be installed, and its purpose. If you choose to install another package for the same purpose, you should also check the corresponding configuration files. 

### Dependencies

#### Pacman packages

| Package                   | Description |
| ------------------------- | ----------- |
| `hyprland`                | Hyprland compositor |
| `kitty`                   | Default terminal |
| `waybar`                  | Customizable Wayland bar |
| `swaybg`                  | Used to set a desktop background image |
| `swaylock-effects`        | Allow to lock the screen, fork that adds visual effects |
| `wofi`                    | Application launcher menu |
| `wlogout`                 | Logout menu |
| `swaync`                  | Graphical notification daemon |
| `thunar`                  | Graphical file manager |
| `ttf-jetbrains-mono-nerd` | Some nerd fonts for icons and overall look |
| `polkit-gnome`            | Graphical superuser, needed for some applications |
| `starship`                | Customizable shell prompt |
| `swappy`                  | Screenshot editor tool |
| `grim`                    | Screenshot tool, it grabs images from a Wayland compositor |
| `slurp`                   | Selects a region in a Wayland compositor, used to screenshot |
| `paximer`                 | Pulseaudio command line mixer |
| `brightnessctl`           | Program to read and contro device brightness |
| `gvfs`                    | Adds missing feature to thunar |
| `bluez`                   | Bluetooth protocol stack |
| `bluez-utils`             | Command line utilities to interact with bluetooth devices |
| `nwg-look`                | GTK3 settings editor adapter |
| `xfce4-settings`          | Set of tools for xfce, needed to set GTK theme | <!-- TODO check if really needed -->
| `xdg-desktop-portal-hyprland` | `xdg-desktop-portal` backend for hyprland |
| `wl-gammarelay`           | Client and daemon for changing color temperature and brightness under wayland |
| `hyfetch`                 | Fork of neofetch with LGBTQ+ pride flags |
| `power-profiles-daemon`   | Maked power profiles handling over D-Bus |
| `sddm`                    | Login manager |
| `tff-fira-code`           | Free monospace font with programming ligatures |
| `tff-font-awesome`        | Icon font for waybar |
| `wol`                     | Wake-on-LAN tool for both CLI and web interfaces |
| `jq`                      | CLI JSON processor |
| `btop`                    | Monitor of system resources |
| `telegram-desktop`        | Official Telegram Desktop client |
| `discord`                 | All-in-one voice and text chat for games |
| `steam`                   | Valve's digital software delivery system | 
| `spotify-launcher`        | Client for spotify's apt repository |
| `chromium`                | Web browser |
| `tailscale`               | Mesh VPN |


```sh
pacman -S hyprland kitty waybar swaybg swaylock-effects wofi wlogout swaync thunar ttf-jetbrains-mono-nerd polkit-gnome starship swappy grim slurp paximer brightnessctl gvfs bluez bluez-utils nwg-look xfce4-settings xdg-desktop-portal-hyprland wl-gammarelay hyfetch power-profiles-daemon sddm tff-fira-code tff-font-awesome wol telegram-desktop discord steam spotify-launcher chromium tailscale
```

#### AUR packages
| Package | Description |
| ------- | ----------- |
| `dracula-gtk-theme`       | Default theme |
| `dracula-icons-git`       | Default icons |
| `sddm-eucalyptus-drop`    | Sddm theme    |
| `notion-app-electron`     | Connected workspaces |
| `vscodium-bin`            | Binary releases of VS Code without MS branding/telemetry/licensing |
| `whatsdesk-bin`           | Unofficial client of Whatsapp

```sh
yay -S dracula-gtk-theme dracula-icons-git sddm-eucalyptus-drop notion-app-electron vscodium-bin whatsdesk-bin
```
Or your AUR helper of choice. 

#### Optional

Here is a list of useful and funny packages: 

| Package | Description |
| ------- | ----------- |
| `fzf`   | CLI fuzzy finder |
| `cowsay` | Configurable talking cow |
| `fortune-mod` | Fortune cookie program from BSG games |
| `pipes.sh`<sup>AUR</sup> | Animated pipes terminal screensaver |

```sh
yay -S fzf cowsay fortune-mod pipes.sh
```

### Config

Copy the configs to the `~/.config` folder:
```bash
cp -R hypr ~/.config/
cp -R kitty ~/.config/
cp -R neofetch ~/.config/
cp -R swaylock ~/.config/
cp -R waybar ~/.config/
cp -R wlogout ~/.config/
cp -R wofi ~/.config/
cp hyfetch.json ~/.config/
cp .bashrc ~/.config/
cp starship.toml ~/.config/
``` 

Set files as executable:
```bash
chmod +x ~/.config/hypr/xdg-portal-hyprland
chmod +x ~/.config/waybar/scripts/*
```

Enables services:
```bash
sudo systemctl enable tailscaled
sudo systemctl enable --now bluetooth.service
```

See [WoL and Tailscale](#wake-on-lan-and-tailscale-module) and [GitHub Notification](#github-notifications-module) section to manually configure the modules. 

# Overview

## Hyprland

### Keybindings

You can check the keybinds in the [hyprland config](./hypr/hyprland.conf), or on the table below. It contains explicit keybinds for F1 to F6 function keys and multimedia keys, although they should all work out of the box; if there are issues check your keyboard on the [wiki](https://wiki.archlinux.org/title/Extra_keyboard_keys). 

| Keybind                  | Action                                            |
| ------------------------ | ------------------------------------------------- |
| `Win+Q`                  | Open Kitty terminal                               |
| `Win+W`                  | Kill active window                                |
| `Win+L`                  | Lock the screen, using swaylock                   |
| `Win+M`                  | Show the logout screen, using wlogout             |
| `Win+Shift+M`            | Exit the Hyrpland environment                     |
| `Win+V`                  | Toggle on/off floating for the active window      |
| `Win+Space`              | Show the graphical app launcher wofi              |
| `Win+S`                  | Take a screenshot                                 |
| `Win+Shift+B`            | Reload waybar                                     |
| `Win+1~9`                | Open Thunar (1), WhatsDesk (2), Chromium (3), Discord (4), Telegram Desktop (5), Steam (6), none (7), VSCodium (8), Spotify Launcher (9) |
| `Win+Ctrl+0`             | Reset screen temperature to 6500K                 |
| `Win+Ctrl+Up`            | Increase screen temperature by 500K               |
| `Win+Ctrl+Down`          | Decrease screen temperature by 500K               |
| `Win+Up/Down/Left/Right` | Move through the active workspace                 |
| `Alt+Tab`                | Cycle through windows on same workspace           |
| `Alt+Shift+Tab`          | Cycle through windows on same workspace (reverse) |
| `Win+Tab`                | Switches to previous active workspace             |
| `Win+F1~F12`             | Change to **n**th workspace, up to 12             |
| `Win+Shift+F1~F12`       | Move current window to **n**th workspace, up to 12|
| `Win+Scroll-Down/Up`     | Scroll through existing workspaces                |
| `Win+LMB`                | Move window with dragging                         |
| `Win+RMB`                | Resize window with dragging                       |
| `Win+Shift+Space+1~4`      | Change background to [Moon Over Mondstat](./hypr/moon-over-mondstat.jpg) (1), [Sucrose](./hypr/sucrose.jpg) (2), [Sayu Birthday Without Characters](./hypr/sayu-without-char.jpg) (3), [Xiao](./hypr/xiao.jpg) (4) |


### Wallpapers

<div class="grid" markdown>

![1](./showcases/moon-over-mondstat-showcase.png)

![1](./showcases/sucrose-showcase.png)

![1](./showcases/sayu-showcase.png)

![1](./showcases/xiao-showcase.png)

</div>

Credit to [Shade of a cat](https://shadeofacat.carrd.co/) and [Sevenics](https://www.deviantart.com/sevenics) for the amazing arts! 
> [!NOTE]
> I don't remember why I converted all the backgrounds from png to jpg, it should work either way. Too lazy to check the wiki. 

To add a new wallpaper to hyprland, add a line at the end of the [hyprland.conf](./hypr/hyprland.conf) file, specifying the location of the image. 
To set it at start, change the location of the exec call inside the [config](./hypr/hyprland.conf) to the background image. 

In the same way you can edit the top line of the [swaylock config](./swaylock/config) to change the background image. 

## Waybar 
<!-- TODO add module description, link to wiki -->
### Default Modules

### Hyprland Modules

### Wake on LAN and Tailscale Module
If you'd like to use the waybar module to wake a machine over LAN either follow the instructions in the installation scripts or create the ```./secrets``` folder, the ```ip-address.txt``` and ```mac-address.txt``` files.

The [wol.sh](./waybar/scripts/wol.sh) sends a magic packet to the machine, using the [wol](https://sourceforge.net/projects/wake-on-lan/) package. Change the script if you would like to use a different application. 

 the same module can be used to ssh into another machine using tailscale, for this create the ```hostname.txt``` file inside the secret folder with the hostname or the ip address in your tailscale network. For simplicity both these functions refer to the same machine. 
You can just comment out or remove the module in [waybar config](./waybar/config.jsonc) if you don't use it. If you haven't configured it, it will not show in waybar. 

To WoL left-click the module, to ssh right-click it; the color of the module shows the tailscale status of the machine you configured, not if the machine itself is on or off. If you have enabled tailscaled on the machine it will show the machine status, as it starts on startup. If you have set different machines for WoL and ssh the tooltip refers only to the ssh machine.

### GitHub Notifications Module

Instructions in the waybar [wiki](https://github.com/Alexays/Waybar/wiki/Module:-Custom:-Simple#github-notifications). Place the ```notifications.token``` inside the ```.secrets``` folder. 

## Themes

I tried to base it off this color scheme, but I'm not really good with that, if someone who knows colors could help I'd be very thankful :). 

I use [squared theme](https://www.gnome-look.org/p/2206255) for gtk, and [ant-dark](https://store.kde.org/p/1640981/) icons theme. To add themes and icon themes download and unzip theme respectively in ```~/.themes``` and ```~/.local/share/icons```, use this last directory to store cursor icons (i use my oshi [Rin Penrose](https://www.gnome-look.org/p/2260618)'s)

For `sddm` I use the [eucalyptus-drop](https://gitlab.com/Matt.Jolly/sddm-eucalyptus-drop) theme, it is available on the AUR, and installed through the [install script](./install.sh). 

# To-Dos
  - [x] Working To-Dos
  - [x] Test the installation script :3 
  - [x] Add usefull information in the README
    - [ ] Module description
  - [ ] Create a version with english toolip in waybar
  - [ ] Improve installation script
    - [ ] Add the option to choose which language to use in the installation script
    - [ ] Backup previous config files
  - [ ] Create standalone module config for each waybar module


# Contributions
...and suggestions are welcome, just open an issue or a pull request :)

# See Also

[SolDoesTech](https://github.com/soldoestech)'s hyprland configs, the [hyprland](https://wiki.hyprland.org/) and [waybar](https://github.com/Alexays/Waybar/wiki/) wikis. [Shade of a cat](https://shadeofacat.carrd.co/) and [Sevenics](https://www.deviantart.com/sevenics) amazing art. 