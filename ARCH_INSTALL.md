# My simple vanilla Arch installation
### Keyboard
By default, Arch Linux assumes that you have a US keyboard layout. This should be fine for most people but just in case if you happen to have a different one, you can change to that.
```
loadkeys uk
```
\* All the available keymaps are kept inside the `/usr/share/kbd/keymaps` directory.

### Network connection (Wi-Fi)
To install Arch Linux, you __need__ a working internet connection. To connect to Wi-Fi, follow the following commands.
```
ictwl
device list
station <device> scan
station <device> get-networks
station <device> connect <your_network>
exit
```

### System clock
Update the system clock.
```
timedatectl set-ntp true
```

### Disk partitioning
Pick the disk you want to install Arch Linux on.
```
fdisk -l
cfdisk <disk>
```
Select "GPT" for your UEFI based system. I typically use the following configuration for my partitions:  

| Type | Size |
|:--:|:--:|
| EFI system | 500M |
| Linux swap | 4G - 8G|
| Linux filesystem | remaining space |


Take note of the device names, for example: EFI = `/dev/sda1`, SWAP = `/dev/sda2`, FILESYSTEM = `/dev/sda3`
```
mkfs.fat -F32 /dev/sda1
mkfs.ext /dev/sda3
mkswap /dev/sda2
```

### Mount the root partition
```
mount /dev/sda3 /mnt
```

### Configuring mirrors
Before overwriting the default mirrorlist, make a backup of it.
```
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak`
```

Now execute the reflector command to generate your new mirror list. You're now ready to install the base Arch Linux system.
```
reflector --country <your_country> --age 12 --protocol https --save /etc/pacman.d/mirrorlist`
pacman -Sy
```

### Installing base
Install the bare minimum to run Arch Linux, I've included the `nano` package here to make the next steps easier but this isn't necessary.
```
pacstrap /mnt base base-devel linux linux-firmware sudo networkmanager nano
```

### Configuring before reboot
`Arch-chroot` into your newly installed system to configure it before rebooting your machine. This script is part of the `arch-install-scripts` package.
```
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
```

edit `etc/locale.gen` with nano to uncomment the language(s) you want. Then run the following command to generate them.
```
locale-gen
```

edit `/etc/locale.conf` to set the default langauge. Here's an example to set the default language to "en_US".
```bash
LANG=en_US.UTF-8
```

Enable the networkmanager systemd unit.
```
systemctl enable NetworkManager
```

Set the password for root.
```
passwd
```

Configure a new user to run `i3-wm` on. It is never recommended to use i3 as root. We're giving this user "sudo" permissions, however this is not required.
```
useradd --create-home <username>
usermod -aG wheel
```

\* To give sudo permissions: uncomment `# %wheel ALL=(ALL) ALL` in `/etc/sudoers`.


*install ucodes (ADM: 'pacman -S amd-ucode' / Intel: 'pacman -S intel-ucode')*
*install packages xorg-server + nvidia, nvidia-utils OR xf86-video-amdgpu*

### Window manager (i3)
Install the required packages for my specific i3 configuration as shared in this repository.
```
sudo pacman -S lightdm lightdm-gtk-greeter i3-wm rofi polybar pacman-contrib ttf-font-awesome kitty brightnessctl nitrogen git chezmoi efibootmgr grub os-prober
```

[Enable](https://wiki.archlinux.org/title/Enable) `lightdm.service` so LightDM will be started at boot; see also [Display manager#Loading the display manager](https://wiki.archlinux.org/title/Display_manager#Loading_the_display_manager).

### Exit and reboot
```
exit
umount -R /mnt
reboot
```

THIS GUIDE WILL BE UPDATED. (ADD GRUB)