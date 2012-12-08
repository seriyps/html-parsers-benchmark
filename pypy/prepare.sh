#!/bin/bash

pypy_executable=`which pypy`

virtualenv -p $pypy_executable --system-site-packages env
source env/bin/activate

pip install beautifulsoup4 BeautifulSoup html5lib
