#!/bin/bash

virt-install \
	--name debian-linux \
	--cdrom ~/Downloads/softwares/debian-12.5.0-amd64-DVD-1.iso \
	--osinfo detect=on,name=debian12 \
	--virt-type kvm \
	--vcpus 4 \
	--memory 4096 \
	--disk size=40 \
