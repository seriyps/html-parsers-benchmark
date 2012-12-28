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
import argparse


argparser = argparse.ArgumentParser(
    description='Convert benchmark output to CSV')
argparser.add_argument(
    '--skip-header', dest='skip_header', action='store_true',
    help="Don't output column names (useful for concatenation)")
argparser.add_argument(
    '--skip-errors', dest='skip_errors', action='store_true',
    help="Silently drop benchmarks, that we can't parse (eg, with tracebacks)")


l1_re = re.compile(r"^parser:([0-9a-zA-Z_.-]+)\tfile:(.*)")


def parse_line1(line):
    match = l1_re.search(line)
    parser = match.group(1).split("/")[-1]
    filepath = match.group(2).split("/")[-1]
    return parser, filepath

l2_re = re.compile(r"^([0-9.]+)( s)?")


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


class Parser(object):

    def __init__(self, skip_errors=False):
        self.skip_errors = skip_errors
        self.state = None
        self.r = {}

    def reset(self):
        self.r = {"platform": self.r["platform"]}

    def parse_line(self, line):
        try:
            return self.do_parse_line(line)
        except:
            if self.skip_errors:
                self.reset()
                self.state = None
            else:
                raise

    def do_parse_line(self, line):
        c = self
        if c.state == PLATFORM_HDR:
            c.r["platform"] = line.strip()
            c.state = PLATFORM
        elif c.state == PLATFORM:
            c.state = None
        elif c.state == TEST_HDR:
            c.r["parser"], c.r["file"] = parse_line1(line)
            c.state = TEST_1
        elif c.state == TEST_1:
            c.r["parser s"] = parse_line2(line)
            c.state = TEST_2
        elif c.state == TEST_2:
            (c.r["real s"], c.r["user s"],
             c.r["sys s"], c.r["maximum RSS"]) = parse_line3(line)
            r = self.r
            c.reset()
            c.state = TEST_3
            return r
        elif line.startswith("==="):
            c.state = PLATFORM_HDR
        elif line.startswith("***"):
            c.state = TEST_HDR
        else:
            raise ValueError('Invalid input: "{0}"'.format(line))


def main(in_file=sys.stdin, out_file=sys.stdout):
    args = argparser.parse_args()
    csvwriter = csv.DictWriter(out_file, columns)
    if not args.skip_header:
        csvwriter.writeheader()

    c = Parser(skip_errors=args.skip_errors)
    for line in in_file:
        row = c.parse_line(line)
        if row:
            csvwriter.writerow(row)


if __name__ == '__main__':
    main()
