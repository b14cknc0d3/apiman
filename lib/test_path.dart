// import 'dart:ffi';
// import 'dart:io;
import 'dart:io';

void main(List<String> args) {
  final scriptDir = File(Platform.script.toFilePath()).parent;
  print(scriptDir.path);
}
