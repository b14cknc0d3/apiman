// import 'dart:ffi';
// import 'dart:io;
import 'dart:io';

void main(List<String> args) {
  final scriptDir = File(Platform.script.toFilePath()).parent;
  bool t = true;
  bool f = false;
  print(scriptDir.path);
  print(f & t);
  print(t && t);
}
