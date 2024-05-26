#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
set -e

###                        ###
# Install necessary packages #
###                        ###

# Remove unecessary packages
declare -a PACDELETE=($(pacman -Qq gnome-console xterm 2>/dev/null))
if (( ${#PACDELETE[@]} != 0 )); then
  sudo pacman -R --noconfirm $PACDELETE
fi

# Install yay
if ! pacman -Q paru; then
  sudo pacman -S --needed base-devel
  git clone https://aur.archlinux.org/paru.git
  cd paru
  makepkg -si
fi

cd ~

# Install packages
paru -S --needed --noconfirm zsh bat 1password flatpak gnome-software gnome-backgrounds gnome-font-viewer obsidian github-cli discord telegram-desktop vscode krita evolution gnome-characters network-manager-applet gnome-sound-recorder ttf-jetbrains-mono ttf-jetbrains-mono-nerd

flatpak install flathub -y \
com.mattjakeman.ExtensionManager \
com.belmoussaoui.Decoder \
com.github.tchx84.Flatseal \
app.drey.Dialect \
io.missioncenter.MissionCenter \
com.usebottles.bottles \
org.gnome.baobab

###                  ###
#  Configure packages  #
###                  ###

if pacman -Q zsh; then
  echo "Install oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

  echo "Install p10k"
  zsh -c 'git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k'
  sed -i '/ZSH_THEME=/c\ZSH_THEME="powerlevel10k/powerlevel10k"' ~/.zshrc
else
  echo "Zsh not installed."
fi

echo "Configure git"
git config --global user.email "wolfshund98@gmail.com"
git config --global user.name "Tobias Freese" 
git config --global init.defaultBranch "main"

###                     ###
#  Configure extensions   #
###                     ###
$SCRIPT_DIR/gnome-extensions/setup-extensions.sh
