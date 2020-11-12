#!/bin/bash
#
# Script to install one of my machine

set +eux

function apt_install_if_missing() {
  local -r last_line=$(dpkg -l "$1" | tail -n 1)
  if [[ "$last_line" == "ii"* ]]; then return 0; fi
  sudo apt install "$1"
}

apt_install_if_missing exuberant-ctags  # For https://github.com/majutsushi/tagbar

[[ ! $(which ag) ]] && sudo apt install silversearcher-ag

apt_install_if_missing jq

# fzf
if [[ ! $(which zfz) ]]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fsf/install
fi

[[ -e "$HOME/tools" ]] || mkdir "$HOME/tools"

# pass-git-helper
pushd "$HOME/tools"
if [[ ! -e "pass-git-helper" ]]; then
  git clone https://github.com/languitar/pass-git-helper
  pushd "pass-git-helper"
  apt_install_if_missing python3-setuptools
  python3 setup.py install --user
  [[ -e "git-pass-mapping.init" ]] || exit 1
  pushd "$HOME/.config/pass-git-helper"
  ln -s "$HOME/tools/git-pass-helper/git-pass-mapping.ini" .
  popd
  popd
fi
popd

# for smelc.github.io
gem install jekyll bundler github-pages

#########################################
# nodejs (required by neovim's coc.vim) #
#########################################

apt_install_if_missing nodejs
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

# Install vim-plug
if [[ ! -e "$HOME/.local/share/nvim/site/autoload/plug.vim" ]]; then
  curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

#############
# spacemacs #
#############

# https://github.com/ocaml/merlin/wiki/spacemacs-from-scratch
if [[ ! -e "$HOME/.fonts/adobe-fonts/source-code-pro" ]]; then
  git clone --depth 1 --branch release https://github.com/adobe-fonts/source-code-pro.git "$HOME/.fonts/adobe-fonts/source-code-pro"
  fc-cache -f -v
fi

if [[ ! $(which emacs) ]]; then
  sudo apt install emacs
fi

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

# for ocaml + spacemacs: https://github.com/ocaml/merlin/wiki/spacemacs-from-scratch#enable-ocaml
# also: https://develop.spacemacs.org/layers/+lang/ocaml/README.html#using-merlin-for-error-reporting
