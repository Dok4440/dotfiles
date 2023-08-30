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
Install the bare minimum to run Arch Linux, I've included the `neovim` package here to make the next steps easier but this isn't necessary.
```
pacstrap /mnt base base-devel linux linux-firmware sudo networkmanager neovim
```

### Configuring before reboot
`Arch-chroot` into your newly installed system to configure it before rebooting your machine. This script is part of the `arch-install-scripts` package.
```
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
```

edit `etc/locale.gen` with nvim to uncomment the language(s) you want. Then run the following command to generate them.
```
locale-gen
```

edit `/etc/locale.conf` to set the default langauge. Here's an example to set the default language to "en_US".
```bash
LANG=en_US.UTF-8
```

Set the password for root.
```
passwd
```

Configure a new user to run `i3-wm` with. It is never recommended to use i3 as root. We're giving this user sudo permissions, however this is not required.
```
useradd --create-home <username>
usermod -aG wheel
```

\* To give sudo permissions: uncomment `# %wheel ALL=(ALL) ALL` in `/etc/sudoers`.

### Packages
[Enable](https://wiki.archlinux.org/title/Enable) `NetworkManager`.

Install processor microcode:
```
# AMD
pacman -S amd-ucode

# Intel
pacman -S intel-ucode
```

Install xorg:
```
pacman -S xorg-server
```

Install graphics drivers:
```
# NVIDIA
pacman -S nvidia nvidia-utils

# AMD
pacman -S xf86-video-amdgpu

# Intel integrated
pacman -S xf86-video-intel
```

Install the required packages for my specific i3 configuration as shared in this repository:

```bash
pacman -S i3-wm lightdm lightdm-slick-greeter efibootmgr grub
```

[Enable](https://wiki.archlinux.org/title/Enable) `lightdm.service` so LightDM will be started at boot; see also [Display manager#Loading the display manager](https://wiki.archlinux.org/title/Display_manager#Loading_the_display_manager).  

\* For a complete list of packages, checkout [README.md](README.md) and my [package lists](/dot_pkg_list/). Make sure to read [Tips_and_tricks#Install_packages_from_a_list](https://wiki.archlinux.org/title/Pacman/Tips_and_tricks#Install_packages_from_a_list)

### Configure GRUB
To start, let's create the EFI directory where we'll mount the efi partition.
```bash
mkdir /boot/efi
mount /dev/sda1 /boot/efi
```

Now we'll use 'grub-install' to install GRUB in the newly mounted EFI partition.
```bash
grub-install --target=x86_64-efi --bootloader-id=some_name
```

If you're installing Arch alongside other operating systems, you'll also need the `os-prober` package. This package will search for already installed operating systems on your machine and will make them a part of your GRUB. you'll have to enable it before generating the config. To do so, open the `/etc/default/grub` file in a text editor and uncommont the following line:
```
#GRUB_DISABLE_OS_PROBER=false
```

Now execute the following command to generate the configuration file:
```
grub-mkconfig -o /boot/grub/grub.cfg
```

\* *[#configuration (5. GRUB theme)](https://github.com/Dok4440/dotfiles/blob/main/README.md#configuration)*


### Exit and reboot
```
exit
umount -R /mnt
reboot
```
