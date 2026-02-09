#!/bin/bash

echo "Pacman updates:"
checkupdates
echo "AUR updates:"
yay -Qua
read -n1 -rep 'Update the system? [Y/n]' UPD
if [[ $UPD == "Y" || $UPD == "y" ]] || [ -z $UPD ] ; then
    yay --noconfirm -Syu
fi