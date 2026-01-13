#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root or with sudo."
   exit 1
fi

apt install gh
apt install tmux
