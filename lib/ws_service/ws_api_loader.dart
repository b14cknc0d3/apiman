import 'dart:async';

import 'package:web_socket_channel/io.dart';
import 'package:websocket_tester/ws_service/web_socket_provider.dart';

class WsAPiLoader {
  static late String token;
  // ignore: non_constant_identifier_names
  WebSocketProvider webSocketProvider = WebSocketProvider();

  // WsAPiLoader(this.webSocketProvider);

  getConnect(String path, headers) {
    final channel = webSocketProvider.connectSocket(path, headers);
    // webSocketProvider.logSocket(channel);
    return channel;
  }
}

void main(List<String> args) async {
  // String path = "wss://dummy-apiman.herokuapp.com/ws/dummy/";
  String path = "ws://127.0.0.1:8080/ws/dummy/";
  StreamSubscription ss;
  final WsAPiLoader wsAPiLoader = WsAPiLoader();
  final IOWebSocketChannel _channel = wsAPiLoader.getConnect(path, null);

  _channel.sink.add('{"command":"send_message","id":4,"message":"testing"}');

  // _channel.toString();
  ss = _channel.stream.listen((event) {
    // print(event);
  }, onDone: () {
    _channel.sink.close();
    //  final IOWebSocketChannel _channel = wsAPiLoader.getConnect(path);
  }, onError: (e) {
    print("----error-----");
    print(e);
    print("----error-----");
  }, cancelOnError: true);
  // ss.pause();
  print("pausing.....");

  Future.delayed(Duration(milliseconds: 10), () {
    print("resuming......");

    ss.resume();
    ss.onData((data) {
      print(data);
    });
    ss.onError((e) {
      ss.cancel();
    });
  });
  // int i = 0;
  // do {
  //   _channel.sink
  //       .add('{"command":"send_message","id":$i,"message":"testing$i.."}');
  // } while (i < 10000000);
  for (int i = 0; i < 100; i++) {
    _channel.sink
        .add('{"command":"send_message","id":$i,"message":"testing$i.."}');
  }
  Future.delayed(Duration(minutes: 1), () {
    print("closing socket");
    _channel.sink.close();
  });
  // var log = wsAPiLoader.logSocket();
}
