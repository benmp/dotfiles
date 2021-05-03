#!/bin/sh

statusprint() {
  printf "\n"
  printf "\033[%sm**********\033[0m\n" "${2:-1;34}"
  printf "\033[%sm*\033[0m\n" "${2:-1;34}"
  printf "\033[%sm* %s\033[0m\n" "${2:-1;34}" "$1"
  printf "\033[%sm*\033[0m\n" "${2:-1;34}"
  printf "\033[%sm**********\033[0m\n" "${2:-1;34}"
  printf "\n"
}

sudo systemctl enable --now NetworkManager.service
ping_gw() { 
  ping -q -w 1 -c 1 "$(ip r | grep default | cut -d ' ' -f 3)" > /dev/null && return 0 || return 1 
}
ping_gw || ((statusprint "no network, fix first with nmtui" "0;31") && exit 1)


#vi /etc/iwd/main.conf
#[General]
#EnableNetworkConfiguration=true
systemctl enable --now iwd
systemctl enable --now systemd-resolved.service
#iwctl
#TODO commands to connect to wifi


statusprint "enable multilib in pacman"
sed -i 's/^#[multilib]/[multilib]/' /etc/pacman.conf
sed -i '/[multilib]/!b;n;cInclude = /etc/pacman.d/mirrorlist' /etc/pacman.conf

statusprint "upgrading all currently installed arch packages"
sudo pacman -Syu

statusprint "reflector update for pacman mirrors"
sudo pacman -S reflector
sudo reflector --verbose --country US --latest 5 --protocol https --sort rate --save /etc/pacman.d/mirrorlist


statusprint "installing git for dotfiles grab"
sudo pacman -S git

if [ ! -d "$HOME/.dotfiles" ]; then
  statusprint "cloning dotfiles"
  cd "$HOME"
  printf '%s\n' ".dotfiles" > .gitignore
  git clone --bare https://github.com/runbmp/dotfiles.git "$HOME/.dotfiles"
fi

statusprint "checking out and updating dotfiles"
/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" checkout

statusprint "source zshrc for environment variables"
. "$HOME/.zshrc"

#TODO arrange by function
arch_packages="\
amd-ucode \
base \
base-devel \
bat \
bemenu-wlroots \
bluez \
bluez-utils \
btrfs-progs \
chntpw \
chromium \
curl \
efibootmgr \
fd \
firefox \
fzf \
git \
grim \
grub \
grub-btrfs \
inetutils \
libva-mesa-driver \
libnotify \
linux \
linux-firmware \
linux-lts \
htop \
interception-caps2esc \
mako \
man-db \
mesa \
mesa-vdpau \
noto-fonts \
noto-fonts-cjk \
noto-fonts-emoji \
noto-fonts-extra \
ntfs-3g \
openssh \
os-prober \
p7zip \
pavucontrol \
pipewire \
pipewire-alsa \
pipewire-pulse \
python \
python-pip \
python-pynvim
ranger \
reflector \
ripgrep \
slurp \
snap-pac \
snapper \
sway \
vi \
vulkan-icd-loader \
vulkan-radeon \
waybar \
wget \
wireguard-tools \
wl-clipboard \
xorg-xeyes \
xorg-xwayland \
zsh \
"

aur_packages="\
flashfocus-git \
neovim-nightly-bin \
nerd-fonts-dejavu-complete \
openmw-git \
wev-git \
"

statusprint "installing arch_packages: $arch_packages"
sudo pacman -S --needed $(echo "$arch_packages")

if [ -x "$(command -v paru)" ]; then
  statusprint "installing paru aur helper"      
  git clone https://aur.archlinux.org/paru.git
  cd paru || exit
  makepkg -si
  cd ../
  rm -rf paru
else
  statusprint "paru aur helper already exists"
fi

statusprint "upgrading all currently installed aur packages"
paru -Syu --aur

statusprint "installing aur_packages: $aur_packages"
paru -S $(echo "$aur_packages")

statusprint "create caps2esc interception tools file"
UDEVMON_YAML="\
- JOB: intercept -g $DEVNODE | caps2esc | uinput -d $DEVNODE
  DEVICE:
    EVENTS:
      EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
"
printf '%s\n' "$UDEVMON_YAML" | sudo tee /etc/interception/udevmon.yaml

statusprint "starting udevmon service"
sudo systemctl enable --now udevmon

if ! [ -x "$(command -v n-update)" ]; then
  statusprint "installing n to manage node versions"
  curl -L https://git.io/n-install | N_PREFIX=~/.n bash -s -- -y -
fi
statusprint "update n and use it to install node 10.24.0"
. "$HOME/.zshrc" && n-update -y && n 10.24.0

statusprint "disable internal pc speaker for terrible beep noises"
echo "blacklist pcspkr" | sudo tee /etc/modprobe.d/nobeep.conf

statusprint "setup snapper, manual snapshots on root only"
sudo umount /.snapshots
sudo rm -r /.snapshots
sudo snapper -c root create-config /
sudo btrfs subvolume delete /.snapshots
sudo mkdir /.snapshots
sudo mount -a
sudo chmod 750 /.snapshots/
sed -i 's/^ALLOW_USERS=""/ALLOW_USERS="ben"/' /etc/snapper/configs/root
#sed -i 's/^NUMBER_CLEANUP="no"/NUMBER_CLEANUP="yes"/' /etc/snapper/configs/root
sed -i 's/^TIMELINE_CREATE="yes"/TIMELINE_CREATE="no"/' /etc/snapper/configs/root
sed -i 's/^TIMELINE_CLEANUP="yes"/TIMELINE_CLEANUP="no"/' /etc/snapper/configs/root
#TODO remove this if I ever install cron and make sure cron cleanup is running
#sudo systemctl enable --now snapper-cleanup.timer
pacman -S grub-btrfs rsync
systemctl enable --now grub-btrfs.path

statusprint "setup boot backup"
BOOTBACKUP="\
[Trigger]
Operation = Upgrade
Operation = Install
Operation = Remove
Type = Package
Target = linux*

[Action]
Depends = rsync
Description = Backing up /boot...
When = PreTransaction
Exec = /usr/bin/rsync -a --delete /boot /.bootbackup"
sudo cat "$BOOTBACKUP" > /etc/pacman.d/hooks/50-bootbackup.hook

statusprint "enable tlp battery service"
sudo systemctl enable --now tlp.service

#TODO zsh stuff?

#TODO ssh keys
#scp -r ben@192.168.29.207:.ssh .

#TODO wireguard
#ssh pi@192.168.29.191
#rm -rf pivpnbackup
#pivpn -a
#pivpn -bk
#exit
#scp -r pi@192.168.29.191:configs .
#nmcli connection import type wireguard file configs/b_arch_laptop.conf
#cat /etc/resolv.conf
#nmcli connection up b_arch_laptop

#TODO swapfile on btrfs
#curl https://raw.githubusercontent.com/osandov/osandov-linux/master/scripts/btrfs_map_physical.c -o ~/Downloads/btrfs_map_physical.c
#cd Downloads
#gcc -O2 -o btrfs_map_physical btrfs_map_physical.c
#sudo ./btrfs_map_physical
#getconf PAGESIZE
#do first physical / PAGESIZE
# put in resume and resume_offset into /etc/default/grub and rerun grub install and grub-mkconfig
# GRUB_CMDLINE_LINUX_DEFAULT="resume=UUID=ceea8bb7-fb93-4ee1-a9c9-0941ed7c7fa4 resume_offset=843879 loglevel=3 quiet"

# FSTAB
# /dev/nvme0n1p5
#UUID=ceea8bb7-fb93-4ee1-a9c9-0941ed7c7fa4	/swap     	btrfs     	defaults,noatime,compress=no,subvol=@swap	0 0
# /swap
#/swap/swapfile none swap defaults 0 0

# screen sharing wayland
sudo pacman -S xdg-desktop-portal-wlr
# enable chrome://flags/#enable-webrtc-pipewire-capturer

#bluetooth
sudo systemctl enable --now bluetooth
# change [General] at top without comemnts to be in /etc/bluetooth/main.conf
#[General]
#AutoEnable=true

#TODO sed enable tlp bluetooth on startup
#TODO 
#bluetoothctl
#select default mac address, find somehow
#power on
#devices
#scan on
#agent on
#pair tab_complete
#trust tab_complete
#connect tab_complete

#fonts, this lets dejavu become preferred mono again (consider using local configuration instead)
sudo rm /etc/fonts/conf.d/46-noto-sans-mono
sudo rm /etc/fonts/conf.d/66-noto-sans-mono

#install vs code extensions
cat ~/.config/Code/User/vs_code_extensions_list.txt | xargs -n 1 code --install-extension

#TODO 50-custom-sleep 1-custom logind
#[Sleep]
#AllowSuspend=no
#AllowHibernation=no
#AllowSuspendThenHibernate=yes
#AllowHybridSleep=yes
#SuspendMode=suspend platform shutdown
#SuspendState=disk
#HibernateMode=suspend platform shutdown
#HibernateState=disk
##HybridSleepMode=suspend platform shutdown
##HybridSleepState=disk
#HibernateDelaySec=15min

#TODO /etc/systemd/logind.conf.d/50-custom.conf
#[Login]
##NAutoVTs=6
##ReserveVT=6
##KillUserProcesses=no
##KillOnlyUsers=
##KillExcludeUsers=root
##InhibitDelayMaxSec=5
##UserStopDelaySec=10
##HandlePowerKey=poweroff
##HandleSuspendKey=suspend
##HandleHibernateKey=hibernate
#HandleLidSwitch=suspend-then-hibernate
#HandleLidSwitchExternalPower=suspend-then-hibernate
#HandleLidSwitchDocked=suspend-then-hibernate
##HandleRebootKey=reboot
##PowerKeyIgnoreInhibited=no
##SuspendKeyIgnoreInhibited=no
##HibernateKeyIgnoreInhibited=no
##LidSwitchIgnoreInhibited=yes
##RebootKeyIgnoreInhibited=no
##HoldoffTimeoutSec=30s
##IdleAction=ignore
##IdleActionSec=30min
##RuntimeDirectorySize=10%
##RuntimeDirectoryInodes=400k
##RemoveIPC=yes
##InhibitorsMax=8192
##SessionsMax=8192

#TODO backlight
#edit /etc/default/grub to have acpi_backlight=native in default command
#run grub-mkconfig
