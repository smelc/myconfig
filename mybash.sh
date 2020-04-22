#!/bin/bash
# Script sourced from .bashrc

alias gitg='gitg --all'
alias gitk='gitk --all'
alias git='git --no-pager'
alias ago='ag --ocaml'

export EDITOR="nvim"

export CRYPT1="/media/crypt1"
export PATH="$PATH:$HOME/.fzf/bin"

# From https://jekyllrb.com/docs/installation/ubuntu/
export GEM_HOME="$HOME/gems"
export PATH="$PATH:$HOME/gems/bin"

# Autojump
[[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source "$HOME/.autojump/etc/profile.d/autojump.sh"

## Nix
# To use with nix-env --switch-profile $NIX_USER_PROFILE_DIR/name
# export NIX_USER_PROFILE_DIR="/nix/var/nix/profiles/per-user/churlin/"
# What is my current profile? ls -l ~/.nix-profile

. /home/churlin/.nix-profile/etc/profile.d/nix.sh

# https://direnv.net/docs/hook.html (from https://github.com/target/lorri)
eval "$(direnv hook bash)"
