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

cp -r "/home/"~username"/dotfiles/.config/i3/scripts" "/home/"~username"/.config/i3"
cp -r "/home/"~username"/dotfiles/.config/i3/wallpapers" "/home/"~username"/.config/i3/"
cp "/home/"~username"/dotfiles/.config/i3/config" "/home/"~username"/.config/i3"

mkdir "/home/"~username"/.config/kitty/"
cp "/home/"~username"/dotfiles/.config/kitty/kitty.conf" "/home/"~username"/.config/kitty"

mkdir "/home/"~username"/.config/picom/"
cp "/home/"~username"/dotfiles/.config/picom/picom.conf" "/home/"~username"/.config/picom/"

mkdir "/home/"~username"/.config/polybar/"
cp -r "/home/"~username"/dotfiles/.config/polybar/scripts" "/home/"~username"/.config/polybar/"
cp "/home/"~username"/dotfiles/.config/polybar/config.ini" "/home/"~username"/.config/polybar/"
cp "/home/"~username"/dotfiles/.config/polybar/launch.sh" "/home/"~username"/.config/polybar/"

mkdir "/home/"~username"/.config/rofi/
cp -r "/home/"~username"/dotfiles/.config/rofi/bin/" "/home/"~username"/.config/rofi/"
cp -r "/home/"~username"/dotfiles/.config/rofi/config" "/home/"~username"/.config/rofi/"
