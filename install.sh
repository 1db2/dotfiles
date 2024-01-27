#!/bin/bash

apps=("kitty" "polybar" "rofi" "polkit" "polkit-kde-agent" "feh" "flameshot" "meson" "ninja" "libconfig" "uthash" "python-i3ipc" "playerctl")

not_installed=()

is_installed() {
    pacman -Qi "$1" &>/dev/null
}

install() {
    sudo pacman -S "$1" --noconfirm
}

for app in "${apps[@]}"; do
  if ! is_installed $app; then
    not_installed+=("$app")
  fi
done

for app in "${not_installed[@]}"; do
  install $app
done

#picom with animations
git clone https://github.com/pijulius/picom.git
cd picom/
git submodule update --init --recursive
meson --buildtype=release . build
ninja -C build
ninja -C build install
cd ..
rm -rf picom/

#copying dotfiles
cd

cp -r ~/dotfiles/.config/i3/scripts ~/.config/i3
cp -r ~/dotfiles/.config/i3/wallpapers ~/.config/i3/

mkdir ~/.config/kitty/
cp ~/dotfiles/.config/kitty/kitty.conf ~/.config

mkdir ~/.config/picom/
cp ~/dotfiles/.config/picom/picom.conf ~/.config/picom/

mkdir ~/.config/polybar/
cp -r ~/dotfiles/.config/polybar/scripts ~/.config/polybar/
cp ~/dotfiles/.config/polybar/config.ini ~/.config/polybar/
cp ~/dotfiles/.config/polybar/launch.sh ~/.config/polybar/

mkdir ~/.config/rofi/
cp -r ~/dotfiles/.config/rofi/bin/ ~/.config/rofi/
cp -r ~/dotfiles/.config/rofi/config ~/.config/rofi/
