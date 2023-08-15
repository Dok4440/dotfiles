\>\>\>\>\>\>\> https://bbs.archlinux.org/viewtopic.php?id=238389


# XPS 15 9570 - Nvidia Switchable

Guide to setup on/off operation of GPU. Based on works collected in [this](https://bbs.archlinux.org/viewtopic.php?id=238389) thread.

GPU management scripts were created by [tyrells](https://bbs.archlinux.org/viewtopic.php?pid=1825298#p1825298) to which manipulation of blacklist config was added.

## Packages
- nvidia
- bumblebee (for optirun)
- tlp (optional)
- powertop (optional - for verification)
- unigine-valley (aur, optional - for verification)

This guide should be easily adapted to *xrun* as *bumblebee* is only used for *optirun*.

## Configuration

### /etc/default/tlp
Add GPU to TLP **RUNTIME_PM_BLACKLIST**.
```
RUNTIME_PM_BLACKLIST="01:00.0"
```

### /etc/bumblebee/bumblebee.conf
```
Driver=nvidia
```
And in nvidia section:
```
PMMethod=none
```

### /etc/tempfiles.d/nvidia_pm.conf
Allow gpu to poweroff on boot
```
w /sys/bus/pci/devices/0000:01:00.0/power/control - - - - auto
```
###  /etc/X11/xorg.conf.d/01-noautogpu.conf 
```
Section "ServerFlags"
	Option "AutoAddGPU" "off"
EndSection
```

### /etc/X11/xorg.conf.d/20-intel.conf    
```
Section "Device"
 Identifier  "Intel Graphics"
 Driver      "modesetting"
EndSection
``` 

## Create blacklist files

### /etc/modprobe.d/blacklist.conf
```
blacklist nouveau
blacklist rivafb
blacklist nvidiafb
blacklist rivatv
blacklist nv
blacklist nvidia
blacklist nvidia-drm
blacklist nvidia-modeset
blacklist nvidia-uvm
blacklist ipmi_msghandler
blacklist ipmi_devintf 
```

### /etc/modprobe.d/disable-ipmi.conf
These modules are loaded together with nvidia and block its unloading. I do not need [ipmi](https://en.wikipedia.org/wiki/Intelligent_Platform_Management_Interface) therefore I simply disabled this functionality.
```
install ipmi_msghandler /usr/bin/false
install ipmi_devintf /usr/bin/false
```

### /etc/modprobe.d/disable-nvidia.conf
```
install nvidia /bin/false
```

## Create GPU management scripts
GPU management scripts were created by [tyrells](https://bbs.archlinux.org/viewtopic.php?pid=1825298#p1825298) to which manipulation of blacklist config was added.

Create two following management scripts. Creation of aliases is recommended.

### enableGpu.sh
``` bash
#!/bin/sh
# allow to load nvidia module
mv /etc/modprobe.d/disable-nvidia.conf /etc/modprobe.d/disable-nvidia.conf.disable

# remove NVIDIA card (currently in power/control = auto)
echo -n 1 > /sys/bus/pci/devices/0000\:01\:00.0/remove
sleep 1
# change PCIe power control
echo -n on > /sys/bus/pci/devices/0000\:00\:01.0/power/control
sleep 1
# rescan for NVIDIA card (defaults to power/control = on)
echo -n 1 > /sys/bus/pci/rescan
```

### disableGpu.sh
``` bash
modprobe -r nvidia_drm
modprobe -r nvidia_uvm
modprobe -r nvidia_modeset
modprobe -r nvidia

# change NVIDIA card power control
echo -n auto > /sys/bus/pci/devices/0000\:01\:00.0/power/control
sleep 1
# change PCIe power control
echo -n auto > /sys/bus/pci/devices/0000\:00\:01.0/power/control
sleep 1

# lock system form loading nvidia module
mv /etc/modprobe.d/disable-nvidia.conf.disable /etc/modprobe.d/disable-nvidia.conf
```

## Create service which locks GPU on shutdown
Service which locks GPU on shutdown / restart when it is not disabled by *disableGpu.sh* script is necessary. Otherwise on next boot nvidia will be loaded together with *ipmi* modules (even if we have blacklist with *install* command for them) and it would not be possible to unload them.

### /etc/systemd/system/disable-nvidia-on-shutdown.service
```
[Unit]
Description=Disables Nvidia GPU on OS shutdown

[Service]
Type=oneshot
RemainAfterExit=true
ExecStart=/bin/true
ExecStop=/bin/bash -c "mv /etc/modprobe.d/lock-nvidia.conf.disable /etc/modprobe.d/lock-nvidia.conf || true"

[Install]
WantedBy=multi-user.target
```

## Enabling
Reload systemd daemons and enable service:
``` bash
systemctl daemon-reload 
systemctl enable disable-nvidia-on-shutdown.service
```

## Final remarks
1. Reboot and verify that nvidia is not loaded ```lsmod | grep nvidia```
2. Disconnect charger and verify on *powertop* that power consumption is ~4W on idle (Dell XPS 4k, undervolt -168mV core / -145mV cache, disabled touchscreen, powertop --auto-tune)
3. Enable GPU by using script.
4. Verify if GPU is loaded by using ```nvidia-smi```
5. Run unigine-valley ```optirun unigine-valley```
6. Close all nvidia applications and disable gpu.
7. Check again power consumption, it should have similar value as before.

In my case I get ~4w on idle with GPU disabled and ~6W with GPU enabled.
