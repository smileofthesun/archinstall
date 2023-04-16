#!/bin/bash

sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm reflector rsync

echo "Enter your desired country for the mirrorlist (leave empty to skip):"
read country

if [ -n "$country" ]; then
    sudo reflector --country "$country" --sort rate --save /etc/pacman.d/mirrorlist
else
    echo "Skipping mirrorlist configuration..."
fi


awk '!/^#/ {print $1}' packagelist | sudo pacman -S --noconfirm --needed -

cd $HOME

git clone https://github.com/smileofthesun/dwm.git ~/.local/src/dwm
git clone https://github.com/smileofthesun/st.git ~/.local/src/st
git clone https://github.com/smileofthesun/dmenu.git ~/.local/src/dmenu
git clone https://git.suckless.org/slock ~/.local/src/slock
git clone https://git.suckless.org/slstatus ~/.local/src/slstatus
git clone https://github.com/nsxiv/nsxiv.git ~/.local/src/nsxiv

sudo make -C ~/.local/src/dwm install
sudo make -C ~/.local/src/st install
sudo make -C ~/.local/src/dmenu install
sudo make -C ~/.local/src/slock install
sudo make -C ~/.local/src/slstatus install
sudo make -C ~/.local/src/nsxiv install

echo "exec dwm &" >> .xinitrc
