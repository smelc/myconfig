#!/bin/bash
#
# Script to install one of my machine

set +eux

[[ ! $(which ag) ]] && sudo apt install silversearcher-ag

sudo apt install jq

# fzf
if [[ ! $(which zfz) ]]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fsf/install
fi

# for smelc.github.io
gem install jekyll bundler github-pages

#########################################
# nodejs (required by neovim's coc.vim) #
#########################################

sudo apt install nodejs
# yarn must be installed too, look for instructions online

########
# nvim #
########

if [[ ! $(which nvim) ]]; then
  rm -Rf nvim.appimage
  wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
  chmod u+x nvim.appimage
  sudo mv nvim.appimage /usr/local/bin/nvim
fi

HERE=$(pwd)

cd "$HOME"
mkdir ".config/nvim"
cd ".config/nvim"
ln -s "${HERE}/init.vim" .
ln -s "${HERE}/coc_config_nvim.vim" .
# Content of next file was copied from https://github.com/digital-asset/ghcide#using-it
ln -s "${HERE}/coc-settings.json" .
cd "$HERE"

# Install vim-plug
if [[ ! -e "$HOME/.local/share/nvim/site/autoload/plug.vim" ]]; then
  curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
