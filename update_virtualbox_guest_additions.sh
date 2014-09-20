#!/bin/bash -x

vm_name="CentOS-6.5 (vagrant)"
controller="IDE Controller"

VBoxManage storagectl "$vm_name" --name "$controller" --add ide
VBoxManage storageattach "$vm_name" --storagectl "$controller" --port 1 --device 1 --type dvddrive --medium "/Applications/VirtualBox.app/Contents/MacOS/VBoxGuestAdditions.iso"

vagrant ssh -- 'bash -s' <<"EOF"
sudo yum -y install gcc make perl kernel-devel-$(uname -r)
sudo mount -r -t iso9660 /dev/cdrom2 /mnt
sudo /mnt/VBoxLinuxAdditions.run --nox11
sudo umount /mnt
sudo yum -y history undo last
EOF

VBoxManage storageattach "$vm_name" --storagectl "$controller" --port 1 --device 1 --medium "none"
