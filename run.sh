#!/bin/bash
source ./lib.sh

help_and_exit() {
    echo "Usage $0 <number of iterations>";
    exit 1;
}

if [ ! $1 ]; then
    help_and_exit
fi

testfiles=`ls page_*.html`
num_iterations=$1

for tst in $PLATFORMS; do
    echo "==============="
    echo $tst;
    echo "==============="

    cd $tst
    for testfile in $testfiles; do
        ./run.sh "../$testfile" $num_iterations
    done
    cd ../
done
