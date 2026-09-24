update="Update system?"

read -n1 -rep "$update (Y,n)" UPD
if [[ $UPD == "Y" || $UPD == "y" ]] || [ -z "$UPD" ]; then
    yay --noconfirm -Syu
fi