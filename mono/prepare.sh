#!/bin/bash

# Any subsequent commands which fail will cause the shell script to exit immediately
set -e

# 
if [ ! -d HtmlAgilityPack ]
then
wget --no-check-certificate http://packages.nuget.org/api/v1/package/HtmlAgilityPack/1.4.6 -O HtmlAgilityPack.zip
unzip -d HtmlAgilityPack HtmlAgilityPack.zip
fi

if [ ! -d SgmlReader ]
then
wget --no-check-certificate http://packages.nuget.org/api/v1/package/SgmlReader/1.8.8 -O SgmlReader.zip
unzip -d SgmlReader SgmlReader.zip
fi

# dmcs: compiler to target the 4.0 mscorlib.
# http://www.mono-project.com/CSharp_Compiler
dmcs -out:BenchHtmlAgilityPack.exe -lib:HtmlAgilityPack/lib/Net40,SgmlReader/lib/4.0 -r:HtmlAgilityPack,SgmlReaderDll BenchHtmlAgilityPack.cs
dmcs -out:BenchSgmlReader.exe -lib:SgmlReader/lib/4.0 -r:SgmlReaderDll BenchSgmlReader.cs
