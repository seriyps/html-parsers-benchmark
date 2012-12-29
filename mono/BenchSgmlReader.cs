// Created by github.com/programmerby on 2012-12-29
// Part of github.com/seriyps/html-parsers-benchmark

using System;
using System.Globalization;
using System.IO;
using System.Xml;
using Sgml;

class BenchSgmlReader {
	static void Main(string[] args) {
		if (args.Length < 2) {
			Console.WriteLine("Usage: BenchSgmlReader.exe filename iterations");
			return;
		}

		var streamReader = new StreamReader(args[0]);
		string text = streamReader.ReadToEnd();
		streamReader.Close();

		int n = int.Parse(args[1]);

		var start = DateTime.Now;
		for (int i = 0; i < n; i++) {
			SgmlReader sgmlReader = new SgmlReader();
			sgmlReader.DocType = "HTML";
			sgmlReader.WhitespaceHandling = WhitespaceHandling.All;
			//sgmlReader.CaseFolding = Sgml.CaseFolding.ToLower;
			sgmlReader.InputStream = new StringReader(text);

			XmlDocument doc = new XmlDocument();
			doc.PreserveWhitespace = true;
			doc.XmlResolver = null;
			doc.Load(sgmlReader);
		}
		var stop = DateTime.Now;

		var duration = stop - start;
		Console.WriteLine("{0} s", (duration.TotalMilliseconds / 1000.0).ToString(CultureInfo.InvariantCulture));
	}
}
