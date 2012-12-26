#!/bin/bash
source ../lib.sh

test_file=$1
num_iterations=$2

print_header "TestJSoup.java" $test_file
timeit java -Xmx512m -server -jar benchmark.jar "$test_file" $num_iterations