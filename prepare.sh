#!/bin/bash
source ./lib.sh

for tst in $PLATFORMS; do
    cd $tst
    ./prepare.sh
    cd ../
done
