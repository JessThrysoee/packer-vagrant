#!/bin/bash

echo "packer_provisioning_ubuntu_2.sh -- start" >&2

export DEBIAN_FRONTEND=noninteractive

mount -r -t iso9660 /dev/sr1 /mnt

if [[ -x /mnt/VBoxLinuxAdditions.run ]]
then
   packages="linux-headers-$(uname -r) build-essential perl dkms"
   apt-get -y install $packages

   /mnt/VBoxLinuxAdditions.run --nox11
   umount /mnt

   apt-get -y purge $packages
   apt-get -y autoremove --purge

   # 14.04 autoremoves openssh-server for some reason?
   apt-get -y install openssh-server

else
   echo "guest addition not found" >&2
   exit 1
fi


echo "packer_provisioning_ubuntu_2.sh -- end" >&2
