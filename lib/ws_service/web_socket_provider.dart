import 'dart:io';

import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketProvider {
  // String url = "ws://127.0.0.1:8080";

  Future<IOWebSocketChannel> connectSocket(String path, headers) async {
    Map<String, dynamic> defaultHeaders = {};
    if (headers != null) {
      defaultHeaders.updateAll((key, value) => headers);
    }
    // final token =
    //     "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjI3ODQwMzUwLCJqdGkiOiIzZTlkYzc5OWQwYTc0OGVmYTI1OWM5NGExNzc0YjRkZCIsInVzZXJfaWQiOjF9.onMU3FwxanzHpNHclelaetzFHqEgv5Sv2bsyum5QgEM";
    try {
      final uri = Uri.parse(path);
      final channel = IOWebSocketChannel.connect(uri, headers: defaultHeaders
          // headers: {"Authorization": "Token $token"}
          );
      print("connecting to channel");
      return channel;
    } on WebSocketException catch (e) {
      print(e);
      throw WebSocketException();
    } catch (e) {
      throw Exception();
    }
  }

  sendData(IOWebSocketChannel channel, String data) {
    channel.sink.add(data);
  }

  socketStream(IOWebSocketChannel channel) {
    return channel.stream;
  }

  closeSocket(IOWebSocketChannel channel) {
    channel.sink.close();
  }

  logSocket(IOWebSocketChannel channel) {
    channel.stream.listen((event) {
      print("event");
      print(event);
    }, onError: (e) {
      print(e);
    }, onDone: () {
      print('done');
    });
  }
}
