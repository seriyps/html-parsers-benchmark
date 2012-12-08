#!/bin/bash
source ../lib.sh

parsers=`ls *_parser.py`

source env/bin/activate
test_file=$1
num_iterations=$2

for parser in $parsers; do
    print_header $parser $test_file
    timeit python $parser $test_file $num_iterations
done
