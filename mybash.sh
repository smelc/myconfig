#!/bin/bash
# Script sourced from .bashrc

alias ag='ag --no-group' # so that vscode can jump from terminal search
alias gg='git --no-pager grep -n' # so that vscode can jump from terminal search
alias gst="git status --untracked-files=no"
alias lg="lazygit"
alias apg="apg -m 10 -M SNCL"
alias cdgr='cd $(git rev-parse --show-toplevel)'
alias gitdiffall='git difftool --dir-diff --tool=meld'
alias grep="grep --exclude-dir=dist-newstyle"

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

function cabalg() {
  [[ -n "$1" ]] || { echo "cabalg requires at least one parameter: the string to search"; return 1; }
  git grep $@ -- '*.cabal'
}

function hsformat() {
  [[ -n "$1" ]] || { echo "hsformat requires at least one parameter: a file to format"; return 1; }
  fourmolu -i $@
  stylish-haskell -i $@
}

export PATH="$PATH:$HOME/PERSONNEL/exdown"

export EDITOR="nvim"

[[ -s "/usr/share/autojump/autojump.bash" ]] && source /usr/share/autojump/autojump.bash

# https://direnv.net/docs/hook.html
eval "$(direnv hook bash)"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export PATH="/home/churlin/.local/bin:$PATH"

# Things that typically go in .envrc:
# [ -f "/home/churlin/.ghcup/env" ] && source "/home/churlin/.ghcup/env"
# source "$HOME/.cargo/env"

# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
test -r '/home/churlin/.opam/opam-init/init.sh' && . '/home/churlin/.opam/opam-init/init.sh' > /dev/null 2> /dev/null || true
# END opam configuration
#

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
