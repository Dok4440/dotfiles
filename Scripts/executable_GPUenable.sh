#!/bin/sh
# allow to load nvidia module
mv /etc/modprobe.d/disable-nvidia.conf /etc/modprobe.d/disable-nvidia.conf.disable

# remove nvidia card
echo -n 1 > /sys/bus/pci/devices/0000\:01\:00.0/remove
sleep 1

# change PCIe power control
echo -n on > /sys/bus/pci/devices/0000\:00\:01.0/power/control
sleep 1

# rescan for NVIDIA card
echo -n 1 > /sys/bus/pci/rescan

# feedback
echo "the NVIDIA card was turned on."
echo "verify:"
echo "1. 'lsmod | grep nvidia"
echo "2. 'nvidia-smi'"
