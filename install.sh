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
apt_install_if_missing direnv
apt_install_if_missing entr
apt_install_if_missing fd-find # for nvim's telescope
apt_install_if_missing fzf
apt_install_if_missing gnome-shell-extension-prefs
apt_install_if_missing gnome-tweaks
apt_install_if_missing nodejs # required by neovim's coc.vim
apt_install_if_missing meld
apt_install_if_missing ripgrep # for nvim's telescope

[[ -e "$HOME/tools" ]] || mkdir "$HOME/tools"

# Install [pass-git-helper](https://github.com/languitar/pass-git-helper#installation)
apt_install_if_missing pass-git-helper

pushd "$HOME/.config/pass-git-helper"
ln -s "$HERE/git-pass-mapping.ini" .
popd

# Passphrase caching: one week
# See https://superuser.com/questions/624343/keep-gnupg-credentials-cached-for-entire-user-session
echo "# Ask passphrases every week" >> .gnupg/gpg-agent.conf
echo "default-cache-ttl 604800" >> .gnupg/gpg-agent.conf
echo "max-cache-ttl 604800" >> .gnupg/gpg-agent.conf

########
# nvim #
########

# Install [nvim](https://github.com/neovim/neovim/wiki/Installing-Neovim#install-from-download)

# Install the [plug manager](https://github.com/junegunn/vim-plug#neovim)

cd "$HOME"
mkdir ".config/nvim"
if [[ -e ".gitconfig" ]]; then
  echo "$HOME/.gitconfig exists: not installing ${HERE}/.gitconfig"
else
  ln -s "${HERE}/.gitconfig" .
fi
cd ".config/nvim"
ln -s "${HERE}/init.vim" .
ln -s "${HERE}/coc_config_nvim.vim" .
# Content of next file was copied from https://github.com/digital-asset/ghcide#using-it
ln -s "${HERE}/coc-settings.json" .
cd "$HERE"

# Install https://github.com/sharkdp/bat
apt_install_if_missing bat

#########
# ocaml #
#########

if [[ ! $(which opam) ]]; then
  add-apt-repository ppa:avsm/ppa
  apt update
  apt install opam
  opam init
  opam config setup -a
  # opam install merlin utop ocp-indent ounit2
fi

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

##########
# vscode #
##########

pushd "/home/churlin/.config/Code/User"
ln -s $HERE/keybindings.json .
ln -s $HERE/settings.json .
popd
