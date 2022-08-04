#!/bin/bash
# Script sourced from .bashrc

alias ag='ag --no-group' # so that vscode can jump from terminal search
alias gg='git grep -n' # so that vscode can jump from terminal search
alias hlfinish='notify-send "process" "finished"'
alias bip='if [[ "$?" == "0" ]]; then BIP="yes"; ICON="🎉"; else BIP="no"; ICON="😿"; fi; notify-send "$ICON"; aplay --quiet $HOME/PERSONNEL/bip$BIP.wav'
alias gst="git status --untracked-files=no"
alias lg="lazygit"
alias apg="apg -m 10 -M SNCL"
alias nix="nix --extra-experimental-features nix-command --extra-experimental-features flakes"

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

export PATH="$PATH:$HOME/.local/bin"  # for stack

export COPYBARA_HOME="$HOME/tools/copybara"
# export COPYBARA_BIN="$COPYBARA_HOME/bazel-bin/java/com/google/copybara/copybara"
export COPYBARA_DEPLOY_JAR="$COPYBARA_HOME/bazel-bin/java/com/google/copybara/copybara_deploy.jar"
export EDITOR="nvim"

export PATH="~/.pyenv/bin:$PATH"
# eval "$(pyenv init -)"

source $HOME/.fzf.bash

# Autojump: https://github.com/wting/autojump#automatic
. /usr/share/autojump/autojump.sh

# https://direnv.net/docs/hook.html (from https://github.com/target/lorri)
eval "$(direnv hook bash)"
