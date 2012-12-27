#!/bin/bash

source ../lib.sh

test_file=$1
num_iterations=$2

print_header "FastTagsoup.hs" $test_file
timeit ./dist/build/fast-tagsoup/fast-tagsoup "$test_file" $num_iterations
