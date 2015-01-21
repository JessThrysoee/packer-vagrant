#!/bin/bash -e

provider="$1"
vendor="$2"
el="$3"

usage() {
   echo "usage: $(basename $0) <parallels|virtualbox> <centos|rhel> <6|7>"
   exit 1
}

if [[ $provider != parallels && $provider != virtualbox ]]
then
   echo "suported providers 'parallels' or 'virtualbox'"
   usage
fi

if [[ $vendor != centos && $vendor != rhel ]]
then
   echo "suported vendors 'centos' or 'rhel'"
   usage
fi

if [[ $el != 6 && $el != 7 ]]
then
   echo "suported versions '6' or '7'"
   usage
fi

export VAGRANT_DEFAULT_PROVIDER=$provider
cd $el

rm -rf output-${provider}-iso
vagrant destroy
vagrant box remove --force JessThrysoee/packer_${vendor}-${el} && true

rm -rf vm-${provider}
packer build -only=${provider}-iso -var-file=packer_variables_${vendor}.json packer.json

vagrant box add --force --name JessThrysoee/${vendor}-${el}-${provider} box/${vendor}-${el}-${provider}.box
VENDOR=$vendor vagrant up --provider $provider
vagrant destroy -f

