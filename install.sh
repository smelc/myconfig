#!/bin/bash
#
# Script to install one of my machine

set +eux

HERE=$(pwd)

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
  rm .bashrc
  ln -s "$HERE/.bashrc" .
  cd -

  cd "$HOME/.oh-my-bash/themes/font" || { echo "Cannot cd into $HOME/.oh-my-bash/themes/font"; exit 1 }
  ln -s "$HERE/.oh-my-bash/themes/font/font.theme.sh" . || { echo "Cannot ln -s .oh-my-bash/themes/font/font.theme.sh"; exit 1 }
  cd -
fi

# Passphrase caching: one week
# See https://superuser.com/questions/624343/keep-gnupg-credentials-cached-for-entire-user-session
echo "# Ask passphrases every week" >> .gnupg/gpg-agent.conf
echo "default-cache-ttl 604800" >> .gnupg/gpg-agent.conf
echo "max-cache-ttl 604800" >> .gnupg/gpg-agent.conf

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

# Install [nvim](https://github.com/neovim/neovim/wiki/Installing-Neovim#install-from-download)

cd "$HOME"
mkdir ".config/nvim"
if [[ -e ".gitconfig" ]]; then
  echo "$HOME/.gitconfig exists: not installing ${HERE}/.gitconfig"
else
  ln -s "${HERE}/.gitconfig" .
fi
cd ".config/nvim"
ln -s "${HERE}/init.lua" .
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
