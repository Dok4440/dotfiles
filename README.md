# Dotfiles
Config files for my personal Arch Linux i3 WM build. Here's a [screenshot](https://i.imgur.com/McII6GX.png).

### Dependencies (WM setup)
* [i3](https://archlinux.org/packages/community/x86_64/i3-wm/) (or the [package group / gaps](https://wiki.archlinux.org/title/i3#Installation))
* [Rofi](https://archlinux.org/packages/community/x86_64/rofi/)
* [Polybar](https://github.com/polybar/polybar)
* [pacman-contrib](https://archlinux.org/packages/community/x86_64/pacman-contrib/)
* [Font Awesome](https://archlinux.org/packages/community/any/ttf-font-awesome/)
* [Clear Sans](https://www.fontsquirrel.com/fonts/clear-sans)
* [Kitty](https://archlinux.org/packages/community/x86_64/kitty/) (terminal-emulator)
* [Brightnessctl](https://archlinux.org/packages/community/x86_64/brightnessctl/)
* [Greenclip](https://aur.archlinux.org/packages/rofi-greenclip)<sup>aur</sup> (make sure to [enable](https://wiki.archlinux.org/title/Systemd#Using_units) `greenclip.service`)

*\* Optional: PulseAudio (volume bar), Flameshot (i3 screenshots), Nitrogen (wallpapers).*


### Configuration
#### Quick install to device
```sh
pacman -S chezmoi
```  
```sh
chezmoi init --apply https://github.com/Dok4440/dotfiles.git
```

#### Edit chezmoi: [read the docs.](https://www.chezmoi.io/user-guide/command-overview/)

## Keybinds
|Keybind|Action|Keybind|Action|
|:---|:---|:---|:---|
|$mod + Enter|kitty (terminal-emulator)|$mod + a|focus parent|
|$mod + Shift + q|kill window|~~$mod + d~~|~~focus child~~|
|$mod + d|rofi dmenu|$mod + $number|workspace number $number|
|$mod + prt sc|[flameshot](https://archlinux.org/packages/community/x86_64/flameshot/) gui|$mod + Shift + $number|move container to workspace $number
|$mod + left arrow|focus left|$mod + v|open [greenclip<sup>aur</sup>](https://aur.archlinux.org/packages/rofi-greenclip)|
|$mod + down arrow|focus down|$mod + Shift + minus|make [scratchpad](https://i3wm.org/docs/userguide.html#_scratchpad) of current window|
|$mod + up arrow|focus up|$mod + minus|scratchpad toggle|
|$mod + right arrow|focus right|$mod + Shift + c|reload config file|
|$mod + f|fullscreen toggle|$mod + Shift + e|exit i3|
|$mod + w|layout tabbed|$mod + Shift + r|restart i3|
|$mod + e|layout toggle split|~~$mod + h~~|~~split horizontally~~|
|$mod + Shift + Space|floating toggle|~~$mod + v~~|~~split vertically~~|
|$mod + Space|focus mode_toggle|$mod + Shift + arrows|move window around|

*\* My personal $mod is Mod4 (Super).*
