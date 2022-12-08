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

## Installation
#### Quick install to device
```sh
pacman -S chezmoi
```  
```sh
chezmoi init --apply https://github.com/Dok4440/dotfiles.git
```

#### Edit chezmoi: [read the docs.](https://www.chezmoi.io/user-guide/command-overview/)

## Configuration
#### *1. Setting wallpaper*
To set wallpapers on i3 startup, install [nitrogen](https://wiki.archlinux.org/title/nitrogen) and uncomment the following line in `~/.config/i3/config`:
```config
#exec --no-startup-id nitrogen --set-zoom-fill /path/to/image.png.svg.jpg
```
Obviously you will need to change the path to your image. For the sake of testing, use `exec_always` instead of `exec` to view changes on [i3 restart](#keybinds).

#### *2. Sup-mail scratchpad*
Uncomment the following line in `~/.config/i3/config` to show the sup-mail scratchpad window, if any exist.
```config
#bindsym mod4+s [title="^Sup ::"] scratchpad show
```

#### *3. Other keybinds to focus/move windows*
The default keys to change focus or move windows in i3 are `j`, `k`, `l` and `;`. I disabled these in my config since arrow keys are more convenient for me. To re-bind these take a look at the default i3 config file at `/etc/i3/config` and copy the required lines to `~/.config/i3/config`.

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

<hr/>

*This guide was written by Dok4440, want to show appreciation? Give this repository a star!*
