import 'dart:async';

import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:web_socket_channel/io.dart';

import 'package:websocket_tester/ui/screens/websocket/cubit/wsformcubit_cubit.dart';
import 'package:sizer/sizer.dart';
import 'package:websocket_tester/ws_service/web_socket_provider.dart';

class WsPageData extends StatefulWidget {
  final Map<String, dynamic> row;
  const WsPageData({
    Key? key,
    required this.row,
  }) : super(key: key);

  @override
  _WsPageDataState createState() => _WsPageDataState();
}

class _WsPageDataState extends State<WsPageData> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _headersController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final WebSocketProvider _webSocketProvider = WebSocketProvider();
  ScrollController _scrollController = ScrollController();
  StreamSubscription? ss;
  IOWebSocketChannel? _channel;
  bool isConnected = false;
  bool snapshotHasData = false;
  String websocketError = "";
  List result = [];
  List command = [];

  @override
  void initState() {
    // if (_channel != null) {
    //   isConnected = !isConnected;
    // }
    super.initState();
  }

  var logger = Logger(
    printer: PrettyPrinter(
        methodCount: 2, // number of method calls to be displayed
        errorMethodCount: 8, // number of method calls if stacktrace is provided
        lineLength: 120, // width of the output
        colors: true, // Colorful log messages
        printEmojis: true, // Print an emoji for each log message
        printTime: false // Should each log print contain a timestamp
        ),
  );

  @override
  void dispose() {
    ss!.cancel();
    _channel!.sink.close();
    _urlController.dispose();
    _headersController.dispose();
    _bodyController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WsformcubitCubit, WsformcubitState>(
      listener: (context, state) {
        if (state.status.isSubmissionInProgress) {
          // setState(() {
          //   result = state.result;
          // });
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                // backgroundColor:const Theme.of(context).primaryColor,
                content: Row(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0),
                        child: SizedBox(
                          height: 12,
                          width: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                          ),
                        )
                        //  Icon(
                        //   Icons.sync_rounded,
                        //   color: Colors.white,
                        // ),
                        ),
                    Text('submitting'.tr(), style: TextStyle()),
                  ],
                ),
              ),
            );
        } else if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Icon(
                        Icons.cancel,
                        color: Colors.white,
                      ),
                    ),
                    Text('submission_fail'.tr(), style: TextStyle()),
                  ],
                ),
              ),
            );
        } else if (state.status.isSubmissionSuccess) {
          // setState(() {
          //   _channel = state.result;
          // });
          // print(state.result);
          // ScaffoldMessenger.of(context)
          //   ..hideCurrentSnackBar()
          //   ..showSnackBar(
          //     SnackBar(
          //       content: Row(
          //         children: [
          //           Padding(
          //             padding: EdgeInsets.only(left: 8.0, right: 8.0),
          //             child: Icon(
          //               Icons.check_circle,
          //               color: Colors.white,
          //             ),
          //           ),
          //           Text('submission_success'.tr(), style: TextStyle()),
          //         ],
          //       ),
          //     ),
          //   );
        }
      },
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Divider(),
            _buildUrlRow(),
            Divider(),

            ///[header_row]
            ///
            _buildHeaderRow(),
            Divider(),

            ///[data_row]
            ///
            ///
            _buildBodyRow(),

            Divider(),

            ///[status_bar]
            _buildStatusBar(),
            Divider(),

            ///[stream_data_view]
            ///
            _buildStreamBody()
          ],
        ),
      ),
    );
  }

  _buildUrlRow() {
    return BlocBuilder<WsformcubitCubit, WsformcubitState>(
        builder: (context, state) {
      return Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  // maxLines: null,
                  controller: _urlController,
                  onChanged: (value) {
                    context.read<WsformcubitCubit>().urlChanged(value);
                  },
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: "enter_path".tr(),
                  ),
                )),
          ),

          ///[connect button]
          Padding(
            padding: EdgeInsets.all(8.0),
            child: !isConnected
                ? SizedBox(
                    ///[show connect]
                    width: 15.w,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return Theme.of(context)
                                .primaryColor
                                .withOpacity(1);
                          else if (states.contains(MaterialState.disabled))
                            return Colors.black26;
                          return Theme.of(context).primaryColor; //
                        }),
                      ),
                      onPressed: state.status.isValidated
                          ? () {
                              ///[isValidated] onPress not null;
                              // context.read<WsformcubitCubit>().connectSocket();
                              String url = state.url.value;
                              String headers = state.header.value;
                              // print("url --- $url");
                              // print("headers --- $headers");

                              final Future futureChannel = _webSocketProvider
                                  .connectSocket(url, headers);
                              futureChannel.then((future) {
                                setState(() {
                                  _channel = future;
                                  isConnected = true;
                                  _channel!.stream.listen((data) {
                                    setState(() {
                                      result.add(data.toString());
                                      logger.i("isConnected");
                                    });

                                    logger.i(result);
                                  }, onError: (e) {
                                    _channel = null;
                                    isConnected = false;
                                    websocketError = e.toString();
                                  }, cancelOnError: true);
                                });
                              }).catchError((error) {
                                setState(() {
                                  _channel = null;
                                  isConnected = false;
                                  websocketError = error.toString();
                                });
                                logger.wtf(websocketError);
                              });

                              ///add [channel.data] to [result]
                            }
                          : null,
                      child: Text("connect".tr()),
                    ),
                  )
                : SizedBox(
                    width: 15.w,
                    child: ElevatedButton(
                      style: ButtonStyle(backgroundColor:
                          MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Theme.of(context)
                              .backgroundColor
                              .withOpacity(1);
                        else if (states.contains(MaterialState.disabled))
                          return Colors.black26;
                        return Theme.of(context).primaryColor; //
                      })),
                      onPressed: () {
                        setState(() {
                          isConnected = !isConnected;
                          _channel?.sink.close();
                        });
                      },
                      child: Text(
                        "cancle".tr(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
          ),
        ],
      );
    });
  }

  _buildHeaderRow() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Form(
              child: TextFormField(
                controller: _headersController,
                maxLines: null,
                onChanged: (value) {
                  context.read<WsformcubitCubit>().headerChanged(value);
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4.0))),
                    labelText: "header".tr()),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(
            width: 15.w,
          ),
        ),
      ],
    );
  }

  _buildBodyRow() {
    return BlocBuilder<WsformcubitCubit, WsformcubitState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Form(
                  child: TextFormField(
                    controller: _bodyController,
                    maxLines: 3,
                    onChanged: (value) {
                      context.read<WsformcubitCubit>().bodyChanged(value);
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4.0))),
                      labelText: "body".tr(),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                width: 15.w,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Theme.of(context).primaryColor.withOpacity(1);
                      else if (states.contains(MaterialState.disabled))
                        return Colors.black26;
                      return Theme.of(context).primaryColor; //
                    }),
                  ),
                  onPressed: !state.status.isValidated
                      ? null
                      : isConnected == false
                          ? null
                          : () {
                              print(
                                  (!state.status.isValidated && !isConnected));
                              String body = state.body.value;
                              command.add(body);
                              logger.i(command);
                              // _channel!.then(());
                              try {
                                _channel!.sink.add(body);
                              } catch (e) {
                                print(e);
                              }
                            },
                  child: Text("send".tr()),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _buildStreamBody() {
    return BlocBuilder<WsformcubitCubit, WsformcubitState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(left: 1.w, right: 1.w, top: 1.w),
          child: SizedBox(
            height: 35.h,
            width: 100.w,
            child: Scrollbar(
              controller: _scrollController,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0), // if you need this
                  side: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: result.length,
                    itemBuilder: (ctx, idx) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Divider(),

                          ///sometime there will be [no command ]but incomming
                          ///[check index]
                          ///
                          command.asMap().containsKey(idx)
                              ? Container(
                                  height: 24,
                                  color: Colors.white,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 1.w, right: 1.w),
                                          child: Icon(
                                            Icons.arrow_circle_up,
                                            color: Colors.red[400],
                                          ),
                                        ),
                                        SelectableText("${command[idx]}"),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                          // ListTile(
                          //   leading: Icon(Icons.arrow_circle_up),
                          //   title:
                          //       SelectableText("${command[idx]}"),
                          // ),
                          Divider(),
                          result.asMap().containsKey(idx)
                              ? Container(
                                  color: Colors.yellow[100],
                                  height: 24,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      // crossAxisAlignment: CrossA,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 1.w, right: 1.w),
                                          child: Icon(
                                            Icons.arrow_circle_down,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        SelectableText("${result[idx]}"),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),

                          // ListTile(
                          //   leading: Icon(Icons.arrow_circle_down),
                          //   title: SelectableText("${result[idx]}"),
                          // ),
                        ],
                      );
                    }),
              ),
            ),
          ),
        );
        // print(_channel?.stream);

        // if (_channel != null) {
        //   // context.read<WsformcubitCubit>().socketConnected();
        //   return StreamBuilder(
        //       stream: _channel?.stream,
        //       builder: (context, snapshot) {
        //         if (snapshot.hasData) {
        //           var data = json.decode("${snapshot.data}");
        //           result.add(data);
        //           print("---result---");
        //           print(
        //               "$result \n ${result.length} \n $command \n ${command.length}");
        //           // return Text("$data");
        //           print("---result---");
        //           return
        //         } else if (snapshot.connectionState ==
        //             ConnectionState.waiting) {}
        //         return Container(
        //           child: Text("null snapshot"),
        //         );
        //       });
        // }
      },
    );
  }

  _buildStatusBar() {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 1.w),
              child: ElevatedButton.icon(
                onPressed: null,
                icon: Icon(Icons.circle,
                    size: 12,
                    color: isConnected ? Theme.of(context).primaryColor : null),
                label: isConnected
                    ? Text("connected",
                        style: TextStyle(color: Theme.of(context).primaryColor))
                    : Text("connect"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
