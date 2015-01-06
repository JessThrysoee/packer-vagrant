#!/bin/bash -e

provider="$1"
el="$2"

if [[ $provider != parallels && $provider != virtualbox ]]
then
   echo "suported providers 'parallels' or 'virtualbox'"
   echo "usage: $(basename $0) <parallels|virtualbox> <6|7>"
   exit 1
fi

if [[ $el != 6 && $el != 7 ]]
then
   echo "suported redhat versions '6' or '7'"
   echo "usage: $(basename $0) <parallels|virtualbox> <6|7>"
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
vagrant destroy -f

