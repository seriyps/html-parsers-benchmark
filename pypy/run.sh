#!/bin/bash
source ../lib.sh

parsers="bsoup3_parser.py bsoup4_parser.py html5lib_parser.py"

source env/bin/activate
test_file=$1
num_iterations=$2

for parser in $parsers; do
    print_header $parser $test_file
    timeit python ../python/$parser $test_file $num_iterations
done
