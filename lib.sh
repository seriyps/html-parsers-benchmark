#!/bin/bash

timeit () {
    # XXX: how to redirect time's output to stdout, but leave command's
    # errors on stderr? -o /dev/tty is ok in general, but causes problems
    # with GNU parallel
    /usr/bin/time --format="real:%e	user:%U	sys:%S	max RSS:%M" $@ 2>&1
}

print_header() {
    parser=$1
    test_file=$2
    echo "******************************"
    echo "parser:$parser	file:$test_file"
}

if [ -z "$PLATFORMS" -a -f "platforms.txt" ]; then
    PLATFORMS=`cat platforms.txt`
fi
