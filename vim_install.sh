#!/bin/bash
#
# Script to restore my vim configuration

set -eux

######################
# vim-ghcid-quickfix #
######################

cd ~/.vim
mkdir -p "pack/haskell/start"
cd "pack/haskell/start"
[[ -e "vim-ghcid-quickfix" ]] || git clone "https://github.com/aiya000/vim-ghcid-quickfix"
cd -
