#!/bin/bash

parsers="bsoup3_parser.py bsoup4_parser.py html5lib_parser.py"

source env/bin/activate
test_file=$1
num_iterations=$2

for parser in $parsers; do
    echo "******************************"
    echo "parser:$parser	file:$test_file"
    /usr/bin/time --format="real:%e	user:%U	sys:%S	max RSS:%M" python ../python/$parser $test_file $num_iterations
done
