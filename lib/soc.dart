import 'dart:convert';

String lelf_align(String str) {
  List x = str.split("");

  String result = "";
  String space = "    ";
  int currentIdx = 0;

  // print(x);
  for (dynamic item in x) {
    if (item.toString().contains("{")) {
      currentIdx += 1;
      String ident = "\n" + space * currentIdx;
      item += ident;
      result += item;
    } else {
      result += item;
    }
  }
  // print(result.toString());
  String r = result.toString();
  return r;
}

String right_align(String str) {
  List x = str.split("");

  String result = "";
  String space = "    ";
  int currentIdx = 0;

  // print(x);
  for (dynamic item in x) {
    if (item.toString().contains("}")) {
      currentIdx += 1;
      String ident = space * currentIdx + "\n";
      item = ident + item;
      result += item;
    } else {
      result += item;
    }
  }
  // print(result.toString());
  String r = result.toString();
  return r;
}

String str =
    '''{"latest_post": [{"id": 6, "author": {"username": "test", "external_id": "1241c081-1584-43a3-be8c-65cd73953890", "id": 1, "email": "test@test.com"}, "created_at": "2021-07-11T07:43:06.842866Z", "body": "<p>#python</p><p>testing post</p>", "viewed": false, "viewed_by": 1, "total_viewed_by": []}]}''';
String jsonFormatter(String text) {
  // String str = text;
  // print(str.contains("["));
  // String comma = str.replaceAll(RegExp(r","), ",\n");

  // // String x = comma.replaceAll(RegExp(r"{"), "{\n    ");
  // // String y = x.replaceAll(RegExp(r"\["), "[\n    ");
  // // String z = y.replaceAll(RegExp(r"}"), "}");
  // // String a = z.replaceAll(RegExp(r"\]"), "]");
  // // String n = a.replaceAll(RegExp(r"\n"), "\n    ");

  return str;
}

String iterateDict(String str, int idxLevel) {
  if (str.isEmpty) {
    str = "{}";
  }

  return str;
}

String prettyJson(dynamic json) {
  var spaces = ' ' * 8;
  var encoder = JsonEncoder.withIndent(spaces);
  return encoder.convert(json);
}

void main(List<String> args) {
  // String x = jsonFormatter(str);
  String x = lelf_align(str);
  String y = right_align(x);
  String j = prettyJson(str);
  print(j);
}
