#!/bin/sh

printf '\033[1;34m%s\n' "upgrading all currently installed arch packages"
sudo pacman -Syu

printf '\033[1;34m%s\n' "installing git for dotfiles grab"
sudo pacman -S --needed git

if [ ! -d "$HOME/.dotfiles" ]; then
  printf '\033[1;34m%s\n' "cloning dotfiles"
  cd "$HOME"
  printf '%s\n' ".cfg" >> .gitignore
  git clone https://github.com/runbmp/dotfiles.git "$HOME/.dotfiles"
  /usr/bin/git --git-dir="$HOME/.dotfiles/.git" --work-tree="$HOME" config --local status.showUntrackedFiles no
fi

printf '\033[1;34m%s\n' "checking out and updating dotfiles"
/usr/bin/git --git-dir="$HOME/.dotfiles/.git" --work-tree="$HOME" checkout master
/usr/bin/git --git-dir="$HOME/.dotfiles/.git" --work-tree="$HOME" pull

. "$HOME/.zshrc"

arch_packages="\
base \
base-devel \
bat \
bemenu-wlroots \
btrfs-progs \
chromium \
curl \
efibootmgr \
firefox \
fzf \
git \
grub \
linux \
linux-firmware \
linux-lts \
htop \
interception-caps2esc \
openssh \
ripgrep \
sway \
vi \
wget \
wireguard-tools \
zsh \
"

aur_packages="\
neovim-nightly-bin
termite-nocsd
visual-studio-code-bin
"

printf '\033[1;34m%s\n' "installing arch_packages: $arch_packages"
sudo pacman -S --needed $(echo "$arch_packages")

if [ -x "$(command -v yay)" ]; then
  printf '\033[1;34m%s\n' "installing yay aur helper"      
  git clone https://aur.archlinux.org/yay.git
  cd yay || exit
  makepkg -si
  cd ../
  rm -rf yay
else
  printf '\033[1;34m%s\n' "yay aur helper already exists"
fi

printf '\033[1;34m%s\n' "upgrading all currently installed aur packages"
yay -Syu --aur


printf '\033[1;34m%s\n' "installing aur_packages: $aur_packages"
yay -S --needed $(echo "$aur_packages")

udevmon_yaml="\
- JOB: intercept -g $DEVNODE | caps2esc | uinput -d $DEVNODE
  DEVICE:
    EVENTS:
      EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
"
printf '\033[1;34m%s\n' "create caps2esc interception tools file"
printf '%s\n' "$udevmon_yaml" | sudo tee /etc/interception/udevmon.yaml

printf '\033[1;34m%s\n' "starting udevmon service"
sudo systemctl enable --now udevmon

if ! [ -x "$(command -v n-update)" ]; then
  printf '\033[1;34m%s\n' "installing n to manage node versions"
  curl -L https://git.io/n-install | N_PREFIX=~/.n bash -s -- -y -
else
  printf '\033[1;34m%s\n' "update n and use it to install node 10.24.0"
  . "$HOME/.zshrc" && n-update -y && n 10.24.0
fi
