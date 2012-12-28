import 'dart:io';
import 'package:html5lib/parser.dart' show parse;
import 'package:html5lib/dom.dart';

void main() {
  
  List<String> argv = (new Options()).arguments;
  int argc = argv.length;
  
  if(argc != 2) {
    print("Usage: <path-to-html-file> <number-of-iterations>\n");
    return;
  }
  
  int n = int.parse(argv[1]);
  
  File file = new File(argv[0]);
  file.open(FileMode.READ);
  String html = file.readAsStringSync(Encoding.UTF_8);
  
  int start = new Date.now().difference(new Date.fromMillisecondsSinceEpoch(0)).inMilliseconds;
  
  for(int i = 0; i < n; i++) {
    Document doc = parse(html);
  }
  
  int finish = new Date.now().difference(new Date.fromMillisecondsSinceEpoch(0)).inMilliseconds;
  
  int workTime = finish - start;
  
  Date date = new Date.fromMillisecondsSinceEpoch(workTime);
  print("${date.second}.${date.millisecond}");
}
