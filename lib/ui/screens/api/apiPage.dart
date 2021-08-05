import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

import 'package:websocket_tester/ui/screens/api/apiPageData.dart';
import 'package:websocket_tester/ui/screens/api/apiPageData2.dart';
import 'package:websocket_tester/widgets/ActionMenu.dart';

import 'package:websocket_tester/widgets/customTabBarView.dart';
import 'package:websocket_tester/widgets/tabIcons.dart';

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
  // List<Tab> tabs = [];
  TabController? tabController;

  // // ignore: unused_field
  int _currentPosition = 0;
  int pageCount = 1;

  @override
  void dispose() {
    tabController!.dispose();

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

  @override
  Widget build(BuildContext context) {
    TabbedViewTheme theme = TabbedViewTheme();
    theme.tabsArea
      ..border = Border(
          bottom: BorderSide(color: Theme.of(context).primaryColor, width: 1))
      ..middleGap = 3;

    Radius radius = Radius.circular(0.0);
    BorderRadiusGeometry? borderRadius =
        BorderRadius.only(topLeft: radius, topRight: radius);

    theme.tabsArea.tab
      ..padding = EdgeInsets.fromLTRB(10, 4, 10, 4)
      ..buttonsOffset = 8
      ..decoration = BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.green[100],
          borderRadius: borderRadius)
      ..selectedStatus.decoration = BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: borderRadius)
      ..highlightedStatus.decoration =
          BoxDecoration(color: Colors.green[50], borderRadius: borderRadius);

    // super.build(context);
    TabbedView tabbedView = TabbedView(
      controller: _model,
      theme: theme,
      contentBuilder: (ctx, idx) => IndexedStack(
        index: _model.selectedIndex,
        // controller: tabController,
        children: tabs.map((e) => e.content!).toList(),
      ),
    );

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(2.0),
      child: tabbedView,
    ));
  }
}
