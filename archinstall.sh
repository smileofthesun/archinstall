#!/bin/bash

sudo pacman -Syu --noconfirm
sudo pacman -S reflector rsync

echo "Enter your desired country for the mirrorlist:"
read country
sudo reflector --country "$country" --sort rate --save /etc/pacman.d/mirrorlist

sudo pacman -S --noconfirm --needed - < packagelist

cd $HOME

git clone https://git.suckless.org/dwm
git clone https://github.com/LukeSmithxyz/st.git
git clone https://github.com/LukeSmithxyz/dmenu.git


echo "exec dwm &" >> .xinitrc
