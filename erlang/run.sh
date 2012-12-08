#!/bin/bash

test_file=$1
num_iterations=$2

echo "******************************"
echo "parser:mochiweb_html.erl	file:$test_file"
/usr/bin/time --format="real:%e	user:%U	sys:%S	max RSS:%M" ./src/parser.erl "$test_file" $num_iterations
