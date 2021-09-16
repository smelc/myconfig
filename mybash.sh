#!/bin/bash
# Script sourced from .bashrc

alias git='git --no-pager'
alias ag='ag --no-group' # so that vscode can jump from terminal search
alias ago='ag --ocaml --ignore-dir src/proto_000_Ps9mPmXa --ignore-dir src/proto_001_PtCJ7pwo --ignore-dir src/proto_002_PsYLVpVv --ignore-dir src/proto_003_PsddFKi3 --ignore-dir src/proto_004_Pt24m4xi --ignore-dir src/proto_005_PsBABY5H --ignore-dir src/proto_005_PsBabyM1 --ignore-dir src/proto_006_PsCARTHA'
alias gg='git grep -n' # so that vscode can jump from terminal search
alias hlfinish='notify-send "process" "finished"'
alias bip='if [[ "$?" == "0" ]]; then BIP="yes"; ICON="🎉"; else BIP="no"; ICON="😿"; fi; notify-send "$ICON"; aplay --quiet $HOME/PERSONNEL/bip$BIP.wav'
alias glg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gsign="git rebase --exec 'git commit --amend --no-edit -n -S' -i"
alias mockup-client="./tezos-client --mode mockup --base-dir /tmp/mockup"
alias gst="git status --untracked-files=no"
alias nsr="nix-shell --run"
alias tezt="dune exec tezt/tests/main.exe --"
alias tezos-bench="$HOME/dev/tezos-bench/tezt/main.py"
alias lg="lazygit"

function dbw() {
  [[ -n "$1" ]] || { echo "dbw needs the name of the library to build, like lib_p2p"; }
  local -r built="@src/$1/check"
  echo "Building @src/$1/check"
  dune build "$built" --watch --terminal-persistence=clear-on-rebuild
}

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

function ocamlbootstrap() {
  opam switch create . --deps-only 4.10.2 || return 1

  eval $(opam env)

  # Setup bin/nvim
  mkdir -p "bin"
  echo '#!/usr/bin/env bash' >> "bin/nvim" || return 1
  echo '/usr/local/bin/nvim --cmd "set rtp+=$(git root)/_opam/share/merlin/vim" "$@"' >> "bin/nvim" || return 1

  # Setup .envrc
  echo 'eval $(opam env)' > .envrc || return 1
  echo 'PATH_add bin' >> .envrc
  echo 'unset PS1' >> .envrc

  opam install dune merlin utop || return 1

  opam pin add ocaml-lsp-server https://github.com/ocaml/ocaml-lsp.git || return 1
  opam install ocaml-lsp-server || return 1
}

##
# Search files modified in the last 16 commits that contain a given
# pattern. I use that to find the 'assert false' to be filled in.
# Using the last 16 commits is an alternative to
# `git ls-files "*.ml*"` which is too slow
##
function gitmine() {
  [[ -n "$1" ]] || { echo "pattern to search should be specified"; return 1; }
  local -r FILES=$(git diff-tree --no-commit-id --name-only -r HEAD~16..HEAD)
  for FILE in $FILES
  do
    if [[ -e "$FILE" ]]; then
      git blame -f -n "$FILE" | grep "Clément\|clément\|clement\|Hurlin\|hurlin" | grep "$1"
    fi  # else file has been deleted in a commit between HEAD~16 and HEAD~1
  done
}

function untezt() {
  [[ -n "$1" ]] || { echo "untezt expects an argument"; return 1;}
  local -r DEST="/tmp/tmp_untezt"
  rm -Rf "$DEST"
  sed 's/^\[.*\] \[.*\]//g' "$1" > "$DEST"; mv "$DEST" -f "$1"
}

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
