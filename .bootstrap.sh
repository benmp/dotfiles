#!/bin/sh

statusprint() {
  printf "\n"
  printf "\033[${2:-1;34}%s\033[0m\n" "**********"
  printf "\033[${2:-1;34}%s\033[0m\n" "*"
  printf "\033[${2:-1;34}%s\033[0m\n" "*  $1"
  printf "\033[${2:-1;34}%s\033[0m\n" "*"
  printf "\033[${2:-1;34}%s\033[0m\n" "**********"
  printf "\n"
}

statusprint "upgrading all currently installed arch packages"
sudo pacman -Syu
statusprint "installing git for dotfiles grab"
sudo pacman -S --needed git

if [ ! -d "$HOME/.dotfiles" ]; then
  statusprint "cloning dotfiles"
  cd "$HOME"
  printf '%s\n' ".cfg" >> .gitignore
  git clone https://github.com/runbmp/dotfiles.git "$HOME/.dotfiles"
  /usr/bin/git --git-dir="$HOME/.dotfiles/.git" --work-tree="$HOME" config --local status.showUntrackedFiles no
fi

statusprint "checking out and updating dotfiles"
/usr/bin/git --git-dir="$HOME/.dotfiles/.git" --work-tree="$HOME" checkout master
/usr/bin/git --git-dir="$HOME/.dotfiles/.git" --work-tree="$HOME" pull

statusprint "source zshrc for environment variables"
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
linux \
linux-firmware \
linux-lts \
htop \
interception-caps2esc \
openssh \
refind \
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

statusprint "installing arch_packages: $arch_packages"
sudo pacman -S --needed $(echo "$arch_packages")

if [ -x "$(command -v yay)" ]; then
  statusprint "installing yay aur helper"      
  git clone https://aur.archlinux.org/yay.git
  cd yay || exit
  makepkg -si
  cd ../
  rm -rf yay
else
  statusprint "yay aur helper already exists"
fi

statusprint "upgrading all currently installed aur packages"
yay -Syu --aur


statusprint "installing aur_packages: $aur_packages"
yay -S --needed $(echo "$aur_packages")

udevmon_yaml="\
- JOB: intercept -g $DEVNODE | caps2esc | uinput -d $DEVNODE
  DEVICE:
    EVENTS:
      EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
"
statusprint "create caps2esc interception tools file"
printf '%s\n' "$udevmon_yaml" | sudo tee /etc/interception/udevmon.yaml

statusprint "starting udevmon service"
sudo systemctl enable --now udevmon

if ! [ -x "$(command -v n-update)" ]; then
  statusprint "installing n to manage node versions"
  curl -L https://git.io/n-install | N_PREFIX=~/.n bash -s -- -y -
fi

statusprint "update n and use it to install node 10.24.0"
. "$HOME/.zshrc" && n-update -y && n 10.24.0
