#!/bin/bash

echo "packer_provisioning_redhat_2.sh -- start" >&2

# parallels
if [[ $PACKER_BUILDER_TYPE = parallels*  ]]
then
   mount -r -t iso9660 /dev/sr1 /mnt

   if [[ -x /mnt/install ]]
   then
      /mnt/install --install-unattended-with-deps --progress
      if [[ -f /var/log/parallels-tools-install.log ]]
      then
         cat /var/log/parallels-tools-install.log
      fi

      yum -q -y history undo last

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
      yum -q -y install checkpolicy make gcc kernel-devel-$(uname -r) perl dkms bzip2
      if [[ $VENDOR == ol ]]
      then
         yum -q -y install kernel-uek-devel-$(uname -r)
      fi

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


if [[ $VENDOR == rhel ]]
then
   subscription-manager remove --all
   subscription-manager unregister
   subscription-manager clean
fi


# network
rm -f /etc/udev/rules.d/70-persistent-net.rules
sed -i -e '/^HWADDR/d' -e '/^UUID/d' /etc/sysconfig/network-scripts/ifcfg-eth0


echo "packer_provisioning_redhat_2.sh -- end" >&2
