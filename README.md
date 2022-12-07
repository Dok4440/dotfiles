# dotfiles
Config files for my personal Arch Linux i3 WM build. Here's a [screenshot](https://i.imgur.com/McII6GX.png).

### dependencies (WM setup)
* [i3](https://archlinux.org/packages/community/x86_64/i3-wm/) (or the [package group / gaps](https://wiki.archlinux.org/title/i3#Installation))
* [Rofi](https://archlinux.org/packages/community/x86_64/rofi/)
* [Polybar](https://github.com/polybar/polybar)
* [pacman-contrib](https://archlinux.org/packages/community/x86_64/pacman-contrib/)
* [Font Awesome](https://archlinux.org/packages/community/any/ttf-font-awesome/)
* [Clear Sans](https://www.fontsquirrel.com/fonts/clear-sans)
* [Kitty](https://archlinux.org/packages/community/x86_64/kitty/) (terminal-emulator)
* [Brightnessctl](https://archlinux.org/packages/community/x86_64/brightnessctl/)
* [Greenclip](https://aur.archlinux.org/packages/rofi-greenclip) (make sure to [enable](https://wiki.archlinux.org/title/Systemd#Using_units) `greenclip.service`)

*\* Optional: PulseAudio (volume bar), Flameshot (i3 screenshots), Nitrogen (wallpapers).*


### configuration
#### quick install to device
```sh
pacman -S chezmoi
```  
```sh
chezmoi init --apply https://github.com/Dok4440/dotfiles.git
```

#### edit chezmoi
[Read the docs.](https://www.chezmoi.io/user-guide/command-overview/)


