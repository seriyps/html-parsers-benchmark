#!/bin/bash
source ../lib.sh

test_file=$1
num_iterations=$2

print_header "libxml2_html_parser.c" $test_file
timeit ./libxml2_html_parser "$test_file" $num_iterations
