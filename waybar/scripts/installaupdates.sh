echo "Lista aggiornamenti pacman":
checkupdates
echo "Lista aggiornamenti AUR":
yay -Qua
read -n1 -rep 'Scaricare aggiornamenti? (s,n)' UPD
if [[ $UPD == "Y" || $UPD == "y" ]]; then
    yay -Syu
fi