HTML parsers benchmark
======================

Simple HTML DOM parser benchmark.

Competitors
-----------

### Erlang

* Mochiweb html parser.
  https://github.com/mochi/mochiweb/blob/master/src/mochiweb_html.erl
  The only real-world HTML parser for Erlang. Written on pure Erlang.

### CPython

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

### PyPi

* BeautifulSoup 3
* BeautifulSoup 4
* html5lib

### C

* libxml2
  http://xmlsoft.org/html/libxml-HTMLparser.html
  Written on C non-strict HTML parser.

Preparation
-----------

Install OS dependencies python-virtualenv, erlang, pypy, C compiler and libxml2
dev packages

    sudo apt-get install python-virtualenv python-lxml erlang-base pypy \
        libxml2-dev libxslt1-dev build-essential

Then run (it will prepare virtual environments, fetch dependencies, compile erlang code etc)

    ./prepare.sh

In case of errors, I recommended to install also `cython`, `python-dev` and retry. 

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


How to add my %platformname% to benchmark set?
----------------------------------------------

Create directory %platformname%

    mkdir %platformname%

Create `run.sh` and `prepare.sh` scripts:

* `run.sh` - called every time when benchmark starts. Must use `print_header()`
  and `timeit()` functions from `lib.sh` to format output for each test.
  It must accept 2 arguments: HTML file path and number of iterations and pass
  them unchanged to benchmark scripts.
* `prepare.sh` - called only once, before runing any benchmarks. It can download
  dependencies, compile sources etc.

Create your benchmark scripts. Requirements:

* Must accept 2 arguments: path to HTML file and number of iterations
* Must read HTML file once, then perform "number of iterations" parse cycles
* Must print parser-loop runtime in seconds, calculated like
  `start = time(); do_n_iterations(N); print time() - start`
* On each iteration must build full DOM tree in memory

Add %platformname% to top `run.sh` to `tests` variable.

How to add new HTML to benchmark?
---------------------------------

Just create HTML file named `page_<some_page_name>.html`.
