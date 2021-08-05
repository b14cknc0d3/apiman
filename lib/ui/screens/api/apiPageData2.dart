import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:websocket_tester/api_service/apiLoader.dart';
import 'package:websocket_tester/database/database.dart';
import 'package:websocket_tester/utils/highlight.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:websocket_tester/widgets/dialogButton.dart';

class ApiPagedata2 extends StatefulWidget {
  // final String pageNum;
  const ApiPagedata2({Key? key}) : super(key: key);

  @override
  _ApiPagedata2State createState() => _ApiPagedata2State();
}

class _ApiPagedata2State extends State<ApiPagedata2>
    with AutomaticKeepAliveClientMixin<ApiPagedata2> {
  final TextEditingController _pathController1 =
      TextEditingController(text: "http");
  final TextEditingController _headerController1 =
      TextEditingController(text: "{}");
  final TextEditingController _dataController1 =
      TextEditingController(text: "{}");

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

    return Column(
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
                // initialValue: "{}",
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
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 8, right: 8.0, top: 8, bottom: 8),
            child: Form(
              child: TextFormField(
                // smartQuotesType: SmartQuotesType.enabled,
                // onChanged: (value) {
                //   setState(() {
                //     data = value;
                //   });
                // },
                controller: _dataController1,
                // initialValue: "{}",
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    // border: OutlineInputBorder(
                    //   borderRadius:
                    //       BorderRadius.all(Radius.circular(4.0)),
                    // ),
                    labelText: 'body'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildUrlRow() {
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
                print(ddbValue);
                ddbValue = value;
              });
            },
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 30, right: 30.0, top: 8, bottom: 8),
            child: Form(
                child: TextFormField(
              controller: _pathController1,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  // border: OutlineInputBorder(
                  //   borderRadius:
                  //       BorderRadius.all(Radius.circular(4.0)),
                  // ),
                  labelText: 'enter url'),
            )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: !isConnected
              ? SizedBox(
                  width: 70,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor)),
                    onPressed: () async {
                      setState(() {
                        url = _pathController1.text.trim();

                        hMap = _headerController1.text.trim();

                        data = _dataController1.text.trim();

                        isConnected = true;
                      });
                      var h = _jsonDecoder(hMap);
                      var d = _jsonDecoder(data);

                      switch (ddbValue) {
                        case "get":
                          final r = await apiLoader.get("$url", h);
                          setState(() {
                            result = r;
                          });

                          break;
                        case "post":
                          final r = await apiLoader.post("$url", d, h);
                          setState(() {
                            result = r;
                          });

                          break;
                        case "put":
                          final r = await apiLoader.put("$url", d, h);
                          setState(() {
                            result = r;
                          });

                          break;
                        case "patch":
                          final r = await apiLoader.patch("$url", d, h);
                          setState(() {
                            result = r;
                          });
                          break;
                        case "delete":
                          final r = await apiLoader.delete("$url", d, h);
                          setState(() {
                            result = r;
                          });

                          break;

                        case "head":
                          final r = await apiLoader.post("$url", d, h);
                          setState(() {
                            result = r;
                          });

                          break;
                        case "options":
                          final r = await apiLoader.post("$url", d, h);
                          setState(() {
                            result = r;
                          });

                          break;
                        default:
                          final r = await apiLoader.get("$url", h);
                          setState(() {
                            result = r;
                          });

                          break;
                      }
                    },
                    child: Text("connect"),
                  ),
                )
              : result != null
                  ? SizedBox(
                      width: 70,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).primaryColor)),
                        onPressed: () {
                          setState(() {
                            isConnected = false;
                          });
                        },
                        child: Text(
                          "Cancle",
                          softWrap: true,
                        ),
                      ),
                    )
                  : SizedBox(
                      width: 70,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).primaryColor)),
                        onPressed: null,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: CircularProgressIndicator(
                              backgroundColor: Colors.white),
                        ),
                      ),
                    ),
        ),
      ],
    );
  }

  _outPutBox() {
    print("[start:api_result]...........................");
    print(result);
    print("[end:api_result].............................");

    return result != null
        ? !renderHtml
            ? Expanded(
                child: SizedBox(
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
            : _buildHtmlRenderer()
        : Text("connect");
  }

  @override
  void dispose() {
    _pathController1.dispose();

    _dataController1.dispose();

    _headerController1.dispose();

    super.dispose();
  }

  _buildFab() {
    return FloatingActionButton(
      onPressed: () {},
      child: Icon(
        Icons.add,
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  _buildHtmlRenderer() {
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
                      label: Text("status: ${result['status_code']}",
                          style: TextStyle(
                            color: scolor,
                          )),
                      onPressed: null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "content_length: ",
                      style: TextStyle(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      " ${result["length"]}",
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
                      Future.delayed(Duration(seconds: 1));
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
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor),
                        ),
                        onPressed: error
                            ? () {
                                Future.delayed(Duration(seconds: 1));
                                setState(() {
                                  renderHtml = !renderHtml;
                                });
                              }
                            : null,
                        child: Text(
                          renderHtml ? "raw" : "render",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.save_rounded, color: Colors.white),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor),
                        ),
                        onPressed: !error
                            ? () {
                                setState(() {
                                  saved = true;
                                });
                              }
                            : null,
                        label: Text(
                          saved ? "saved" : "save",
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

  _jsonDecoder(data) {
    var decodeSucceeded = false;
    try {
      var decodedJSON = json.decode(data) as Map<String, dynamic>;
      decodeSucceeded = true;
      return decodedJSON;
      // ignore: unused_catch_clause
    } on FormatException catch (e) {
      print('The provided string is not valid JSON');
    }
    print('Decoding succeeded: $decodeSucceeded');
  }
}

String getPrettyJSONString(jsonObject) {
  var encoder = new JsonEncoder.withIndent("     ");
  return encoder.convert(jsonObject);
}
