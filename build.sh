#!/bin/bash -e

provider=virtualbox
vendor="$1"
el="$2"

supported_ubuntu=16.10

usage() {
   echo "usage: $(basename $0) <centos|rhel|ol> <6|7>"
   echo "usage: $(basename $0) ubuntu <$supported_ubuntu>"
   exit 1
}

if [[ $vendor != ubuntu && $vendor != centos && $vendor != rhel && $vendor != ol ]]
then
   echo "suported vendors 'ubuntu', 'centos', 'rhel', 'ol'"
   usage
fi


if [[ $vendor == ubuntu ]]
then
   if [[ $el != $supported_ubuntu ]]
   then
      echo "suported versions $supported_ubuntu"
      usage
   fi
else
   if [[ $el != 6 && $el != 7 ]]
   then
      echo "suported versions '6' or '7'"
      usage
   fi
fi

if [[ $vendor == rhel ]] && [[ -z $REDHAT_REGISTRATION_USERNAME || -z $REDHAT_REGISTRATION_PASSWORD ]]
then
   echo "Pass Red Hat user account name and password to subscription-manager by setting environment variables:"
   echo ""
   echo "export REDHAT_REGISTRATION_USERNAME=username"
   echo "export REDHAT_REGISTRATION_PASSWORD=password"
   echo ""
   usage
fi

if [[ $vendor == ubuntu ]]
then
   cd ubuntu
else
   cd redhat
fi

export VAGRANT_DEFAULT_PROVIDER=$provider
export VENDOR=$vendor
export EL=$el

#rm -rf output-${provider}-iso
#vagrant destroy
#vagrant box remove --force JessThrysoee/packer_${vendor}-${el} && true

rm -rf vm-${provider}
packer build -only=${provider}-iso -var-file=var/${vendor}-${el}.json packer.json

vagrant box add --force --name JessThrysoee/${vendor}-${el}-${provider} box/${vendor}-${el}-${provider}.box
vagrant up --provider $provider
vagrant destroy -f

