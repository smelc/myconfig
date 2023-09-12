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
export PATH="/usr/local/lib/nodejs/node-v18.15.0-linux-x64/bin:$PATH"

export EDITOR="nvim"
# https://dev.to/reobin/reload-init-vim-without-restarting-neovim-1h82
export MYVIMRC="$HOME/PERSONNEL/myconfig/init.lua"

# Turn oh-my-bash auto update prompt OFF
# https://github.com/ohmybash/oh-my-bash#getting-updates
export DISABLE_AUTO_UPDATE="true"

# source $HOME/.fzf.bash

# Autojump: https://github.com/wting/autojump#automatic
. /usr/share/autojump/autojump.sh

# https://direnv.net/docs/hook.html
eval "$(direnv hook bash)"

source $HOME/bash_completion.d/gradle-completion.bash

# https://sdkman.io/
# export SDKMAN_DIR="$HOME/.sdkman"
# [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

complete -C /usr/local/bin/terraform terraform

# export PATH="$HOME/.jenv/bin:$PATH"
# eval "$(jenv init -)"

# source "$HOME/.cargo/env"

# [ -f "/home/churlin/.ghcup/env" ] && source "/home/churlin/.ghcup/env" # ghcup-env

export PATH="/home/churlin/.local/bin:$PATH"

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
