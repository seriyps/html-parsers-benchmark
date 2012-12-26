#!/bin/bash
source ../lib.sh

parsers=`ls *_parser.rb`

test_file=$1
num_iterations=$2

for parser in $parsers; do
    print_header $parser $test_file
    timeit ruby $parser $test_file $num_iterations
done
