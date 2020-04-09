#!/bin/bash

set -eu

declare -r FILENAME=$(date "+%y%m%d_help")
declare -r FILEPATH="/tmp/${FILENAME}.tgz"

(cd "$HOME/.password-store" && tar -czf "$FILEPATH" "smelc")

scp -P 58241 "$FILEPATH" clem@schplaf.org:~/helps/.
echo "saving@schplaf: ✓"

scp "$FILEPATH" smelc@makeitso.no-ip.org:~/helps/.
echo "saving@makeitso: ✓"
