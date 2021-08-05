import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:websocket_tester/test_bloc/ws_api_loader.dart';
import 'package:websocket_tester/ui/screens/api/apiPage.dart';
import 'package:websocket_tester/ui/screens/api/settings/settings.dart';
import 'package:websocket_tester/widgets/splash.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const title = 'ApiMan';
    return FutureBuilder(
        future: Future.delayed(Duration(milliseconds: 300)),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              home: Splash(),
              title: title,
            );
          } else {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: title,
              home: MyHomePage(
                title: title,
              ),
              theme: ThemeData(
                  buttonTheme: ButtonThemeData(
                    highlightColor: Theme.of(context).primaryColor,
                  ),
                  primaryColor: Color(0xFF33691e),
                  primaryColorLight: Color(0xff629749),
                  primaryColorDark: Color(0xff003d00)),
              // color: Color(0xff33691e),
            );
          }
        });
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
  // final PageController _pageController = PageController();
  var _selectedIndex = 0;
  final WsAPiLoader wsAPiLoader = WsAPiLoader();
  IOWebSocketChannel? _channel;
  var headers;
  bool isConnected = false;
  String error = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF33691e),
        title: Text(
          widget.title,
          style: GoogleFonts.righteous(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: IndexedStack(
        // controller: _pageController,
        children: [
          _webSocketPage(),
          ApiPage(),
          SettingsScreen(),
        ],
        index: _selectedIndex,
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
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).primaryColor)),
                        onPressed: () {
                          setState(() {
                            _channel =
                                wsAPiLoader.getConnect(_pathController.text);
                            isConnected = true;
                          });
                        },
                        child: Text("connect"),
                      ),
                    )
                  : SizedBox(
                      width: 70,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).primaryColor)),
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
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor)),
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
    bool bap = true;
    return bap == true
        ? BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.web), label: 'websocket'),
              BottomNavigationBarItem(icon: Icon(Icons.public), label: 'api'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'settings'),
            ],
            onTap: _onTappedBar,
            selectedItemColor: Color(0xff629749),
            currentIndex: _selectedIndex,
          )
        : BottomAppBar(
            notchMargin: 2.0,
            shape: CircularNotchedRectangle(),
            child: Container(
              height: 75,
              child: Row(
                // mainAxisSize: MainAxisSize.min,
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.web,
                        size: 40,
                        color: Theme.of(context).primaryColorLight,
                      ),
                      onPressed: () {
                        _onTappedBar(0);
                      }),
                  // Spacer(),
                  IconButton(
                      icon: Icon(
                        Icons.public,
                        size: 40,
                        color: Theme.of(context).primaryColorLight,
                      ),
                      onPressed: () {
                        _onTappedBar(1);
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.settings,
                        size: 40,
                        color: Theme.of(context).primaryColorLight,
                      ),
                      onPressed: () {
                        _onTappedBar(2);
                      }),
                ],
              ),
            ),
          );
  }

  void _onTappedBar(int value) {
    setState(() {
      _selectedIndex = value;
    });
    // _pageController.jumpToPage(value);
  }
}

class SettingView extends StatelessWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
