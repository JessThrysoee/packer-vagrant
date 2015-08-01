#!/bin/bash -e

provider="$1"
vendor="$2"
el="$3"

usage() {
   echo "usage: $(basename $0) <parallels|virtualbox> <centos|rhel> <6|7>"
   echo "usage: $(basename $0) <parallels|virtualbox> ubuntu <15.04>"
   exit 1
}

if [[ $provider != parallels && $provider != virtualbox ]]
then
   echo "suported providers 'parallels' or 'virtualbox'"
   usage
fi

if [[ $vendor != ubuntu && $vendor != centos && $vendor != rhel ]]
then
   echo "suported vendors 'ubuntu', 'centos', or 'rhel'"
   usage
fi


if [[ $vendor != ubuntu ]]
then
   if [[ $el != 6 && $el != 7 ]]
   then
      echo "suported versions '6' or '7'"
      usage
   fi
else
   if [[ $el != 15.04 ]]
   then
      echo "suported versions '15.04'"
      usage
   fi
fi

if [[ $vendor == rhel ]] && grep -q '@\(username\|password\)@' packer_provisioning.sh
then
   echo "Pass Red Hat user account name and password to subscription-manager by setting environment variables:"
   echo ""
   echo "export REDHAT_REGISTRATION_USERNAME=username"
   echo "export REDHAT_REGISTRATION_PASSWORD=password"
   echo ""
   usage
fi

cd $el

export VAGRANT_DEFAULT_PROVIDER=$provider
export VENDOR=$vendor
export EL=$el

#rm -rf output-${provider}-iso
#vagrant destroy
#vagrant box remove --force JessThrysoee/packer_${vendor}-${el} && true

rm -rf vm-${provider}
packer build -only=${provider}-iso -var-file=packer_variables_${vendor}.json packer.json

vagrant box add --force --name JessThrysoee/${vendor}-${el}-${provider} box/${vendor}-${el}-${provider}.box
vagrant up --provider $provider
vagrant destroy -f

