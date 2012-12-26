#!/bin/bash

curl -L http://cpanmin.us | perl - --sudo App::cpanminus
cpanm -L 'env' Mojolicious

# cpan Mojolicious
