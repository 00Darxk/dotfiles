echo "Lista aggiornamenti pacman":
checkupdates
echo "Lista aggiornamenti AUR":
yay -Qua
read -n1 -rep 'Scaricare aggiornamenti? (s,n)' UPD
if [[ $UPD == "S" || $UPD == "s" ]]; then
    yay -Syu
fi