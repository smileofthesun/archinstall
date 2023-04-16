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
git clone https://github.com/smileofthesun//slock.git ~/.local/src/slock
git clone https://github.com/smileofthesun/slstatus.git  ~/.local/src/slstatus
git clone https://github.com/smileofthesun/nsxiv.git ~/.local/src/nsxiv

sudo make -C ~/.local/src/dwm install
sudo make -C ~/.local/src/st install
sudo make -C ~/.local/src/dmenu install
sudo make -C ~/.local/src/slock install
sudo make -C ~/.local/src/slstatus install
sudo make -C ~/.local/src/nsxiv install

git clone https://github.com/smileofthesun/dotfiles.git
rsync -av --exclude='.git' ~/dotfiles/ ~/
rm -rf ~/dotfiles
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting ~/.config/shell/fast-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.config/shell/zsh-autosuggestions

chsh -s $(which zsh)

sudo bash -c 'cat > /etc/X11/xorg.conf.d/00-keyboard.conf <<- EOM
Section "InputClass"
        Identifier "system-keyboard"
        MatchIsKeyboard "on"
        Option "XkbLayout" "sv"
        Option "XkbModel" "pc105
EndSection
EOM'

