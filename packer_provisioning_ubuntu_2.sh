#!/bin/bash

echo "packer_provisioning_ubuntu_2.sh -- start" >&2

sleep 30

# parallels
if [[ $PACKER_BUILDER_TYPE = parallels*  ]]
then
   mount -r -t iso9660 /dev/sr1 /mnt

   if [[ -x /mnt/install ]]
   then
      packages="make gcc linux-headers-$(uname -r) build-essential"
      apt-get -y install $packages

      /mnt/install --install-unattended --progress
      if [[ -f /var/log/parallels-tools-install.log ]]
      then
         cat /var/log/parallels-tools-install.log
      fi

      apt-get -y purge $packages
      apt-get -y autoremove --purge

      umount /mnt

   else
      echo "guest addition not found" >&2
      exit 1
   fi

# virtualbox
elif [[ $PACKER_BUILDER_TYPE = virtualbox* ]]
then
   mount -r -t iso9660 /dev/sr1 /mnt

   if [[ -x /mnt/VBoxLinuxAdditions.run ]]
   then
      yum -q -y install checkpolicy make gcc kernel-devel-$(uname -r) perl dkms

      /mnt/VBoxLinuxAdditions.run --nox11
      yum -q -y history undo last

      umount /mnt

   else
      echo "guest addition not found" >&2
      exit 1
   fi

else
   echo "Unsupported builder: $PACKER_BUILDER_TYPE" >&2
   exit 1
fi

echo "packer_provisioning_ubuntu_2.sh -- end" >&2
