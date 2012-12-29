#!/bin/bash
source ./lib.sh

for tst in $PLATFORMS; do
    if [ -d $tst ]; then
        echo "==============="
        echo $tst;
        echo "==============="

        cd $tst
        ./prepare.sh
        cd ../
    fi
done
