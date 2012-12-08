#!/bin/bash

virtualenv --system-site-packages env
source env/bin/activate

pip install lxml beautifulsoup4 BeautifulSoup html5lib
