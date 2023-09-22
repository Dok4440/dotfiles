#!/bin/bash

# Get the current user's home directory
if [ "$EUID" -eq 0 ]; then
    user_home=$(eval echo ~$(logname))
else
    echo "Run this script with sudo."
    exit
fi

# make necessary directories
mkdir -p /usr/share/backgrounds/i3lock

# Create symbolic links with the replaced path
ln -s "$user_home/Scripts/cp-p.sh" /usr/local/bin/cp-p
ln -s "$user_home/Scripts/mv-p.sh" /usr/local/bin/mv-p
ln -s "$user_home/Scripts/GPUdisable.sh" /usr/local/bin/GPUdisable
ln -s "$user_home/Scripts/GPUenable.sh" /usr/local/bin/GPUenable
ln -s "$user_home/Scripts/chezmoi.sh" /usr/local/bin/dotfiles
ln -s "$user_home/Pictures/i3lock/cat-peek-adjusted.png" /usr/share/backgrounds/i3lock/cat-peek-adjusted.png
