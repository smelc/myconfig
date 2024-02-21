#!/bin/bash
#
# Script to install one of my machine

set +eux

HERE=$(pwd)

if [[ "$HERE" != "/home/churlin/PERSONNEL/myconfig" ]]
then
  echo "Expected myconfig repo to be at /home/churlin/PERSONNEL/myconfig"
  echo "Instead, found: $HERE"
  echo "Please put the myconfig repo in the expected position"
  exit 1
fi

function apt_install_if_missing() {
  local -r last_line=$(dpkg -l "$1" | tail -n 1)
  if [[ "$last_line" == "ii"* ]]; then return 0; fi
  sudo apt install "$1"
}

[[ ! $(which ag) ]] && sudo apt install silversearcher-ag

apt_install_if_missing autojump
apt_install_if_missing chrome-gnome-shell
apt_install_if_missing curl
apt_install_if_missing direnv
apt_install_if_missing entr
apt_install_if_missing fd-find # for nvim's telescope
apt_install_if_missing gnome-shell-extension-prefs
apt_install_if_missing gnome-tweaks
apt_install_if_missing jq
apt_install_if_missing meld
apt_install_if_missing parcellite
apt_install_if_missing ripgrep # for nvim's telescope

[[ -e "$HOME/tools" ]] || mkdir "$HOME/tools"

# Install [pass-git-helper](https://github.com/languitar/pass-git-helper#installation)
apt_install_if_missing pass-git-helper

pushd "$HOME/.config"
[[ -e "pass-git-helper" ]] || mkdir "pass-git-helper"
cd "pass-git-helper"
ln -s "$HERE/git-pass-mapping.ini" .
popd

##############
# oh-my-bash #
##############

if [[ ! -e ".oh-my-bash" ]]
then
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
  cd $HOME
  echo "source /home/churlin/PERSONNEL/myconfig/mybash.sh" >> .bashrc
  cd -

  cd "$HOME/.oh-my-bash/themes/font" || { echo "Cannot cd into $HOME/.oh-my-bash/themes/font"; exit 1; }
  rm font.theme.sh
  ln -s "$HERE/.oh-my-bash/themes/font/font.theme.sh" . || { echo "Cannot ln -s .oh-my-bash/themes/font/font.theme.sh"; exit 1; }
  cd -
fi

#########
# gnupg #
#########

# Passphrase caching: one week
# See https://superuser.com/questions/624343/keep-gnupg-credentials-cached-for-entire-user-session

if [[ ! -e "$HOME/.gnupg/gpg-agent.conf" ]]
then
  cd $HOME
  touch .gnupg/gpg-agent.conf
  echo "# Ask passphrases every week" >> .gnupg/gpg-agent.conf
  echo "default-cache-ttl 604800" >> .gnupg/gpg-agent.conf
  echo "max-cache-ttl 604800" >> .gnupg/gpg-agent.conf
  cat .gnupg/gpg-agent.conf
  cd -
fi

#######
# fzf #
#######

if [[ ! -e "$HOME/.fzf" ]]
then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi

########
# nvim #
########

which nvim || { echo "Please install neovim: https://github.com/neovim/neovim/releases/ and restart this script"; exit 1; }

cd "$HOME"
mkdir -p ".config/nvim/ftplugin"
if [[ -e ".gitconfig" ]]; then
  echo "$HOME/.gitconfig exists: not installing ${HERE}/.gitconfig"
else
  ln -s "${HERE}/.gitconfig" .
fi
cd ".config/nvim"
ln -s "${HERE}/init.lua" .
cd "$HERE"
cd ".config/nvim/ftplugin"
ln -s "${HERE}/haskell.lua" .
cd "$HERE"

# Install https://github.com/sharkdp/bat
apt_install_if_missing bat

#########
# ocaml #
#########

# if [[ ! $(which opam) ]]; then
#   add-apt-repository ppa:avsm/ppa
#   apt update
#   apt install opam
#   opam init
#   opam config setup -a
#   # opam install merlin utop ocp-indent ounit2
# fi

###########
# Haskell #
###########

# Instal ghcup
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

#######
# Nix #
#######

# Install via nixos.org

# Make sure the following is in /etc/nix/nix.conf:
#
# substituters = https://cache.nixos.org https://cache.iog.io
# trusted-public-keys = hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=
# experimental-features = nix-command flakes auto-allocate-uids configurable-impure-env
# allow-import-from-derivation = true
# build-users-group = nixbld
# trusted-users = root smelc

# Be sure to run: sudo systemctl restart nix-daemon.service
# afterwards to have the changes taken into account

#########
# kitty #
#########

apt_install_if_missing fonts-firacode

if [[ ! $(which kitty) ]]; then
  # Install [kitty](https://sw.kovidgoyal.net/kitty/binary/)
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
  cd /usr/local/bin
  sudo ln -s ~churlin/.local/kitty.app/bin/kitty . || { echo "ln -s .. kitty .. failed"; exit 1; }
  cd -
  cd $HOME/.config/kitty/
  ln -s "$HERE/kitty.conf" . || { echo "ln -s .. kitty.conf failed"; exit 1; }
  cd -
fi

# Make it the default terminal in gnome:

sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator $(which kitty) 50
sudo update-alternatives --config x-terminal-emulator

# Add icon
if [[ ! -e "$HOME/.local/share/applications/kitty.desktop" ]]
then
  cat << EOT >> $HOME/.local/share/applications/kitty.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=kitty
GenericName=Terminal emulator
Comment=Fast, feature-rich, GPU based terminal
TryExec=kitty
Exec=kitty
Icon=/home/churlin/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png
Categories=System;TerminalEmulator;"
EOT
fi

###########
# lazygit #
###########

which lazygit || { echo "Please install lazygit: https://github.com/jesseduffield/lazygit/releases and restart this script"; exit 1; }

pushd "$HOME"
mkdir -p .config/lazygit
ln -s "$HERE/.config/lazygit/config.yml" .
popd

######################
# Enable hibernation #
######################

# https://www.lorenzobettini.it/2020/07/enabling-hibernation-on-ubuntu-20-04/
# https://www.linuxtechi.com/extend-swap-space-using-swap-file-in-linux/
# https://ubuntuhandbook.org/index.php/2021/08/enable-hibernate-ubuntu-21-10/ <- best

##########
# vscode #
##########

[[ -e "$HOME/.config/Code/User" ]] || mkdir -p "$HOME/.config/Code/User"
pushd "$HOME/.config/Code/User"
[[ -e "keybindings.json" ]] || ln -s $HERE/.config/Code/User/keybindings.json .
[[ -e "settings.json" ]] || ln -s $HERE/.config/Code/User/settings.json .
popd

#########
# gnome #
#########

# Install all these:
# https://extensions.gnome.org/extension/1485/workspace-matrix/
# Then configure like this: https://askubuntu.com/questions/1403554/switch-workspace-on-dual-monitor-22-04
# https://extensions.gnome.org/extension/755/hibernate-status-button/
# https://extensions.gnome.org/extension/906/sound-output-device-chooser/

if [[ ! -e "/etc/polkit-1/localauthority/10-vendor.d/com.ubuntu.desktop.pkla" ]]
then
  sudo cat > /etc/polkit-1/localauthority/10-vendor.d/com.ubuntu.desktop.pkla << EOL
[Enable hibernate in upower]
Identity=unix-user:*
Action=org.freedesktop.upower.hibernate
ResultActive=yes

[Enable hibernate in logind]
Identity=unix-user:*
Action=org.freedesktop.login1.hibernate;org.freedesktop.login1.handle-hibernate-key;org.freedesktop.login1;org.freedesktop.login1.hibernate-multiple-sessions;org.freedesktop.login1.hibernate-ignore-inhibit
ResultActive=yes
EOL
fi

# See Ubuntu 22.04 section (a bit below) in:
# https://askubuntu.com/questions/1059479/dual-monitor-workspaces-in-ubuntu-18-04
