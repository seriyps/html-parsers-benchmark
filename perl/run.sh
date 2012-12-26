#!/bin/bash
source ../lib.sh

parsers=`ls *_parser.pm`

export PERL5LIB=env/lib/perl5
test_file=$1
num_iterations=$2

for parser in $parsers; do
    print_header $parser $test_file
    timeit perl $parser $test_file $num_iterations
done
