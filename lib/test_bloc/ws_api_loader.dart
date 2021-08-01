import 'dart:convert';
import 'dart:math';

import 'package:web_socket_channel/io.dart';
import 'package:websocket_tester/test_bloc/web_socket_provider.dart';

class WsAPiLoader {
  static late String token;
  // ignore: non_constant_identifier_names
  WebSocketProvider webSocketProvider = WebSocketProvider();

  // WsAPiLoader(this.webSocketProvider);

  getConnect(String path) {
    final channel = webSocketProvider.connectSocket(path);
    return channel;
  }
}

// void main(List<String> args) {
//   String error = "";
//   // String event = "";
//   WsAPiLoader aPiLoader = WsAPiLoader();
//   final IOWebSocketChannel channel = aPiLoader.getConnect("/ws/dummy/");
//   channel.sink
//       .add('{"command":"send_message","message": "welcome", "id": "1"}');
//   channel.stream.listen((event) {
//     _decodeData(event);
//     // print(event);
//   }, onError: (e) {
//     error = e;
//   }, onDone: () {
//     print("Done!");
//   });

//   // print(event);
//   print(error);
//   // channel.sink.close();
// }

// void _decodeData(String event) {
//   var d = json.decode(event);
//   print(d);
// }
