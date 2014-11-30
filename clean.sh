#!/bin/bash

for el in 6.5 7.0
do
   rm -rf $el/vm-* $el/box $el/packer_cache
done

