import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:websocket_tester/api_service/apiLoader.dart';
import 'package:websocket_tester/database/database.dart';
// import 'package:websocket_tester/ui/screens/api/form_bloc/bloc/apimanform_bloc.dart';
import 'package:websocket_tester/ui/screens/api/form_bloc/cubit/apimanform_cubit.dart';
import 'package:websocket_tester/utils/highlight.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:websocket_tester/widgets/dialogButton.dart';
import 'package:formz/formz.dart';
import 'package:easy_localization/easy_localization.dart';

class ApiPagedata extends StatefulWidget {
  // final String pageNum;

  final Map row;
  const ApiPagedata({Key? key, required this.row}) : super(key: key);

  @override
  _ApiPagedataState createState() => _ApiPagedataState();
}

class _ApiPagedataState extends State<ApiPagedata>
    with AutomaticKeepAliveClientMixin<ApiPagedata> {
  final TextEditingController _pathController1 = TextEditingController();
  final TextEditingController _headerController1 = TextEditingController();
  final TextEditingController _dataController1 = TextEditingController();

  int? pageIdx;
  final dbHelper = DatabaseHelper.instance;
  final ApiLoader apiLoader = ApiLoader();
  String? ddbValue = "get";
  bool isConnected = false;
  dynamic? result;
  Map<String, String> header = {};
  String? url;
  var data;
  var hMap;
  var lang;
  bool error = false;
  bool renderHtml = false;
  bool saved = false;

  @override
  void initState() {
    setState(() {
      _pathController1.text =
          widget.row.isNotEmpty ? widget.row["url"] : "http";
      _headerController1.text =
          widget.row.isNotEmpty ? widget.row["headers"] : "{}";
      _dataController1.text = widget.row.isNotEmpty ? widget.row["body"] : "{}";

      if (widget.row.isNotEmpty) {
        ddbValue = widget.row["method"];
        result = json.decode(widget.row["result"]);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (result != null) {
      error = result.containsKey("error");
    }
    if (error) {
      lang = 'html';
    } else {
      lang = "json";
    }

    return BlocListener<ApimanformCubit, ApimanformState>(
      listener: (context, state) {
        if (state.status.isSubmissionInProgress) {
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
          setState(() {
            result = state.result;
          });
          // print(state.result);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.white,
                      ),
                    ),
                    Text('submission_success'.tr(), style: TextStyle()),
                  ],
                ),
              ),
            );
        }
      },
      child: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Divider(),
                _buildUrlRow(),
                Divider(),
                _headerBox(),
                Divider(),
                _dataBox(),
                Divider(),
                _buildStatusBar(),
                _outPutBox()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerBox() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 8, right: 8.0, top: 8, bottom: 8),
            child: Form(
              child: TextFormField(
                maxLines: 3,
                // initialValue: "{}",
                onChanged: (value) {
                  context.read<ApimanformCubit>().headerChanged(value);
                },
                controller: _headerController1,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    // border: OutlineInputBorder(
                    //   borderRadius:
                    //       BorderRadius.all(Radius.circular(4.0)),
                    // ),
                    labelText: 'header'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dataBox() {
    return BlocBuilder<ApimanformCubit, ApimanformState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: Padding(
                padding:
                    EdgeInsets.only(left: 8, right: 8.0, top: 8, bottom: 8),
                child: Form(
                  child: TextFormField(
                    maxLines: 3,
                    // smartQuotesType: SmartQuotesType.enabled,
                    onChanged: (value) {
                      context.read<ApimanformCubit>().bodyChanged(value);
                    },
                    controller: _dataController1,

                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        // border: OutlineInputBorder(
                        //   borderRadius:
                        //       BorderRadius.all(Radius.circular(4.0)),
                        // ),
                        labelText: 'body'.tr()),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _buildUrlRow() {
    return BlocBuilder<ApimanformCubit, ApimanformState>(
        builder: (context, state) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: DropdownButton<String>(
              focusNode: FocusNode(),
              // style: TextStyle(backgroundColor: Theme.of(context).primaryColor),
              focusColor: Theme.of(context).primaryColor,
              // dropdownColor: Theme.of(context).primaryColor,
              iconEnabledColor: Theme.of(context).primaryColor,
              value: ddbValue,
              items: <String>["get", "post", "put", "patch", "head", "options"]
                  .map((String value) {
                return DropdownMenuItem(
                  child: Text(value),
                  value: value,
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  ddbValue = value;
                });
                context
                    .read<ApimanformCubit>()
                    .methodChanged(ddbValue ?? "get");
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  EdgeInsets.only(left: 30, right: 30.0, top: 8, bottom: 8),
              child: Form(
                  child: TextFormField(
                onChanged: (value) {
                  context.read<ApimanformCubit>().urlChanged(value);
                },
                controller: _pathController1,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    // border: OutlineInputBorder(
                    //   borderRadius:
                    //       BorderRadius.all(Radius.circular(4.0)),
                    // ),
                    labelText: 'enter_path'.tr()),
              )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: !state.status.isSubmissionInProgress
                ? SizedBox(
                    width: 70,
                    child: ElevatedButton(
                      style: ButtonStyle(backgroundColor:
                          MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Theme.of(context).primaryColor.withOpacity(1);
                        else if (states.contains(MaterialState.disabled))
                          return Colors.black26;
                        return Theme.of(context).primaryColor; //
                      })),
                      onPressed: state.status.isValidated
                          ? () {
                              context.read<ApimanformCubit>().formSummits();
                            }
                          : null,
                      child: Text(
                        "connect".tr(),
                        style: TextStyle(),
                      ),
                    ),
                  )
                : SizedBox(
                    width: 70,
                    child: ElevatedButton(
                      style: ButtonStyle(backgroundColor:
                          MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Theme.of(context).primaryColor.withOpacity(1);
                        else if (states.contains(MaterialState.disabled))
                          return Colors.black26;
                        return Theme.of(context).primaryColor; //
                      })),
                      onPressed: () {
                        setState(() {
                          isConnected = true;
                        });
                      },
                      child: SizedBox(
                        height: 13,
                        width: 13,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.0, backgroundColor: Colors.white),
                      ),
                    ),
                  ),
          ),
        ],
      );
    });
  }

  _outPutBox() {
    if (result == null) {
      return Container(
        child: Center(
          child: Text("connect".tr()),
        ),
      );
    } else {
      return !renderHtml
          ? Expanded(
              child: SizedBox(
                height: 500,
                width: double.infinity,
                child: Card(
                  color: Colors.white70,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(4.0), // if you need this
                    side: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: HighlightView(
                    !error
                        ? getPrettyJSONString(result["body"])
                        : result["error"],
                    language: lang,
                    theme: githubTheme,
                    padding: EdgeInsets.all(12),
                    textStyle: TextStyle(
                      fontFamily: 'Consolas',
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            )
          : _buildHtmlRenderer(result);
    }
  }

  @override
  void dispose() {
    _pathController1.dispose();

    _dataController1.dispose();

    _headerController1.dispose();

    super.dispose();
  }

  // _buildFab() {
  //   return FloatingActionButton(
  //     onPressed: () {},
  //     child: Icon(
  //       Icons.add,
  //     ),
  //     backgroundColor: Theme.of(context).primaryColor,
  //   );
  // }

  _buildHtmlRenderer(result) {
    var hdata = "";
    if (result["error"] != null) {
      hdata = result["error"];
    }
    return Expanded(
        child: SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0), // if you need this
            side: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          color: Colors.yellow[100],
          child: Html(
            data: hdata,
            style: {
              "table": Style(
                backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
              ),
              "tr": Style(
                border: Border(bottom: BorderSide(color: Colors.grey)),
              ),
              "th": Style(
                padding: EdgeInsets.all(6),
                backgroundColor: Colors.grey,
              ),
              "td": Style(
                padding: EdgeInsets.all(6),
                alignment: Alignment.topLeft,
              ),
              'h5': Style(maxLines: 2, textOverflow: TextOverflow.ellipsis),
            },
          ),
        ),
      ),
    ));
  }

//good
  _buildStatusBar() {
    var green = Colors.green;
    var red = Theme.of(context).errorColor;
    Color scolor = Colors.grey;

    if (result != null) {
      var s = result['status_code'];
      if (s == 200 || s == 201 || s == 204) {
        scolor = green;
      } else {
        scolor = red;
      }
    }
    return result != null
        ? Container(
            height: 24,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: TextButton.icon(
                      icon: Icon(
                        Icons.language,
                        color: scolor,
                      ),
                      label: Text(
                          "status".tr(args: [": ${result['status_code']}"]),
                          style: TextStyle(
                            color: scolor,
                          )),
                      onPressed: null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "content_length".tr(),
                      style: TextStyle(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      ": ${result["length"]}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    "headers: ",
                    style: TextStyle(),
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      // Future.delayed(Duration(seconds: 1));
                      showDialog<void>(
                        context: context,
                        builder: (_) => HeaderDialog(
                          headers: result["headers"],
                        ),
                      );
                    },
                    child: Text(
                      "${result["headers"].length}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 50),
                      child: ElevatedButton(
                        style: ButtonStyle(backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return Theme.of(context)
                                .primaryColor
                                .withOpacity(1);
                          else if (states.contains(MaterialState.disabled))
                            return Colors.black26;
                          return Theme.of(context).primaryColor; //
                        })),
                        onPressed: error
                            ? () {
                                // Future.delayed(Duration(seconds: 1));
                                setState(() {
                                  renderHtml = !renderHtml;
                                });
                              }
                            : null,
                        child: Text(
                          renderHtml ? "raw".tr() : "render".tr(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.save_rounded, color: Colors.white),
                        style: ButtonStyle(backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return Theme.of(context)
                                .primaryColor
                                .withOpacity(1);
                          else if (states.contains(MaterialState.disabled))
                            return Colors.black26;
                          return Theme.of(context).primaryColor; //
                        })),
                        onPressed: !error
                            ? () {
                                setState(() {
                                  _insertDb();
                                  saved = true;
                                });
                              }
                            : null,
                        label: Text(
                          saved ? "saved".tr() : "save".tr(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )),
                ],
              ),
            ),
          )
        : Container();
  }

  @override
  bool get wantKeepAlive => true;

  _insertDb() async {
    // print(widget.tabId);
    print(ddbValue);
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: widget.row.isNotEmpty ? widget.row["tabId"] : 1,
      DatabaseHelper.columnMethod: ddbValue,
      DatabaseHelper.columnUrl:
          _pathController1.text.isNotEmpty ? _pathController1.text : "",
      DatabaseHelper.columnHeaders:
          _headerController1.text.isNotEmpty ? _headerController1.text : "",
      DatabaseHelper.columnBody:
          _dataController1.text.isNotEmpty ? _dataController1.text : "",
      DatabaseHelper.columnResult: result != null ? json.encode(result) : "",
      DatabaseHelper.columnTabId:
          widget.row.isNotEmpty ? widget.row["tabId"] : 1
    };
    final id = await dbHelper.insert(row);
    print('inserted row id:$id');
  }

  _update() async {
    // print(_pathController1.text);
    // print(_headerController1.text);
    // print(_pathController1.text);

    Map<String, dynamic> row = {
      DatabaseHelper.columnId: widget.row["tabId"],
      DatabaseHelper.columnMethod: ddbValue,
      DatabaseHelper.columnUrl:
          _pathController1.text.isNotEmpty ? _pathController1.text : "",
      DatabaseHelper.columnHeaders:
          _headerController1.text.isNotEmpty ? _headerController1.text : "",
      DatabaseHelper.columnBody:
          _dataController1.text.isNotEmpty ? _dataController1.text : "",
      DatabaseHelper.columnResult: result != null ? json.encode(result) : "",
      DatabaseHelper.columnTabId:
          widget.row.isNotEmpty ? widget.row["tabId"] : 1
    };
    final rowUpdated = dbHelper.update(row);
    print("updated $rowUpdated row(s)");
  }

  ///end [Widget]
}

String getPrettyJSONString(jsonObject) {
  var encoder = new JsonEncoder.withIndent("     ");
  return encoder.convert(jsonObject);
}
