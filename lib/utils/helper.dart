import 'dart:convert';

class Helper {
  static void printAll(String title, dynamic element) {
    print('- - - - - - - - $title - - - - - - - - -');
    print('');
    printWrapped(jsonEncode(element));
    print('');
    print('- - - - - - - - - - - - - - - - -');
  }
  
  static void printWrapped(String text) {
    final pattern = RegExp('.{1,800}');
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}