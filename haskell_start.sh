#!/bin/bash
#
# Script to bootstrap a desktop installation of Haskell
# Nothing is installed globally

set -eux

if [[ "$PATH" != *"$HOME/.local/bin"* ]];
then
  echo "Please add ~/.local/bin to your PATH and rerun this script"
  exit 1
fi

# Install stack: https://docs.haskellstack.org/en/stable/README/
if [ ! $(which stack) ]; then
  curl -sSL https://get.haskellstack.org/ | sh -s - -d "$HOME/.local/bin"
fi

declare -r HS_SRC_DIR="hs_proj"
declare -r HS_FILE="Main.hs"
declare -r RESOLVER="lts-16.20"

[ -e "$HS_SRC_DIR" ] || mkdir "$HS_SRC_DIR"

file_template=$(cat <<EOF
#!/usr/bin/env stack
-- stack --resolver $RESOLVER runghc
--
-- One can execute ./Main.hs thanks to the shebang line
-- at the top of the file and the stack line below
--
-- To launch [ghcid](https://github.com/ndmitchell/ghcid)
-- in a terminal, do:
--   stack exec ghcid -- --command="ghci Main.hs"
--
-- To disable coc in vim if not working (do it right after opening!):
--   :CocDisable
-- To disable ALE:
--   :ALEDisable
--
-- Both CoC and ALE should work, because they use the *.{yaml,cabal}
-- files in this directory to discover the configuration. That is why
-- we use 'runghc' in the stack configuration above; so that it relies
-- on those files too, as opposed to using 'script' that would ignore
-- those files, see https://docs.haskellstack.org/en/stable/GUIDE/#script-interpreter

{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Main where

main :: IO ()
main = do
  putStrLn "Hello World!"
EOF
)

if [ ! -e "$HS_SRC_DIR/$HS_FILE" ]; then
  echo "$file_template" >> "$HS_SRC_DIR/$HS_FILE"
  chmod +x "$HS_SRC_DIR/$HS_FILE"
fi

package_dot_yaml=$(cat <<EOF
name:                main
dependencies:
    - base
    - extra
    - filepath
    - process

executables:
  mainexec:
    main:            $HS_FILE
    ghc-options:
    - -threaded
    - -rtsopts
    - -with-rtsopts=-N
EOF
)

if [ ! -e "$HS_SRC_DIR/package.yaml" ]; then
  echo "$package_dot_yaml" >> "$HS_SRC_DIR/package.yaml"
fi

stack_dot_yaml=$(cat <<EOF
resolver: $RESOLVER
packages:
- .
extra-deps: []
EOF
)

if [ ! -e "$HS_SRC_DIR/stack.yaml" ]; then
  echo "$stack_dot_yaml" >> "$HS_SRC_DIR/stack.yaml"
fi

# Test stack compilation
cd $HS_SRC_DIR
stack build
./"$HS_FILE"
stack exec -- which hlint || stack install hlint
stack exec -- which hoogle || stack install hoogle
cd -

# Install visual stucio code
if [ ! $(which code) ]; then
  sudo snap install code --classic
fi
code --install-extension haskell.haskell
