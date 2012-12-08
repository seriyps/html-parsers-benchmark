#!/bin/bash

wget http://cloud.github.com/downloads/basho/rebar/rebar
chmod u+x rebar

./rebar get-deps
./rebar compile
