#!/bin/bash

help_and_exit() {
    echo "Usage $0 <number of iterations>";
    exit 1;
}

if [ ! $1 ]; then
    help_and_exit
fi

tests="erlang python pypy"
testfiles=`ls page_*.html`
num_iterations=$1

for tst in $tests; do
    cd $tst
    echo "==============="
    echo $tst;
    echo "==============="
    for testfile in $testfiles; do
        ./run.sh "../$testfile" $num_iterations
    done
    cd ../
done
