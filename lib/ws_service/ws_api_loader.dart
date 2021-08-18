import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:apiman/ws_service/web_socket_provider.dart';

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

class LambdaWebsocket {
  static Random _r = new Random();
  static String _key =
      base64.encode(List<int>.generate(8, (index) => _r.nextInt(255)));
  HttpClient client = HttpClient();

  Future<WebSocket> wsGet(host, port, path) async {
    final HttpClientRequest request = await client.get(host, port, path);

    request.headers.add("Connection", "upgrade");
    request.headers.add("Upgrade", "websocket");
    request.headers.add("sec-websocket-version", "12");
    request.headers.add("sec-websocket-key", _key);
    HttpClientResponse response = await request.close();
    // ignore: close_sinks
    Socket socket = await response.detachSocket();
    // ignore: close_sinks
    WebSocket ws = WebSocket.fromUpgradedSocket(socket, serverSide: false);
    return ws;
  }
}

class WebSocketPro {
  static WebSocket? ws;

  Future<WebSocket> connect(String url, headers) async {
    // ignore: close_sinks
    try {
      // ignore: close_sinks
      print("connecting");
      final WebSocket webSocket =
          await WebSocket.connect(url, headers: headers).then((_) {
        print("connected");
        print(_.readyState);
        return _;
      });

      WebSocketPro.ws = webSocket;

      return webSocket;
    } on WebSocketException catch (e) {
      print(e);
      throw WebSocketException();
    } catch (e) {
      print(e);
      throw Exception();
    }
    // webSocket.pingInterval = Duration(milliseconds: 400);
  }
}

void main(List<String> args) async {
  // LambdaWebsocket lambdaWebsocket = LambdaWebsocket();
  WebSocketPro webSocketPro = WebSocketPro();
  final WebSocket channel =
      await webSocketPro.connect("ws://127.0.0.1:8080/ws/dummy/", null);

  switch (channel.readyState) {
    case WebSocket.connecting:
      print("readyState : CONNECTING");

      break;
    case WebSocket.open:
      print("readyState : OPEN");

      break;
    case WebSocket.closing:
      print("readyState : CLOSING");

      break;
    case WebSocket.closed:
      print("readyState : CLOSED");

      break;
    default:
      print("readyState : " + WebSocketPro.ws!.readyState.toString());
      break;
  }
  try {
    // print(WebSocketPro.ws!.length);
    WebSocketPro.ws!.add('{command":"send_message","id":4,"message":"gg"}');
    int state = WebSocketPro.ws!.readyState;
    channel.listen((event) {
      print(event);
    }, onDone: () {
      print("done");
    }, onError: (e) {
      print("error");
    }, cancelOnError: true);
    // print(channel.transform(StreamTransformer.fromBind((stream) => stream)));
    // final IOWebSocketChannel c = IOWebSocketChannel(channel);
    final StreamSubscription ss;
    // channel.transform(utf8.decoder).listen((event) {
    //   print(event);
    // });

    // c.stream.listen((event) {
    //   print(event.toString());
    // });
    // channel.sink.add('{"command":"send_message","id":4,"message":"wp"}');
    // channel.sink.close();
  } on WebSocketChannelException catch (e) {
    print(e);
    throw WebSocketChannelException();
  } catch (e) {
    print(e);
    throw Exception();
  }
  print(channel);
}

//   // ignore: close_sinks
//   final WebSocket socket =
//       await lambdaWebsocket.wsGet("127.0.0.1", 8080, "ws/dummy/");
//   print(socket);
//   socket.add('{"command":"send_message","id":4,"message":"testing123"}');
//   // socket.
// }
// void main(List<String> args) async {
//   // String path = "wss://dummy-apiman.herokuapp.com/ws/dummy/";
//   String path = "ws://127.0.0.1:8080/ws/dummy/";
//   StreamSubscription ss;
//   final WsAPiLoader wsAPiLoader = WsAPiLoader();
//   final IOWebSocketChannel _channel = wsAPiLoader.getConnect(path, null);

//   _channel.sink.add('{"command":"send_message","id":4,"message":"testing"}');

//   // _channel.toString();
//   ss = _channel.stream.listen((event) {
//     // print(event);
//   }, onDone: () {
//     _channel.sink.close();
//     //  final IOWebSocketChannel _channel = wsAPiLoader.getConnect(path);
//   }, onError: (e) {
//     print("----error-----");
//     print(e);
//     print("----error-----");
//   }, cancelOnError: true);
//   // ss.pause();
//   print("pausing.....");

//   Future.delayed(Duration(milliseconds: 10), () {
//     print("resuming......");

//     ss.resume();
//     ss.onData((data) {
//       print(data);
//     });
//     ss.onError((e) {
//       ss.cancel();
//     });
//   });
//   // int i = 0;
//   // do {
//   //   _channel.sink
//   //       .add('{"command":"send_message","id":$i,"message":"testing$i.."}');
//   // } while (i < 10000000);
//   for (int i = 0; i < 100; i++) {
//     _channel.sink
//         .add('{"command":"send_message","id":$i,"message":"testing$i.."}');
//   }
//   Future.delayed(Duration(minutes: 1), () {
//     print("closing socket");
//     _channel.sink.close();
//   });
//   // var log = wsAPiLoader.logSocket();
// }
