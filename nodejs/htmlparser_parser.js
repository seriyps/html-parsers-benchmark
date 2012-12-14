// Created on 2012-12-15
// @author: Sergey Prokhorov <me@seriyps.ru>

var htmlparser = require('htmlparser');
var fs = require('fs');

(function(){
    var filename = process.argv[2], n = parseInt(process.argv[3]);

    var html = fs.readFileSync(filename);

    var start = new Date();
    for (var i=0; i < n; i++) {
        var hndlr = new htmlparser.DefaultHandler()
        var parser = new htmlparser.Parser(hndlr);
        parser.parseComplete(html);
        hndlr.dom
    }
    var end = new Date();

    console.log('%d s', (end - start) / 1000);
})()


