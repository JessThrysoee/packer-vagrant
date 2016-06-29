#!/bin/bash

echo "packer_provisioning_ubuntu_1.sh -- start" >&2

# non graphical
systemctl set-default multi-user.target

# network
rm -f /etc/udev/rules.d/70-persistent-net.rules
#sed -i -e '/^HWADDR/d' -e '/^UUID/d' /etc/sysconfig/network-scripts/ifcfg-eth0

# sudoers
echo 'vagrant ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/vagrant
echo 'Defaults !requiretty' >> /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant

# ssh
mkdir -pm 700 ~vagrant/.ssh
wget -O ~vagrant/.ssh/authorized_keys https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub
chmod 0600 ~vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant ~vagrant/.ssh

# upgrade
apt-get -y update
apt-get -y dist-upgrade
apt-get -y autoremove
apt-get -y autoclean
apt-get -y clean

# reboot so guest tools are build for potentially upgraded kernel

echo "packer_provisioning_ubuntu_1.sh -- end/reboot" >&2
reboot
sleep 30
