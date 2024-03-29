#!/bin/sh

# change NVIDIA card power control
echo -n auto > /sys/bus/pci/devices/0000\:01\:00.0/power/control
sleep 1
# change PCIe power control
echo -n auto > /sys/bus/pci/devices/0000\:00\:01.0/power/control
sleep 1

# lock system form loading nvidia module
mv /etc/modprobe.d/disable-nvidia.conf.disable /etc/modprobe.d/disable-nvidia.conf

# feedback
echo "The GPU will be disabled on the next reboot."
