import 'package:flutter/material.dart';

import 'package:websocket_tester/ui/screens/api/apiPageData.dart';

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

class _ApiViewState extends State<ApiView> with AutomaticKeepAliveClientMixin {
  int initPosition = 0;

  // List<String> tData = ["Page 0"];
  List<ApiPagedata> _tabs = [ApiPagedata()];

  callback2(newData) {
    setState(() {
      _tabs.add(ApiPagedata());
    });
  }

  callback(newtData) {
    setState(() {
      _tabs = newtData;
      print(newtData);
      print("cur position:$initPosition");
    });
  }

  @override
  void initState() {
    // _tabs = List.generate(tData.length, (index) => ApiPagedata());
    print(_tabs);
    super.initState();
  }

  @override
  bool get wantKeepAlive => true; //
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: SafeArea(
        child: CustomTabView(
          tData: _tabs,
          callback2: callback2,
          initPosition: initPosition,
          itemCount: _tabs.length,
          tabBuilder: (context, index) => Tab(
            iconMargin: EdgeInsets.only(
              // bottom: 10.0,
              left: 1.0,
              right: 1,
            ),
            icon: TabIcon(
              idx: index,
              tabs: _tabs,
              callback: callback,
            ),
          ),
          onPositionChange: (index) {
            print('current position: $index');
            initPosition = index;
          },
          onScroll: (position) => print('$position'),
          pageBuilder: (context, index) => _tabs[index],
        ),
      ),
    );
  }
}
