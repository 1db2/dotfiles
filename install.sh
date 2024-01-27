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

cp -r "$HOME/dotfiles/.config/i3/scripts" "$HOME/.config/i3"
cp -r "$HOME/dotfiles/.config/i3/wallpapers" "$HOME/.config/i3/"

mkdir "$HOME/.config/kitty/"
cp "$HOME/dotfiles/.config/kitty/kitty.conf" "$HOME/.config/kitty"

mkdir "$HOME/.config/picom/"
cp "$HOME/dotfiles/.config/picom/picom.conf" "$HOME/.config/picom/"

mkdir "$HOME/.config/polybar/"
cp -r "$HOME/dotfiles/.config/polybar/scripts" "$HOME/.config/polybar/"
cp "$HOME/dotfiles/.config/polybar/config.ini" "$HOME/.config/polybar/"
cp "$HOME/dotfiles/.config/polybar/launch.sh" "$HOME/.config/polybar/"

mkdir "$HOME/.config/rofi/
cp -r "$HOME/dotfiles/.config/rofi/bin/" "$HOME/.config/rofi/"
cp -r "$HOME/dotfiles/.config/rofi/config" "$HOME/.config/rofi/"
