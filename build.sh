#!/bin/bash -e

provider="$1"
if [[ $provider != parallels && $provider != virtualbox ]]
then
   echo "suported providers 'parallels' or 'virtualbox'"
   exit 1
fi

export VAGRANT_DEFAULT_PROVIDER=$provider

vagrant destroy
packer build -only=${provider}-iso packer.json
vagrant box remove --force JessThrysoee/packer_centos-6.5 && true
vagrant box add --force --name JessThrysoee/packer_centos-6.5 packer_${provider}-iso_${provider}.box
vagrant up --provider $provider

