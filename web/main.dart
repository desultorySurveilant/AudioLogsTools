import 'dart:html' hide File;
import 'dart:io';
import 'dart:convert';

void main() {
  querySelector('#output').text = 'Your Dart app is running.';

  File logsFile = File('logs.txt');
  List<String> knownLogs = logsFile.readAsLinesSync();
//  int count = 0;
  for(String w in knownLogs) {
//  	url = "http://farragnarok.com/PodCasts/" + w + ".png";
//  	if(exists(url))print(url);
    print(checkGigglesnort(w));
  	print(toWikiLink(w));
//    if(count % 32 == 0)System.out.println(count); count++;
  }
}
bool exists(String path) => FileSystemEntity.typeSync(path) != FileSystemEntityType.notFound;
String toWikiLink(String log) {
  return "[http://farragofiction.com/AudioLogs/?passPhrase=" + log + " " + log + "]\n";
}
String checkGigglesnort(String w) {
  try {
    File logData = File('http://farragnarok.com/PodCasts/$w.json');
    if(logData.existsSync()) {
      var j = jsonDecode(logData.readAsStringSync());
      print('$w:${j['gigglesnort']}');
    }else {
      print(w + ": " + "no gigglesnort here, boss");
    }
  } catch (e) {
  e.printStackTrace();
  print("TESTED PASSPHRASE " + w + " FAILED");
  }
}