#!/bin/bash
# Script sourced from .bashrc

alias ag='ag --no-group' # so that vscode can jump from terminal search
alias gg='git --no-pager grep -n' # so that vscode can jump from terminal search
alias gst="git status --untracked-files=no"
alias lg="lazygit"
alias apg="apg -m 10 -M SNCL"
alias cdgr='cd $(git rev-parse --show-toplevel)'

function run() {
  echo "$@"
  "$@"
}

function gitsync() {
  [[ -n "$1" ]] || { echo "Name of remote should be specified"; return 1; }
  run git fetch "$1" || return $?
  # local -r branch=$(git rev-parse --abbrev-ref HEAD)
  # run git reset --hard "origin/$branch" || return $?
  run git reset --hard '@{u}' || return $?
}

function gitbrco() {
  [[ -n "$1" ]] || { echo "Name of branch should be specified"; return 1; }
  git branch -f "$1"
  git checkout "$1"
}

export PATH="$PATH:$HOME/PERSONNEL/exdown"

export EDITOR="nvim"

[[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh

# https://direnv.net/docs/hook.html
# eval "$(direnv hook bash)"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# complete -C /usr/local/bin/terraform terraform

# source "$HOME/.cargo/env"

# [ -f "/home/churlin/.ghcup/env" ] && source "/home/churlin/.ghcup/env" # ghcup-env

export PATH="/home/churlin/.local/bin:$PATH"

# source "$HOME/PERSONNEL/myconfig/prompt.sh"
