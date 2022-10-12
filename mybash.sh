#!/bin/bash
# Script sourced from .bashrc

alias ag='ag --no-group' # so that vscode can jump from terminal search
alias gg='git --no-pager grep -n' # so that vscode can jump from terminal search
alias hlfinish='notify-send "process" "finished"'
alias bip='if [[ "$?" == "0" ]]; then ICON="🎉"; else ICON="😿"; fi; notify-send "$ICON"'
alias gst="git status --untracked-files=no"
alias lg="lazygit"
alias apg="apg -m 10 -M SNCL"
alias nix="nix --extra-experimental-features nix-command --extra-experimental-features flakes"
alias tezt='dune exec tezt/tests/main.exe --'

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

export PATH="$PATH:$HOME/.local/bin"  # for stack-built things
# export PATH="$PATH:$HOME/.ghcup/bin", no I use isolated installs
# https://www.haskell.org/ghcup/guide/#isolated-installs

# For rust, prefer in .envrc
# . "$HOME/.cargo/env"

export COPYBARA_HOME="$HOME/tools/copybara"
# export COPYBARA_BIN="$COPYBARA_HOME/bazel-bin/java/com/google/copybara/copybara"
export COPYBARA_DEPLOY_JAR="$HOME/tools/copybara_deploy.jar"
export EDITOR="nvim"

# https://github.com/pyenv/pyenv#installation
export PYENV_ROOT="$HOME/.pyenv"
export PATH="~/.pyenv/bin:$PATH"
eval "$(pyenv init -)"

source $HOME/.fzf.bash

# Autojump: https://github.com/wting/autojump#automatic
. /usr/share/autojump/autojump.sh

# https://direnv.net/docs/hook.html (from https://github.com/target/lorri)
eval "$(direnv hook bash)"
