#!/bin/bash
if [[ $EUID -eq 0 ]]; then
echo "This script cannot be run as root."
exit 1
fi
cd ~/.local/share/chezmoi
chezmoi re-add
read -p "Commit message : " MESSAGE
git commit -a -S -m "$MESSAGE"
git push --set-upstream origin main
