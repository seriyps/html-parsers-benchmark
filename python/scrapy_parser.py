# -*- coding: utf-8 -*-
'''
Created on 2013-01-30

@author: Pavel Shpilev <p.shpilev@gmail.com>
'''
from scrapy.crawler import Crawler
from scrapy.settings import Settings
from scrapy.spider import BaseSpider
from scrapy.selector import HtmlXPathSelector
from scrapy.http import Request

import sys
import time
import os


class BenchmarkSpider(BaseSpider):
    def parse(self, response):
        hxs = HtmlXPathSelector(response)
        yield hxs.extract()
        yield Request(response.url, callback=self.parse, dont_filter=True)


def main():
    do_parse_test(os.path.join('file://127.0.0.1', sys.argv[1]), int(sys.argv[2]))


def do_parse_test(html, n):
    start = time.time()
    spider = BenchmarkSpider(name="benchmark", start_urls=[html])
    crawler = Crawler(Settings(values={'TELNETCONSOLE_PORT': None}))
    crawler.configure()
    crawler.crawl(spider)
    for i in xrange(n):
    	crawler.start()
    	crawler.stop()
    stop = time.time()
    print stop - start, "s"


if __name__ == '__main__':
    main()
