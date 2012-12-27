#!/bin/bash
source ../lib.sh

cd bin
parsers=`ls *_parser.dart`
cd ..

test_file=$1
num_iterations=$2

for parser in $parsers; do
    print_header $parser $test_file
    timeit dart bin/$parser $test_file $num_iterations
done
