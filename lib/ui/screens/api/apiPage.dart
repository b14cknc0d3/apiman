import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';
import 'package:websocket_tester/database/database.dart';

import 'package:websocket_tester/ui/screens/api/apiPageData.dart';

import 'package:websocket_tester/widgets/ActionMenu.dart';

class ApiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ApiView();
  }
}

class ApiView extends StatefulWidget {
  @override
  _ApiViewState createState() => _ApiViewState();
}

int? pageViewIndex;

class _ApiViewState extends State<ApiView> with TickerProviderStateMixin {
  List<TabData> tabs = [
    TabData(
        text: "default",
        content: ApiPagedata(
          tabId: 0,
        ),
        closable: false)
  ];
  late TabbedViewController _model;

  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    for (int i = 1; i < 3; i++) {
      tabs.add(TabData(
        text: "Tab $i",
        content: ApiPagedata(
          tabId: i,
        ),
      ));
    }

    _model = TabbedViewController(tabs);

    super.initState();
  }

  bool _onTabClosing(int tabIndex) {
    if (tabIndex == 0) {
      print('The tab $tabIndex is busy and cannot be closed.');
      return false;
    }
    print('Closing tab $tabIndex...');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    TabbedViewTheme theme = TabbedViewTheme();

    theme.menu.ellipsisOverflowText = true;
    theme.tabsArea
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

    TabbedView tabbedView = TabbedView(
        onTabClosing: _onTabClosing,
        controller: _model,
        theme: theme,
        contentBuilder: (ctx, idx) => IndexedStack(
              index: _model.selectedIndex,
              children: tabs.map((e) => e.content!).toList(),
            ),
        tabsAreaButtonsBuilder: (context, tabsCount) {
          List<TabButton> buttons = [];
          buttons.add(TabButton(
              icon: Icons.add,
              onPressed: () {
                // int millisecond = DateTime.now().millisecondsSinceEpoch;
                _model.addTab(TabData(
                  text: 'Tab ${tabsCount + 1}',
                  content: ApiPagedata(
                    tabId: tabsCount + 1,
                  ),
                ));
              }));
          // if (tabsCount > 0) {
          //   buttons.add(TabButton(
          //       icon: Icons.delete,
          //       onPressed: () {
          //         if (_model.selectedIndex != null) {
          //           _model.removeTab(_model.selectedIndex!);
          //         }
          //       }));
          // }
          return buttons;
        });

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(2.0),
      child: tabbedView,
    ));
  }

  Future<List<Map<String, dynamic>>> _query() async {
    final allRows = await dbHelper.queryAllRows();
    print("Querying ALl Row......");
    return allRows;
  }
}
