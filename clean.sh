#!/bin/bash

for vendor in redhat ubuntu
do
   rm -rf $vendor/vm-* $vendor/box $vendor/packer_cache
done

