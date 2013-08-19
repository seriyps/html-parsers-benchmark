#!/bin/bash
source ../lib.sh

test_file=$1
num_iterations=$2

print_header "mochiweb_html.erl" $test_file
timeit ./src/mochiweb_parser.erl "$test_file" $num_iterations
print_header "exomler.erl" $test_file
timeit ./src/exomler_parser.erl "$test_file" $num_iterations
