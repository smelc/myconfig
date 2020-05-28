#!/bin/bash
# Script sourced from .bashrc

alias gitg='gitg --all'
alias gitk='gitk --all'
alias git='git --no-pager'
alias ago='ag --ocaml --ignore-dir src/proto_000_Ps9mPmXa --ignore-dir src/proto_001_PtCJ7pwo --ignore-dir src/proto_002_PsYLVpVv --ignore-dir src/proto_003_PsddFKi3 --ignore-dir src/proto_004_Pt24m4xi --ignore-dir src/proto_005_PsBABY5H --ignore-dir src/proto_005_PsBabyM1'

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
