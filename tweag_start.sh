#!/bin/bash

# Exit if command fail
set -e
# Exit on read of undefined variable
set -u

function open() {
  sudo cryptsetup luksOpen "$1" "$2"
  sudo mount "/dev/mapper/$2" "/media/$2"
}

# open "/dev/nvme0n1p4" "crypt1"
# open "/dev/nvme0n1p5" "crypt2"
