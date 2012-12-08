#!/bin/bash

parsers=`ls *_parser.py`

source env/bin/activate
test_file=$1
num_iterations=$2

for parser in $parsers; do
    echo "******************************"
    echo "parser:$parser	file:$test_file"
    /usr/bin/time --format="real:%e	user:%U	sys:%S	max RSS:%M" python $parser $test_file $num_iterations
done
