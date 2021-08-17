// import 'dart:ffi';
// import 'dart:io;
import 'dart:io';

void main(List<String> args) {
  List<Map<String, dynamic>> result = [];
  for (int i = 0; i < 100; i++) {
    Map<String, dynamic> map = {"out": i};
    Map<String, dynamic> inC = {"in": i};
    result.add(map);
    result.add(inC);
  }
  print(5 % 1);
  print(result[1].containsKey("in"));

  // final scriptDir = File(Platform.script.toFilePath()).parent;
  // bool t = true;
  // bool f = false;
  // print(scriptDir.path);
  // print(f & t);
  // print(t && t);
}
