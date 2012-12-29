#!/bin/bash
source ../lib.sh

test_file=$1
num_iterations=$2

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export MONO_PATH=$DIR/HtmlAgilityPack/lib/Net40
print_header "BenchHtmlAgilityPack.cs" $test_file
timeit mono -O=all BenchHtmlAgilityPack.exe "$test_file" $num_iterations

export MONO_PATH=$DIR/SgmlReader/lib/4.0
print_header "BenchSgmlReader.cs" $test_file
timeit mono -O=all BenchSgmlReader.exe "$test_file" $num_iterations
