// Created by github.com/programmerby on 2012-12-29
// Part of github.com/seriyps/html-parsers-benchmark

using System;
using System.Globalization;
using System.IO;
using HtmlAgilityPack;

class BenchHtmlAgilityPack {
	static void Main(string[] args) {
		if (args.Length < 2) {
			Console.WriteLine("Usage: BenchHtmlAgilityPack.exe filename iterations");
			return;
		}

		var streamReader = new StreamReader(args[0]);
		string text = streamReader.ReadToEnd();
		streamReader.Close();

		int n = int.Parse(args[1]);

		var start = DateTime.Now;
		for (int i = 0; i < n; i++) {
			var doc = new HtmlDocument();
			doc.LoadHtml(text);
		}
		var stop = DateTime.Now;

		var duration = stop - start;
		Console.WriteLine("{0} s", (duration.TotalMilliseconds / 1000.0).ToString(CultureInfo.InvariantCulture));
	}
}
