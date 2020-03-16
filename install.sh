#!/bin/bash
#
# Script to install one of my machine

set +eux

########
# nvim #
########

set -e
which nvim
RC="$?"
set +e
if [[ "$RC" != "0" ]]; then
  rm -Rf nvim.appimage
  wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
  chmod u+x nvim.appimage
  sudo mv nvim.appimage /usr/local/bin/nvim
fi

HERE=$(pwd)

cd $HOME
mkdir ".config/nvim"
cd ".config/nvim"
ln -s "${HERE}/init.vim" .
cd $HERE

# Install vim-plug
if [[ ! -e "~/.local/share/nvim/site/autoload/plug.vim" ]]; then
  curl -fLo "~/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
