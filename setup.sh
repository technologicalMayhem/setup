#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

###                        ###
# Install necessary packages #
###                        ###

# Remove unecessary packages
pacman -R --noconfirm gnome-console xterm

# Install yay
if ! pacman -Q yay; then
  pacman -Sy --needed git base-devel
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si
fi

# Install packages
yay -S --needed --noconfirm zsh bat 1password-bin flatpak gnome-software gnome-backgrounds gnome-font-viewer obsidian github-cli discord telegram vscode krita evolution gnome-characters network-manager-applet gnome-sound-recorder ttf-jetbrains-mono ttf-jetbrains-mono-nerd

flatpak install flathub -y \
com.mattjakeman.ExtensionManager \
io.github.jeffshee.Hidamari \
com.belmoussaoui.Decoder \
com.github.tchx84.Flatseal


###                  ###
#  Configure packages  #
###                  ###

echo "Disable eos-welcome showing up on boot"
sed -i '/Hidden=false/c\Hidden=true' /etc/xdg/autostart/welcome.desktop

echo "Install oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

echo "Install p10k"
zsh -c 'git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k'
sed -i '/ZSH_THEME=/c\ZSH_THEME="powerlevel10k/powerlevel10k"' ~/.zshrc

echo "Confgiure git"
git config --global user.email "wolfshund98@gmail.com"
git config --global user.name "Tobias Freese" 
git config --global init.defaultBranch "main"

###                     ###
#  Configure extensions   #
###                     ###
$SCRIPT_DIR/gnome-extensions/setup-extensions.sh
