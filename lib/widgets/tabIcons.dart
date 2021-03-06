import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:apiman/ui/screens/api/apiPageData.dart';

class TabIcon extends StatelessWidget {
  final Function(Map) callback;
  final Map<String, ApiPagedata> tabs;
  final int idx;
  const TabIcon({
    Key? key,
    required this.callback,
    required this.tabs,
    required this.idx,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("api [$idx]"),
        IconButton(
          splashRadius: 30,
          splashColor: Theme.of(context).primaryColorLight,
          color: Theme.of(context).primaryColor,
          // style: ButtonStyle(
          //   backgroundColor:
          //       MaterialStateProperty.all(Theme.of(context).primaryColor),
          // ),
          onPressed: () {
            print("idx to delete:$idx");
            String key = tabs.keys.elementAt(idx);
            tabs.remove(key);
            print(tabs);
            callback(tabs);
          },
          icon: Icon(
            Icons.cancel_rounded,
            size: 20,
            color: Colors.white,
          ),
          // label: Text(
          //   "close",
          //   style: TextStyle(color: Colors.white),
          // ),
        ),
      ],
    );
  }
}
