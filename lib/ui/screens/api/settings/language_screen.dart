import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:websocket_tester/ui/screens/api/settings/cubit/cubit/lang_cubit.dart';

class LanguagesScreen extends StatefulWidget {
  final int idx;

  const LanguagesScreen({Key? key, required this.idx}) : super(key: key);
  @override
  _LanguagesScreenState createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  int? languageIndex;

  @override
  void initState() {
    setState(() {
      languageIndex = widget.idx;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LangCubit(),
      child: Scaffold(
        appBar: AppBar(title: Text('language'.tr())),
        body: SettingsList(
          sections: [
            SettingsSection(tiles: [
              SettingsTile(
                title: "English",
                trailing: trailingWidget(0),
                onPressed: (BuildContext context) {
                  changeLanguage(0);
                },
              ),
              SettingsTile(
                title: "Myanmar",
                trailing: trailingWidget(1),
                onPressed: (BuildContext context) {
                  changeLanguage(1);
                },
              ),
              // SettingsTile(
              //   title: "Chinese",
              //   trailing: trailingWidget(2),
              //   onPressed: (BuildContext context) {
              //     changeLanguage(2);
              //   },
              // ),
              // SettingsTile(
              //   title: "German",
              //   trailing: trailingWidget(3),
              //   onPressed: (BuildContext context) {
              //     changeLanguage(3);
              //   },
              // ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget trailingWidget(int index) {
    return (languageIndex == index)
        ? Icon(Icons.check, color: Colors.blue)
        : Icon(null);
  }

  void changeLanguage(int index) async {
    setState(() {
      languageIndex = index;

      // context.setLocale(locale);
      languageIndex = index;
    });

    var locale = context.supportedLocales[index];
    log(locale.toString(), name: toString());

    await context.setLocale(locale);
    context.read<LangCubit>().langSwitch();
  }
}
