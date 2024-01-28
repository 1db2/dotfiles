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
rm -rf picom/e
#copying dotfiles

home="$(getent passwd $SUDO_USER | cut -d: -f6 | grep -i 'home')"

cd
cp -r "$home/dotfiles/.config/i3/scripts" "$home/.config/i3"
cp -r "$home/dotfiles/.config/i3/wallpapers" "$home/.config/i3/"
cp "$home/dotfiles/.config/i3/config" "$home/.config/i3"

mkdir "$home/.config/kitty/"
cp "$home/dotfiles/.config/kitty/kitty.conf" "$home/.config/kitty"

mkdir "$home/.config/picom/"
cp "$home/dotfiles/.config/picom/picom.conf" "$home/.config/picom/"

mkdir "$home/.config/polybar/"
cp -r "$home/dotfiles/.config/polybar/scripts" "$home/.config/polybar/"
cp "$home/dotfiles/.config/polybar/config.ini" "$home/.config/polybar/"
cp "$home/dotfiles/.config/polybar/launch.sh" "$home/.config/polybar/"

mkdir "$home/.config/rofi/
cp -r "$home/dotfiles/.config/rofi/bin/" "$home/.config/rofi/"
cp -r "$home/dotfiles/.config/rofi/config" "$home/.config/rofi/"
