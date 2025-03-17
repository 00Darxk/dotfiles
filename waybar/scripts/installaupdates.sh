echo "Lista aggiornamenti pacman":
pacman -Qu
echo "Scarico..."
sudo pacman -Syu
echo "Lista aggiornamenti AUR":
trizen -Su --aur --quiet