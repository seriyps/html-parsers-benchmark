#!/bin/bash

# gcc -o libxml2_html_parser -O2 main.c
gcc -o libxml2_html_parser -O2 `xml2-config --cflags` main.c `xml2-config --cflags --libs`
