#!/bin/bash
source ../lib.sh

test_file=$1
num_iterations=$2

print_header "tidy_simplexml.php" $test_file
timeit php -f ./tidy_simplexml.php "$test_file" $num_iterations
