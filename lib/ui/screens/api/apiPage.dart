import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';
import 'package:apiman/database/database.dart';

import 'package:apiman/ui/screens/api/apiPageData.dart';

import 'package:easy_localization/easy_localization.dart';

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
    // TabData(
    //     text: "default",
    //     content: ApiPagedata(
    //       tabId: 0,
    //     ),
    //     closable: false)
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
    row() async {
      final rows = await dbHelper.queryAllApiRowOrderByTabId();

      print("Querying ALl Row......");
      // print(allRows);
      for (int i = 0; i < rows.length; i++) {
        // var tabID = rows[i]["tabId"];
        print(i);
        tabs.add(TabData(
            keepAlive: true,
            text: "api_tab $i",
            closable: i == 0 ? false : true,
            content: ApiPagedata(row: rows[i])));
      }
    }

    row();

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

    TabbedView tabbedView = TabbedView(
        onTabClosing: _onTabClosing,
        controller: _model,
        theme: theme,
        tabsAreaButtonsBuilder: (context, tabsCount) {
          List<TabButton> buttons = [];
          buttons.add(TabButton(
              icon: Icons.add_box_rounded,
              onPressed: () {
                _model.addTab(TabData(
                  keepAlive: true,
                  text: 'api_tab ${tabsCount + 1}',
                  content: ApiPagedata(
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
