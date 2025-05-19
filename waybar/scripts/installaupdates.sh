echo "pacman updates":
checkupdates
echo "AUR updates":
yay -Qua
read -n1 -rep 'Install updates? (y,n)' UPD
if [[ $UPD == "Y" || $UPD == "y" ]]; then
    yay --noconfirm -Syu
fi