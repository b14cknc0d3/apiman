import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

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
  ActionMenu? actionMenu;
  int currentPageIndex = 0;
  int initPosition = 0;
  List<TabData> tabs = [
    TabData(text: "default", content: ApiPagedata(), closable: false)
  ];
  late TabbedViewController _model;

  int pageCount = 1;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    for (int i = 1; i < 3; i++) {
      tabs.add(TabData(
        text: "Tab $i",
        content: ApiPagedata(),
      ));
    }

    _model = TabbedViewController(tabs);
    // // _tabs = List.generate(tData.length, (index) => ApiPagedata());

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
                  content: ApiPagedata(),
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
}
