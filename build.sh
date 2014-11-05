#!/bin/bash -e

provider="$1"
if [[ $provider != parallels && $provider != virtualbox ]]
then
   echo "suported providers 'parallels' or 'virtualbox'"
   exit 1
fi

export VAGRANT_DEFAULT_PROVIDER=$provider
el=7.0

rm -rf output-parallels-iso
vagrant destroy
vagrant box remove --force JessThrysoee/packer_centos-${el} && true

rm -rf vm-${provider}
packer build -only=${provider}-iso packer.json

vagrant box add --force --name JessThrysoee/centos-${el}-${provider} box/centos-${el}-${provider}.box
vagrant up --provider $provider

