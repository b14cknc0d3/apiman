import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:websocket_tester/api_service/apiLoader.dart';
import 'package:websocket_tester/bloc_observer.dart';
import 'package:websocket_tester/generated/codegen_loader.g.dart';

import 'package:websocket_tester/ui/screens/api/apiPage.dart';
import 'package:websocket_tester/ui/screens/api/form_bloc/cubit/apimanform_cubit.dart';
import 'package:websocket_tester/ui/screens/api/settings/cubit/cubit/lang_cubit.dart';
import 'package:websocket_tester/ui/screens/api/settings/settings.dart';
import 'package:websocket_tester/ui/screens/websocket/cubit/wsformcubit_cubit.dart';
import 'package:websocket_tester/ui/screens/websocket/wsPage.dart';
import 'package:websocket_tester/utils/themes.dart';
import 'package:websocket_tester/widgets/splash.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart' show databaseFactory;

import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart' hide Row;
import 'package:sqlite3_library_windows/sqlite3_library_windows.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:websocket_tester/ws_service/web_socket_provider.dart';

import 'package:websocket_tester/ws_service/ws_api_loader.dart';

// late final Database db;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  if ((defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux) &&
      !kIsWeb) {
    // Initialize FFI
    if (defaultTargetPlatform == TargetPlatform.linux) {
      // sqfliteFfiInit();
    } else if (defaultTargetPlatform == TargetPlatform.windows) {
      open.overrideFor(OperatingSystem.windows, openSQLiteOnWindows);
      final db = sqlite3.openInMemory();
      db.dispose();
    }

    // Change the default factory
    databaseFactory = databaseFactoryFfi;
  }

  runApp(EasyLocalization(
      fallbackLocale: Locale('en', 'US'),
      supportedLocales: [Locale('en', 'US'), Locale('my', "MM")],
      path: 'resources/langs',
      assetLoader: CodegenLoader(),
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ApiLoader apiLoader = ApiLoader();
 
    const title = 'ApiMan';
    return FutureBuilder(
        future: Future.delayed(Duration(milliseconds: 300)),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              debugShowCheckedModeBanner: false,
              home: Splash(),
              title: title.tr(),
            );
          } else {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => LangCubit(),
                ),
                BlocProvider(
                    create: (context) => ApimanformCubit(apiLoader: apiLoader)),
                BlocProvider(
                    create: (context) =>
                        WsformcubitCubit()),
              ],
              child: BlocBuilder<LangCubit, LangState>(
                buildWhen: (previousState, currentState) =>
                    previousState != currentState,
                builder: (context, state) {
                  if (state is LangChanging) {
                    return Container(
                      color: Colors.white,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } // print(state.locale);
                  return ThemeProvider(
                    themes: [
                      AppTheme(
                        id: "theme_green",
                        description: "Green Theme",
                        data: ThemeData(
                          buttonTheme: ButtonThemeData(
                            highlightColor: Theme.of(context).primaryColor,
                          ),
                          primarySwatch: Colors.green,
                          primaryColor: Color(0xFF33691e),
                          primaryColorLight: Color(0xff629749),
                          primaryColorDark: Color(0xff003d00),
                          snackBarTheme: SnackBarThemeData(
                            contentTextStyle: TextStyle(color: Colors.white),
                            backgroundColor: Color(0xFF33691e),
                          ),
                        ),
                      ),
                      AppTheme.light(),
                      AppTheme.dark(),
                      AppTheme.purple(),
                      yellowTheme,
                      deepPurpleTheme,
                      brownTheme,
                      tealTheme,
                      cyanTheme,
                      redTheme,
                    ],
                    child: ThemeConsumer(
                      child: Builder(
                        builder: (themeContext) => MaterialApp(
                          localizationsDelegates: context.localizationDelegates,
                          supportedLocales: context.supportedLocales,
                          locale: context.locale,
                          debugShowCheckedModeBanner: false,
                          title: title.tr(),
                          home: MyHomePage(
                            title: title,
                          ),
                          theme: ThemeProvider.themeOf(themeContext).data,
                          // color: Color(0xff33691e),
                        ),
                      ),
                    ),
                  );
                },
              ),
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
  // late final AudioCache _audioCache;
  // List messages = [];
  // final TextEditingController _controller = TextEditingController();

  // final TextEditingController _pathController = TextEditingController();
  // final TextEditingController _headerController = TextEditingController();
  // // final PageController _pageController = PageController();
  var _selectedIndex = 0;
  // final WsAPiLoader wsAPiLoader = WsAPiLoader();
  // IOWebSocketChannel? _channel;
  var headers;
  bool isConnected = false;
  String error = "";
  @override
  void initState() {
    // _audioCache = AudioCache(
    //   prefix: 'audio/',
    //   fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP),
    // );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(
              widget.title.tr(),
              style: GoogleFonts.righteous(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: IndexedStack(
            // controller: _pageController,
            children: [
              WsPage(),
              // _webSocketPage(),
              ApiPage(),
              SettingsScreen(),
            ],
            index: _selectedIndex,
          ),
          bottomNavigationBar: _bottomNavigationBar(),
        );
      },
    );
    // border:InputBorder.,
  }

  // void _sendMessage() {
  //   if (_controller.text.isNotEmpty) {
  //     _channel?.sink.add(_controller.text);
  //   }
  // }

  // @override
  // void dispose() {
  //   _channel?.sink.close();
  //   super.dispose();
  // }

  // Widget _messaageView(AsyncSnapshot<Object?> snapshot) {
  //   var data = "${snapshot.data}";
  //   var message = json.decode(data);
  //   messages.add(message);
  //   print("-----message------list");
  //   print(messages);
  //   return Expanded(
  //     child: ListView.builder(
  //       itemCount: messages.length,
  //       itemBuilder: (ctx, idx) {
  //         return Padding(
  //             padding: EdgeInsets.all(2.0),
  //             child: Row(
  //               mainAxisAlignment: messages[idx]["id"] == "1"
  //                   ? MainAxisAlignment.end
  //                   : MainAxisAlignment.start,
  //               children: [
  //                 Text(messages[idx]["message"]),
  //               ],
  //             ));
  //       },
  //     ),
  //   );
  // }

  // _webSocketPage() {
  //   return Padding(
  //     padding: const EdgeInsets.all(20.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Expanded(
  //               child: Container(
  //                 child: Padding(
  //                   padding: EdgeInsets.only(
  //                       left: 15.0, right: 15.0, top: 5, bottom: 5),
  //                   child: Form(
  //                       child: TextFormField(
  //                     controller: _pathController,
  //                     decoration: InputDecoration(
  //                         border: OutlineInputBorder(
  //                           borderRadius:
  //                               BorderRadius.all(Radius.circular(4.0)),
  //                         ),
  //                         labelText: 'enter_path'.tr()),
  //                   )),
  //                 ),
  //               ),
  //             ),
  //             !isConnected
  //                 ? SizedBox(
  //                     width: 70,
  //                     child: ElevatedButton(
  //                       style: ButtonStyle(backgroundColor:
  //                           MaterialStateProperty.resolveWith<Color>(
  //                               (Set<MaterialState> states) {
  //                         if (states.contains(MaterialState.pressed))
  //                           return Theme.of(context)
  //                               .primaryColor
  //                               .withOpacity(1);
  //                         else if (states.contains(MaterialState.disabled))
  //                           return Colors.black26;
  //                         return Theme.of(context).primaryColor; //
  //                       })),
  //                       onPressed: () {
  //                         setState(() {
  //                           _channel =
  //                               wsAPiLoader.getConnect(_pathController.text);
  //                           isConnected = true;
  //                         });
  //                       },
  //                       child: Text(LocaleKeys.connect).tr(),
  //                     ),
  //                   )
  //                 : SizedBox(
  //                     width: 70,
  //                     child: ElevatedButton(
  //                       style: ButtonStyle(backgroundColor:
  //                           MaterialStateProperty.resolveWith<Color>(
  //                               (Set<MaterialState> states) {
  //                         if (states.contains(MaterialState.pressed))
  //                           return Theme.of(context)
  //                               .primaryColor
  //                               .withOpacity(1);
  //                         else if (states.contains(MaterialState.disabled))
  //                           return Colors.black26;
  //                         return Theme.of(context).primaryColor; //
  //                       })),
  //                       onPressed: () {
  //                         setState(() {
  //                           _channel?.sink.close();
  //                           isConnected = false;
  //                         });
  //                       },
  //                       child: Text(
  //                         "",
  //                         // LocaleKeys.cancle,
  //                         softWrap: true,
  //                       ),
  //                     ),
  //                   ),
  //           ],
  //         ),
  //         Row(
  //           children: [
  //             Expanded(
  //               child: Container(
  //                 child: Padding(
  //                   padding: EdgeInsets.only(
  //                       left: 15.0, right: 15.0, top: 5, bottom: 5),
  //                   child: Form(
  //                       child: TextFormField(
  //                     controller: _headerController,
  //                     onChanged: (value) {
  //                       setState(() {
  //                         headers = _headerController.text;
  //                       });
  //                     },
  //                     decoration: InputDecoration(
  //                       labelText: 'headers',
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.all(Radius.circular(4.0)),
  //                       ),
  //                     ),
  //                   )),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(
  //               width: 70,
  //             )
  //           ],
  //         ),
  //         Row(
  //           children: [
  //             Expanded(
  //               child: Container(
  //                 // color: Colors.,
  //                 child: Padding(
  //                   padding: EdgeInsets.only(
  //                       left: 15.0, right: 15.0, top: 5, bottom: 5),
  //                   child: Form(
  //                     child: TextFormField(
  //                       controller: _controller,
  //                       decoration: InputDecoration(
  //                           border: OutlineInputBorder(
  //                             borderRadius:
  //                                 BorderRadius.all(Radius.circular(4.0)),
  //                           ),
  //                           labelText: "send_message_ws".tr()),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(
  //               width: 70,
  //               child: ElevatedButton(
  //                 style: ButtonStyle(backgroundColor:
  //                     MaterialStateProperty.resolveWith<Color>(
  //                         (Set<MaterialState> states) {
  //                   if (states.contains(MaterialState.pressed))
  //                     return Theme.of(context).primaryColor.withOpacity(1);
  //                   else if (states.contains(MaterialState.disabled))
  //                     return Colors.black26;
  //                   return Theme.of(context).primaryColor; //
  //                 })),
  //                 onPressed: () {
  //                   _sendMessage();
  //                 },
  //                 child: Text(LocaleKeys.send).tr(),
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 24),
  //         _channel != null
  //             ? StreamBuilder(
  //                 // initialData: '{"message": "welcome", "id": "1"}',
  //                 stream: _channel?.stream,
  //                 builder: (context, snapshot) {
  //                   print(snapshot.connectionState);
  //                   if (snapshot.hasData) {
  //                     return _messaageView(snapshot);
  //                   } else if (snapshot.connectionState ==
  //                       ConnectionState.none) {
  //                     return Center(child: Text("${snapshot.error}"));
  //                   } else if (snapshot.connectionState ==
  //                       ConnectionState.done) {
  //                     // _channel?.stream.listen((event) {}, onError: (e) {
  //                     //   setState(() {
  //                     //     error = "$e";
  //                     //   });
  //                     // });
  //                     return Center(child: Text("$error"));
  //                   }
  //                   return Center(
  //                     child: CircularProgressIndicator(),
  //                   );
  //                 },
  //               )
  //             : Center(child: Text(LocaleKeys.connect_to_socket).tr()),
  //       ],
  //     ),
  //   );
  // }

  Widget _bottomNavigationBar() {
    bool bap = true;
    return bap == true
        ? BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.web), label: 'websocket'),
              BottomNavigationBarItem(icon: Icon(Icons.public), label: 'api'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'settings'.tr()),
            ],
            onTap: _onTappedBar,
            selectedItemColor: Theme.of(context).primaryColorLight,
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
                        // _audioCache.play('my_audio.mp3');
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
                        // _audioCache.play('my_audio.mp3');
                        _onTappedBar(1);
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.settings,
                        size: 40,
                        color: Theme.of(context).primaryColorLight,
                      ),
                      onPressed: () {
                        // _audioCache.play('my_audio.mp3');
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
