# How to set a random lightdm-slick-greeter background

**Please give this repository a star if this was helpful to you.**

Currently I don't use a random background in my slick-greeter.conf, but I've wrote a script that handles this in case you want to use it.

I found that the most convenient way to do this for me is to put everything in `/usr/share/backgrounds/lightdm`.

### 1. Create a script to select a random image
I've put some wallpapers in [`Pictures/lightdm`](Pictures/lightdm/), they come from [this Reddit thread](https://reddit.com/r/archlinux/comments/4gc2lw/some_arch_wallpapers_i_made/). Needless to say you can add pictures of your own choice.

The following script selects all PNG items from the directory and picks a random one, you'll have to change this script a bit to use other image extentions.

> /usr/share/backgrounds/lightdm/random_background_picker.sh
```sh
#!/bin/bash

background_dir="/usr/share/backgrounds/lightdm"
background_files=("$background_dir"/*.png)

# Check if there are any PNG files in the directory
if [ ${#background_files[@]} -eq 0 ]; then
    echo "No PNG files found in $background_dir"
    exit 1
fi

random_index=$((RANDOM % ${#background_files[@]}))
selected_background="${background_files[$random_index]}"

# Replace the "selected_background" file with the selected image
cp "$selected_background" "/usr/share/backgrounds/lightdm/selected_background"
```

Save this script and make it executable.
```sh
chmod +x random_background_picker.sh
```

### 2. Configure lightdm-slick-greeter
Or any other greeter that allows you to set a background.

> /etc/lightdm/slick-greeter.conf
```
# add the following line:
background = /usr/share/backgrounds/lightdm/selected_background
```

### 3. Create a systemd service
To run this on startup (and before the DM is loaded), create a systemd service that utilizes this script.

> /etc/systemd/system/random_lightdm_background.service
```
[Unit]
Description=Random Background Selector

[Service]
ExecStart=/usr/share/backgrounds/lightdm/random_background_picker.sh

[Install]
WantedBy=multi-user.target
```

Save the file and enable the service.
```sh
sudo systemctl enable random_lightdm_background.service
```


Finally reboot your system to see if the changes have taken effect.