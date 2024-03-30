#!/bin/bash

virsh destroy debian-linux
virsh undefine --managed-save --remove-all-storage debian-linux
rm ~/.cache/libvirt/qemu/log/debian-linux.log
