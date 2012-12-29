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

### Node.JS

* cheerio
  https://npmjs.org/package/cheerio
  Pure JS HTML DOM parser with jQuery API
* htmlparser
  https://npmjs.org/package/htmlparser
  Pure JS HTML DOM parser
* jsdom
  https://npmjs.org/package/jsdom
  Pure JS HTML DOM parser with rich browser-like API

### Ruby

* nokogiri
  http://nokogiri.org/
  HTML/XML parser based on libxml2

### C

* libxml2
  http://xmlsoft.org/html/libxml-HTMLparser.html
  Written on C non-strict HTML parser.

### Perl

* Mojo::DOM
  http://search.cpan.org/~sri/Mojolicious-3.70/lib/Mojo/DOM.pm
  Written on Perl DOM parser, part of Mojolicious framework

### Google Go

* gokogiri
  https://github.com/moovweb/gokogiri
* go-html-transform
  https://code.google.com/p/go-html-transform
* exp/html
  http://tip.golang.org/pkg/exp/html

### PHP

* tidy + simplexml
  http://php.net/manual/ru/book.tidy.php http://php.net/manual/ru/book.simplexml.php
  Tidy - PHP extension for repearing broken HTML, simplexml - built-in libxml2 binding

### Haskell

* fast-tagsoup
  http://hackage.haskell.org/package/fast-tagsoup

### Java

* JSoup http://jsoup.org/

### Dart

* html5lib.dart
  https://github.com/dart-lang/html5lib
  Written on pure dart port of python's html5lib.py

### Mono

* Html Agility Pack http://htmlagilitypack.codeplex.com
* SGMLReader https://github.com/MindTouch/SGMLReader

Preparation
-----------

Install OS dependencies python-virtualenv, erlang, pypy, C compiler and libxml2
dev packages

    sudo apt-get install ...
        libxml2-dev libxslt1-dev build-essential  # common
        python-virtualenv python-lxml             # python
        erlang-base                               # erlang
        pypy                                      # python PyPy
        nodejs npm                                # NodeJS
        cabal-install libicu-dev                  # Haskell
        php5-cli php5-tidy                        # PHP
        golang                                    # Go
        ruby1.9.1 ruby1.9.1-dev rubygems1.9.1     # Ruby
        maven2 default-jdk                        # Java
        mono-runtime mono-dmcs                    # Mono

Then run (it will prepare virtual environments, fetch dependencies, compile sources etc)

    ./prepare.sh

In case of errors, I recommended to install also `cython`, `python-dev` and retry.

To prepare only some of the platforms, define PLATFORMS environment variable:

    PLATFORMS="pypy python" ./prepare.sh

RUN
---

Just run

    ./run.sh <number of parser iterations>

eg

    ./run.sh 5000

To run tests only for some of the platforms, define PLATFORMS envifonment variable:

    PLATFORMS="pypy python" ./run.sh 5000

To run series of tests use snippets like

    for C in $(echo "10 50 100 400 600 1000"); do ./run.sh $C | tee output_$C.txt; done

Results
-------

To convert results to CSV file, use `to_csv.py`

    ./run.sh 5000 | ./to_csv.py

or smth like

    ./run.sh 5000 | tee output.txt
    ./to_csv.py < output.txt

or, for series

    for C in $(echo "10 50 100 400 600 1000"); do ./to_csv.py < output_$C.txt > results-$C.csv; done

There is also R - script that can build some pretty graphs: `stats/main.r`.

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

Add %platformname% to `platforms.txt` file.

How to add new HTML to benchmark?
---------------------------------

Just create HTML file named `page_<some_page_name>.html`.
