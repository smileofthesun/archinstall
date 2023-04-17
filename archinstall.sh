#!/bin/bash

sudo pacman -Syu --noconfirm
#sudo pacman -S --noconfirm reflector rsync

echo "Skip on Artix
Enter your desired country for the mirrorlist (leave empty to skip):"
read country

if [ -n "$country" ]; then
    sudo reflector --country "$country" --sort rate --save /etc/pacman.d/mirrorlist
else
    echo "Skipping mirrorlist configuration..."
fi

refreshkeys() {
	case "$(readlink -f /sbin/init)" in
	*systemd*)
		whiptail --infobox "Refreshing Arch Keyring..." 7 40
		pacman --noconfirm -S archlinux-keyring >/dev/null 2>&1
		;;
	*)
		whiptail --infobox "Enabling Arch Repositories for more a more extensive software collection..." 7 40
		if ! grep -q "^\[universe\]" /etc/pacman.conf; then
			echo "[universe]
Server = https://universe.artixlinux.org/\$arch
Server = https://mirror1.artixlinux.org/universe/\$arch
Server = https://mirror.pascalpuffke.de/artix-universe/\$arch
Server = https://artixlinux.qontinuum.space/artixlinux/universe/os/\$arch
Server = https://mirror1.cl.netactuate.com/artix/universe/\$arch
Server = https://ftp.crifo.org/artix-universe/" >>/etc/pacman.conf
			pacman -Sy --noconfirm >/dev/null 2>&1
		fi
		pacman --noconfirm --needed -S \
			artix-keyring artix-archlinux-support >/dev/null 2>&1
		for repo in extra community; do
			grep -q "^\[$repo\]" /etc/pacman.conf ||
				echo "[$repo]
Include = /etc/pacman.d/mirrorlist-arch" >>/etc/pacman.conf
		done
		pacman -Sy >/dev/null 2>&1
		pacman-key --populate archlinux >/dev/null 2>&1
		;;
	esac
}

awk '!/^#/ {print $1}' packagelist | sudo pacman -S --noconfirm --needed -

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

git clone https://github.com/smileofthesun/dotfiles.git ~/dotfiles
rsync -av --exclude='.git' ~/dotfiles/ ~/
rm -rf ~/dotfiles
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting ~/.config/shell/fast-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.config/shell/zsh-autosuggestions

sudo chsh -s $(which zsh) $USER

sudo bash -c 'cat > /etc/X11/xorg.conf.d/00-keyboard.conf <<- EOM
Section "InputClass"
        Identifier "system-keyboard"
        MatchIsKeyboard "on"
        Option "XkbLayout" "se"
        Option "XkbModel" "pc105
EndSection
EOM'

sudo bash -c 'cat >> /etc/pam.d/login <<- EOM

# Gnome Keyring
session    optional     pam_gnome_keyring.so auto_start
auth       optional     pam_gnome_keyring.so
EOM'

cd
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -fsri
cd

yay -S --noconfirm gajim-plugin-omemo

sudo dinitctl 
