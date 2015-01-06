#!/bin/bash

for el in 6 7
do
   rm -rf $el/vm-* $el/box $el/packer_cache
done

