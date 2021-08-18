import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:tabbed_view/tabbed_view.dart';
import 'package:apiman/database/database.dart';

import 'package:apiman/ui/screens/websocket/wsPageData.dart';

class WsPage extends StatefulWidget {
  const WsPage({Key? key}) : super(key: key);

  @override
  _WsPageState createState() => _WsPageState();
}

class _WsPageState extends State<WsPage> {
  // late final AudioCache _audioCache;
  List messages = [];
  List<TabData> tabs = [];
  late TabbedViewController _model;
  final dbHelper = DatabaseHelper.instance;

  // final TextEditingController _controller = TextEditingController();

  // final TextEditingController _pathController = TextEditingController();
  // final TextEditingController _headerController = TextEditingController();
  // final WsAPiLoader wsAPiLoader = WsAPiLoader();
  // IOWebSocketChannel? _channel;

  bool _onTabClosing(int tabIndex) {
    if (tabIndex == 0) {
      print('The tab $tabIndex is busy and cannot be closed.');
      return false;
    }
    print('Closing tab $tabIndex...');
    return true;
  }

  @override
  void initState() {
    row() async {
      final rows = await dbHelper.queryAllWsRowOrderByTabId();

      print("Querying ws All Row......");
      // print(allRows);
      for (int i = 0; i < rows.length; i++) {
        // var tabID = rows[i]["tabId"];
        print(i);
        tabs.add(TabData(
            keepAlive: true,
            text: "ws_tab $i",
            closable: i == 0 ? false : true,
            content: WsPageData(row: rows[i])));
      }
    }

    row();
    _model = TabbedViewController(tabs);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabbedViewTheme theme = TabbedViewTheme();

    theme.menu

      // ..hoverColor =
      // ..padding = EdgeInsets.only(top: 8, bottom: 10)
      ..color = Theme.of(context).backgroundColor
      ..dividerThickness = 2.0
      ..border = Border.all(
        width: 2.0,
        style: BorderStyle.solid,
      )
      // ..border = Bor
      ..textStyle = TextStyle(
        color: Colors.black,
      )

      // ..color = Colors.black
      ..hoverColor = Theme.of(context).primaryColor
      ..dividerColor = Colors.black
      ..ellipsisOverflowText = true;
    // theme.buttonArea

    theme.tabsArea
      // ..tab.
      // ..padding =EdgeInsets.only(butt),
      ..border = Border(
          bottom: BorderSide(color: Theme.of(context).primaryColor, width: 1))
      ..middleGap = 3;

    Radius radius = Radius.circular(0.0);
    BorderRadiusGeometry? borderRadius =
        BorderRadius.only(topLeft: radius, topRight: radius);

    theme.tabsArea.tab
      ..textStyle = TextStyle(color: Colors.black, fontWeight: FontWeight.w300)
      ..verticalAlignment = VerticalAlignment.top
      ..padding = EdgeInsets.fromLTRB(10, 4, 10, 4)
      ..buttonsOffset = 8
      // ..buttonIconSize = 24
      // ..buttonsGap = 4
      ..decoration = BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.green[100],
          borderRadius: borderRadius)
      ..selectedStatus.decoration = BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: borderRadius)
      ..highlightedStatus.decoration =
          BoxDecoration(color: Colors.green[50], borderRadius: borderRadius);

    theme.tabsArea.buttonsArea
      ..buttonIconSize = 22
      ..decoration =
          BoxDecoration(color: Colors.green[50], borderRadius: borderRadius)
      ..padding = EdgeInsets.only(bottom: 4, right: 8);
    // ..decoration = BoxDecoration(color: Theme.of(context).primaryColor);

    TabbedView tabbedView = TabbedView(
        onTabClosing: _onTabClosing,
        controller: _model,
        theme: theme,
        tabsAreaButtonsBuilder: (context, tabsCount) {
          List<TabButton> buttons = [];
          buttons.add(TabButton(
              icon: Icons.add_box_rounded,
              onPressed: () async {
                // int millisecond = DateTime.now().millisecondsSinceEpoch;
                Future.delayed(Duration(seconds: 1));
                _model.addTab(TabData(
                  keepAlive: true,
                  text: 'ws_tab ${tabsCount + 1}',
                  content: WsPageData(
                    row: {},
                  ),
                ));
              }));

          return buttons;
        });

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(2.0),
      child: tabbedView,
    ));
  }
}
