import 'package:html/parser.dart';

class TextUtils {
  static String removeAllHtmlTags(String htmlText) {
    final document = parse(htmlText);
    final String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  static String getVideoUrl(String htmlText) {
    final document = parse(htmlText);
    var iframe = document.body.getElementsByTagName("iframe");
    if (iframe.length > 0) {
      return iframe[0].attributes['src'];
    }
    return null;
  }

}
