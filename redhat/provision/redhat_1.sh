#!/bin/bash

echo "packer_provisioning_redhat_1.sh -- start" >&2

if [[ $VENDOR == rhel ]]
then
   subscription-manager register --username $REDHAT_REGISTRATION_USERNAME --password $REDHAT_REGISTRATION_PASSWORD --auto-attach
fi

yum -y install \
   policycoreutils-python \
   libselinux-python \
   setroubleshoot-server \
   setools-console

yum -y upgrade

# reboot so guest tool are build for potentially upgraded kernel
echo "packer_provisioning_redhat_1.sh -- end/reboot" >&2
reboot

