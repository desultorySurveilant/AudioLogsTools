import 'dart:html' hide File;
import 'dart:convert';

Future main() async {
  Element output = querySelector('#output');
  String logsFile = await HttpRequest.getString('logs.txt');
  List<String> knownLogs = logsFile.split('\n');
//  int count = 0;

  DivElement div = DivElement();
  ButtonElement gb = ButtonElement()
    ..text = 'Check gigglesnort';
  gb.onClick.listen((e){
    updateOutput(div, knownLogs, 0);
  });
  ButtonElement ib = ButtonElement()
    ..text = 'Check images';
  ib.onClick.listen((e){
    updateOutput(div, knownLogs, 1);
  });
  ButtonElement wb = ButtonElement()
    ..text = 'Make wikia links';
  wb.onClick.listen((e){
    updateOutput(div, knownLogs, 2);
  });
  ButtonElement m4 = ButtonElement()
    ..text = 'Check M4A';
  m4.onClick.listen((e){
    updateOutput(div, knownLogs, 3);
  });
  ButtonElement wp = ButtonElement()
    ..text = 'Make wiki pages';
  wp.onClick.listen((e){
    updateOutput(div, knownLogs, 4);
  });
  output.append(gb); output.appendText('\n');
  output.append(ib); output.appendText('\n');
  output.append(wb); output.appendText('\n');
  output.append(m4); output.appendText('\n');
  output.append(wp); output.appendText('\n');
  output.append(div);

//  for(String w in knownLogs) {
//  	url = "http://farragnarok.com/PodCasts/" + w + ".png";
//  	if(exists(url))print(url);
//    output.appendHtml(await checkGigglesnort(w) + '\n');
//  	print(toWikiLink(w));
//    if(count % 32 == 0)System.out.println(count); count++;
//  }
}
//bool exists(String path) => FileSystemEntity.typeSync(path) != FileSystemEntityType.notFound;
String toWikiLink(String log) {
  return "[http://farragofiction.com/AudioLogs/?passPhrase=$log $log]\n\n";
}
Future<String> checkGigglesnort(String w) async {
  try {
    String logData = await HttpRequest.getString('http://farragnarok.com/PodCasts/$w.json');
    var j = jsonDecode(logData);
    return ('<u>$w</u>:${j['gigglesnort']}');
  } catch (e) {
  return("<b>TESTED PASSPHRASE $w FAILED</b>");
  }
}
Future<String> toWikiPage(String w) async{
  w = w.trim();
  String ret = '\n$w AudioLog\n';
  try {
    String logData = await HttpRequest.getString('http://farragnarok.com/PodCasts/$w.json');
    var j = jsonDecode(logData);
    String keywords = j['keywords'];
    String speaker = j['speaker'];
    String gigglesnort = j['gigglesnort'];
    String summary = j['summary'];
    ret += '{{AudioLog|title1 = $w|keywords = $keywords|speaker = $speaker|gigglesnort = $gigglesnort|summary = $summary}}';
    ret += '\n== Transcript ==\n';
    try{
      String tra = j['transcript'];
      tra.trim();
      if(tra == ''){
        tra = null;
      }else{
        tra = '<nowiki>$tra</nowiki>';
      }
      ret += tra;
      ret += '\n';
    }catch (e) {
      ret += 'Please give me a transcript\n[[Category:Missing Transcript]]';
    }
    ret += '[[Category:AudioLog]]';
  } catch (e) {
    return("TESTED PASSPHRASE $w FAILED");
  }
  return ret;
}
void updateOutput(Element output, List<String> knownLogs, int action) async{
  String append = '';
  output.children.clear();
  for(String w in knownLogs){
    try{
      if(action == 0){
        append = await checkGigglesnort(w) + '\n';
        output.appendHtml(append);
      }else if (action ==1){
        append = 'http://farragnarok.com/PodCasts/$w.png';
        if(await exists(append)){
          output.appendText('$w\n');
          output.append(ImageElement(src: append)..alt = w);
          output.appendText('\n');
        }
      }else if (action == 2){
        append = toWikiLink(w);
        output.appendText(append);
      }else if (action ==3){
        append = 'http://farragnarok.com/PodCasts/$w.m4a';
        if(await exists(append)){
          output.appendText('$append\n');
        }
      }else if (action == 4){
        append = await toWikiPage(w);
        output.appendText(append);
      }
    } catch (e) {
      print('What the hell\'s going on?!');
    }
  }
}
Future <bool> exists(String url) async{
  try{
    await HttpRequest.request(url) != null;
    return true;
  } catch(e) {
    return false;
  }
}