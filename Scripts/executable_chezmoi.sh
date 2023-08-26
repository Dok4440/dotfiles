#!/bin/bash
if [[ $EUID -eq 0 ]]; then
echo "This script cannot be run as root."
exit 1
fi

# https://wiki.archlinux.org/title/Pacman/Tips_and_tricks#List_of_installed_packages
pacman -Qqetn > ~/.pkg_list/cleanpkglist_noforeign
pacman -Qqen > ~/.pkg_list/fullpkglist_noforeign
pacman -Qqem > ~/.pkg_list/foreignpkglist


# commit and push changes to dotfiles
cd ~/.local/share/chezmoi
chezmoi re-add
read -p "Commit message: " MESSAGE
git commit -a -S -m "$MESSAGE"
git push --set-upstream origin main
