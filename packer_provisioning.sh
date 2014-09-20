#!/bin/bash

# parallels
if [[ $PACKER_BUILDER_TYPE = parallels*  ]]
then
   mount -r -t iso9660 /dev/sr2 /mnt

   if [[ -x /mnt/install ]]
   then
      /mnt/install --install-unattended-with-deps --progress
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
      yum -y install gcc make perl kernel-devel-$(uname -r)

      /mnt/VBoxLinuxAdditions.run --nox11
      yum -y history undo last

      umount /mnt

   else
      echo "guest addition not found" >&2
      exit 1
   fi

else
   echo "Unsupported builder: $PACKER_BUILDER_TYPE" >&2
   exit 1
fi

# network
rm -f /etc/udev/rules.d/70-persistent-net.rules
sed -i -e '/^HWADDR/d' -e '/^UUID/d' /etc/sysconfig/network-scripts/ifcfg-eth0

