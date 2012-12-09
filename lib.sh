#!/bin/bash


timeit () {
    /usr/bin/time --format="real:%e	user:%U	sys:%S	max RSS:%M" $@
}

print_header() {
    parser=$1
    test_file=$2
    echo "******************************"
    echo "parser:$parser	file:$test_file"
}

if [ -z "$PLATFORMS" ]; then
    PLATFORMS=`cat platforms.txt`
fi
