import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketProvider {
  String url = "ws://127.0.0.1:8080";

  connectSocket(String path) {
    final token =
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjI3ODQwMzUwLCJqdGkiOiIzZTlkYzc5OWQwYTc0OGVmYTI1OWM5NGExNzc0YjRkZCIsInVzZXJfaWQiOjF9.onMU3FwxanzHpNHclelaetzFHqEgv5Sv2bsyum5QgEM";
    final uri = Uri.parse(path);
    final channel = IOWebSocketChannel.connect(uri,
        headers: {"Authorization": "Token $token"});
    return channel;
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
// ignore: unused_element
// ignore: non_constant_identifier_names

}
