#!/bin/bash -e

provider="$1"
el="$2"

if [[ $provider != parallels && $provider != virtualbox ]]
then
   echo "suported providers 'parallels' or 'virtualbox'"
   echo "usage: $(basename $0) <parallels|virtualbox> <6.5|7.0>"
   exit 1
fi

if [[ $el != 6.5 && $el != 7.0 ]]
then
   echo "suported redhat versions '6.5' or '7.0'"
   echo "usage: $(basename $0) <parallels|virtualbox> <6.5|7.0>"
   exit 1
fi

export VAGRANT_DEFAULT_PROVIDER=$provider
cd $el

rm -rf output-parallels-iso
vagrant destroy
vagrant box remove --force JessThrysoee/packer_centos-${el} && true

rm -rf vm-${provider}
packer build -only=${provider}-iso packer.json

vagrant box add --force --name JessThrysoee/centos-${el}-${provider} box/centos-${el}-${provider}.box
vagrant up --provider $provider

