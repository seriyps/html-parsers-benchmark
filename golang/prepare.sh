#!/bin/bash

# Requirements: go >= 1.0

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
GOPATH=$DIR

# Download source code to $GOPATH/src/
go get github.com/moovweb/gokogiri
go get code.google.com/p/go-html-transform/h5

# Compile & write binaries to $GOPATH/bin/
go install bench_gokogiri
go install bench_h5
go install bench_exp_html 
