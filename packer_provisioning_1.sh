#!/bin/bash

echo "packer_provisioning_ubuntu_1.sh -- start" >&2

if [[ $VENDOR == rhel ]]
then
   # Issue https://github.com/projectatomic/adb-vagrant-registration/issues/34
   sudo ln -s /usr/sbin/subscription-manager /sbin && true

   subscription-manager register --username $REDHAT_REGISTRATION_USERNAME --password $REDHAT_REGISTRATION_PASSWORD --auto-attach
fi

yum -y install policycoreutils-python setroubleshoot setroubleshoot-server
yum -y upgrade

# reboot so guest tool are build for potentially upgraded kernel
echo "packer_provisioning_1.sh -- end/reboot" >&2
reboot

