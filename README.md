HTML parsers benchmark
======================

Simple HTML DOM parser benchmark.

Competitors
-----------

=== Erlang

* Mochiweb html parser.
  https://github.com/mochi/mochiweb/blob/master/src/mochiweb_html.erl
  The only real-world HTML parser for Erlang. Written on pure Erlang.

=== CPython

* lxml.etree.HTML
  http://lxml.de/
  libxml2 binding. Cython
* BeautifulSoup 3
  http://www.crummy.com/software/BeautifulSoup/bs3/documentation.html
  Pure python HTML DOM parser v3.
* BeautifulSoup 4
  http://www.crummy.com/software/BeautifulSoup/bs4/doc/
  HTML DOM parser with pluggable backends.
* html5lib
  http://code.google.com/p/html5lib/
  Pure python DOM parser oriented to HTML5.

=== PyPi

* BeautifulSoup 3
* BeautifulSoup 4
* html5lib

Preparation
-----------

Install python-virtualenv, python-lxml (or it can be installed via pip), erlang, pypy

    sudo apt-get install python-virtualenv python-lxml erlang-base pypy

Then run (it will prepare virtual environments, fetch dependencies, compile erlang code etc)

    ./prepare.sh

In case of errors, I recommended to install `libxml2-dev` and `libxslt1-dev` and retry. 

RUN
---

Just run

    ./run.sh <number of parser iterations>

eg

    ./run.sh 5000

Results
-------

To convert results to CSV file, use `to_csv.py`

    ./run.sh 5000 2>&1 | ./to_csv.py

or smth like

    ./run.sh 2>&1 | tee output.txt
    ./to_csv.py < output.txt
