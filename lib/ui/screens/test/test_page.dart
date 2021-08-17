import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import 'package:websocket_tester/ui/screens/test/code_box.dart'; // imported the package

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  // final TextEditingController _jsonController = TextEditingController();
  // final FocusNode _editorFocusNode = FocusNode();
  // late CreamyEditingController controller;
  // late ScrollController scrollController;
  // static final GlobalKey<FormState> editableTextKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();

    // // The below example shows [CreamyEditingController], a text editing controller with RichText highlighting support
    // controller = CreamyEditingController(
    //   // This is the CreamySyntaxHighlighter which will be used by the controller
    //   // to generate list of RichText for syntax highlighting
    //   syntaxHighlighter: CreamySyntaxHighlighter(
    //     language: LanguageType.json,
    //     theme: HighlightedThemeType.defaultTheme,
    //   ),
    //   // The number of spaces which will replace `\t`.
    //   // Setting this to 1 does nothing & setting this to value less than 1
    //   // throws assertion error.
    //   tabSize: 4,
    // );
    // scrollController = ScrollController();
  }

  @override
  void dispose() {
    // controller.dispose();
    // scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final codeBox = JsonCodeBox(language: "json", theme: "monokai-sublime");
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 4.w, right: 4.w),
              child: Container(
                // color: Colors.black,
                width: 100.h,
                height: 50.h,
                child: SingleChildScrollView(child: codeBox),
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "TEST RESULT",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Divider(),

            ///[demo only]
            _testBuilder(),
            Divider(),

            ///[demo only]
            _testResult(),
          ],
        ),
      ),
    );
  }

  _testBuilder() {
    int icx = 5;
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: icx,
        itemBuilder: (ctx, int idx) {
          return ListTile(
            onTap: () {
              showAboutDialog(context: context, children: [
                Text("testing /admin/1/change"),
              ]);
            },
            leading: Icon(
              (icx % (idx + 1) == 0) ? Icons.done : Icons.close,
              color: Theme.of(context).primaryColor,
            ),
            title: Text("TestAnonCRUD"),
            trailing: Text("${idx + 1}/$icx "),
          );
        });
  }

  _testResult() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text("[+] TOTAL 5 TEST RUN | 3 FAILDED | 2 SUCCESSED |  "),
    );
  }
}
