#!/bin/bash
if [[ $EUID -eq 0 ]]; then
echo "This script cannot be run as root."
exit 1
fi

# https://wiki.archlinux.org/title/Pacman/Tips_and_tricks#List_of_installed_packages
pacman -Qqe > ~/.pkg_list/pkglist
pacman -Qqm > ~/.pkg_list/pkglist_foreign


# commit and push changes to dotfiles
cd ~/.local/share/chezmoi
chezmoi re-add
read -p "Commit message: " MESSAGE
git commit -a -S -m "$MESSAGE"
git push --set-upstream origin main
