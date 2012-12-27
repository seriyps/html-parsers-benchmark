#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''
Created on 2012-12-09

@author: Sergey <me@seriyps.ru>

Convert ./run.sh output to CSV file

This one:

===============
pypy
===============
******************************
parser:bsoup3_parser.py	file:../page_google.html
1.15545797348 s
real:1.18	user:1.17	sys:0.01	max RSS:56532

Becomes CSV like:

platform,parser,file,parser s,real s,user s,sys s,maximum RSS
pypy,bsoup3_parser.py,page_google.html,1.15545797348,1.18,1.17,0.01,56532
'''
import sys
import csv
import re

l1_re = re.compile(r"^parser:([0-9a-zA-Z_.-]+)\tfile:(.*)")


def parse_line1(line):
    match = l1_re.search(line)
    filepath = match.group(2)
    return match.group(1), filepath.split("/")[-1]

l2_re = re.compile(r"^([0-9.]+) s")


def parse_line2(line):
    match = l2_re.search(line)
    return match.group(1)

l3_re = re.compile(
    r"^real:([0-9.]+)\tuser:([0-9.]+)\tsys:([0-9.]+)\tmax RSS:([0-9]+)")


def parse_line3(line):
    match = l3_re.search(line)
    return match.group(1), match.group(2), match.group(3), match.group(4)


columns = ["platform", "parser", "file", "parser s",
           "real s", "user s", "sys s", "maximum RSS"]
PLATFORM_HDR, PLATFORM, TEST_HDR, TEST_1, TEST_2, TEST_3 = range(6)


def main(in_file=sys.stdin, out_file=sys.stdout):
    csvwriter = csv.DictWriter(out_file, columns)
    csvwriter.writeheader()

    state = None
    r = {}
    for line in in_file:
        if state == PLATFORM_HDR:
            r["platform"] = line.strip()
            state = PLATFORM
        elif state == PLATFORM:
            state = None
        elif state == TEST_HDR:
            r["parser"], r["file"] = parse_line1(line)
            state = TEST_1
        elif state == TEST_1:
            r["parser s"] = parse_line2(line)
            state = TEST_2
        elif state == TEST_2:
            (r["real s"], r["user s"],
             r["sys s"], r["maximum RSS"]) = parse_line3(line)
            csvwriter.writerow(r)
            r = {"platform": r["platform"]}  # drop all fields, except platform
            state = TEST_3
        elif line.startswith("==="):
            state = PLATFORM_HDR
        elif line.startswith("***"):
            state = TEST_HDR
        else:
            raise ValueError('Invalid input: "{0}"'.format(line))

if __name__ == '__main__':
    main()
