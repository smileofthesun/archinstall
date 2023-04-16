#!/bin/bash

sudo pacman -Syu --noconfirm
sudo pacman -S reflector rsync

echo "Enter your desired country for the mirrorlist:"
read country
sudo reflector --country "$country" --sort rate --save /etc/pacman.d/mirrorlist

awk '!/^#/ {print $1}' packagelist | sudo pacman -S --noconfirm --needed -

cd $HOME

git clone https://git.suckless.org/dwm ~/.local/src/dwm
git clone https://github.com/smileofthesun/st.git ~/.local/src/dwm
git clone https://github.com/smileofthesun/dmenu.git ~/.local/src/dwm
git clone https://git.suckless.org/slock ~/.local/src/dwm
git clone https://git.suckless.org/slstatus ~/.local/src/dwm

sudo make -C ~/.local/src/dwm install
sudo make -C ~/.local/src/st install
sudo make -C ~/.local/src/dmenu install
sudo make -C ~/.local/src/slock install
sudo make -C ~/.local/src/slstatus install

echo "exec dwm &" >> .xinitrc
