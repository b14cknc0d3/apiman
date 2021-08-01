import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:websocket_tester/test_bloc/ws_api_loader.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const title = 'ApiMan';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      home: MyHomePage(
        title: title,
      ),
      // theme: ThemeData.light(),
      color: Colors.green,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List messages = [];
  final TextEditingController _controller = TextEditingController();

  final TextEditingController _pathController = TextEditingController();
  final TextEditingController _headerController = TextEditingController();
  final PageController _pageController = PageController();
  var _selectedIndex = 0;
  final WsAPiLoader wsAPiLoader = WsAPiLoader();
  IOWebSocketChannel? _channel;
  String? headers;
  bool isConnected = false;
  String error = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          widget.title,
          style: GoogleFonts.righteous(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: [
          _webSocketPage(),
          ApiPageView(),
          SettingView(),
        ],
        onPageChanged: (page) {
          setState(() {
            _selectedIndex = page;
          });
        },
      ),
      bottomNavigationBar: _bottomNavigationBar(),
    );
    // border:InputBorder.,
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _channel?.sink.add(_controller.text);
    }
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }

  Widget _messaageView(AsyncSnapshot<Object?> snapshot) {
    var data = "${snapshot.data}";
    var message = json.decode(data);
    messages.add(message);
    print("-----message------list");
    print(messages);
    return Expanded(
      child: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (ctx, idx) {
          return Padding(
              padding: EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: messages[idx]["id"] == "1"
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  Text(messages[idx]["message"]),
                ],
              ));
        },
      ),
    );
  }

  _webSocketPage() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 5, bottom: 5),
                    child: Form(
                        child: TextFormField(
                      controller: _pathController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                          ),
                          labelText: 'enter path'),
                    )),
                  ),
                ),
              ),
              !isConnected
                  ? SizedBox(
                      width: 70,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _channel =
                                wsAPiLoader.getConnect(_pathController.text);
                            isConnected = true;
                          });
                        },
                        child: Text("Connect"),
                      ),
                    )
                  : SizedBox(
                      width: 70,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _channel?.sink.close();
                            isConnected = false;
                          });
                        },
                        child: Text(
                          "Cancle",
                          softWrap: true,
                        ),
                      ),
                    ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 5, bottom: 5),
                    child: Form(
                        child: TextFormField(
                      controller: _headerController,
                      onChanged: (value) {
                        setState(() {
                          headers = _headerController.text;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'headers',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        ),
                      ),
                    )),
                  ),
                ),
              ),
              SizedBox(
                width: 70,
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  // color: Colors.,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 5, bottom: 5),
                    child: Form(
                      child: TextFormField(
                        controller: _controller,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.0)),
                            ),
                            labelText: 'Send a message'),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 70,
                child: ElevatedButton(
                  onPressed: () {
                    _sendMessage();
                  },
                  child: Text("Send"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _channel != null
              ? StreamBuilder(
                  // initialData: '{"message": "welcome", "id": "1"}',
                  stream: _channel?.stream,
                  builder: (context, snapshot) {
                    print(snapshot.connectionState);
                    if (snapshot.hasData) {
                      return _messaageView(snapshot);
                    } else if (snapshot.connectionState ==
                        ConnectionState.none) {
                      return Center(child: Text("${snapshot.error}"));
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      // _channel?.stream.listen((event) {}, onError: (e) {
                      //   setState(() {
                      //     error = "$e";
                      //   });
                      // });
                      return Center(child: Text("$error"));
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                )
              : Center(child: Text("Connect to socket")),
        ],
      ),
    );
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.web_asset), label: 'websocket'),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'api'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'settings'),
      ],
      onTap: _onTappedBar,
      selectedItemColor: Colors.orange,
      currentIndex: _selectedIndex,
    );
  }

  void _onTappedBar(int value) {
    setState(() {
      _selectedIndex = value;
    });
    _pageController.jumpToPage(value);
  }
}

class ApiPageView extends StatelessWidget {
  const ApiPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SettingView extends StatelessWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
