import 'package:flutter/material.dart';

import 'package:settings_ui/settings_ui.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:apiman/ui/screens/api/settings/language_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:apiman/database/database.dart';
import 'package:apiman/ui/screens/api/settings/widget_dialog.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool lockInBackground = true;
  bool notificationsEnabled = true;
  final dbHelper = DatabaseHelper.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildSettingsList(),
    );
  }

  Widget buildSettingsList() {
    var lang = EasyLocalization.of(context)!.currentLocale;
    // var lang =EasyLocalization.of(context).currentLocale;

    List keys = EasyLocalization.of(context)!.supportedLocales;
    var languageIndex = keys.indexOf(lang);
    var controller = ThemeProvider.controllerOf(context);

    return SettingsList(
      sections: [
        SettingsSection(
          title: "user".tr(),
          tiles: [
            SettingsTile(
                title: "profile".tr(),
                subtitle: "view",
                leading: Icon(Icons.account_circle))
          ],
        ),
        SettingsSection(
          title: 'common'.tr(),
          tiles: [
            SettingsTile(
              title: 'language'.tr(),
              subtitle: '${lang.toString()}',
              leading: Icon(Icons.language),
              onPressed: (context) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => LanguagesScreen(idx: languageIndex),
                ));
              },
            ),
            SettingsTile(
              title: 'environment'.tr(),
              subtitle: 'Production',
              leading: Icon(Icons.cloud_queue),
            ),
          ],
        ),
        SettingsSection(
          title: 'theme'.tr(),
          tiles: [
            // SettingsTile(title: 'Phone number', leading: Icon(Icons.phone)),
            // SettingsTile(title: 'Email', leading: Icon(Icons.email)),
            SettingsTile(
              title: 'change_theme'.tr(),
              leading: Icon(Icons.wb_sunny),
              onPressed: (_) {
                controller.nextTheme();
              },
            ),
          ],
        ),
        SettingsSection(
          title: 'security'.tr(),
          tiles: [
            SettingsTile(
              switchActiveColor: Theme.of(context).primaryColor,
              title: 'wipe data',
              leading: Icon(Icons.delete_forever),
              onPressed: (_) {
                showDialog(
                    context: context, builder: (context) => DeleteAllDialog());
              },
              // switchValue: lockInBackground,
              // onToggle: (bool value) {
              //   setState(() {
              //     lockInBackground = value;
              //     notificationsEnabled = value;
              //   });
              // },
            ),
            SettingsTile.switchTile(
                switchActiveColor: Theme.of(context).primaryColor,
                title: 'Use fingerprint',
                subtitle: 'Allow application to access stored fingerprint IDs.',
                leading: Icon(Icons.fingerprint),
                onToggle: (bool value) {},
                switchValue: false),
            SettingsTile.switchTile(
              switchActiveColor: Theme.of(context).primaryColor,
              title: 'Change password',
              leading: Icon(Icons.lock),
              switchValue: true,
              onToggle: (bool value) {},
            ),
            SettingsTile.switchTile(
              switchActiveColor: Theme.of(context).primaryColor,
              title: 'Enable Notifications',
              enabled: notificationsEnabled,
              leading: Icon(Icons.notifications_active),
              switchValue: true,
              onToggle: (value) {},
            ),
          ],
        ),
        SettingsSection(
          title: 'Misc',
          tiles: [
            SettingsTile(
                title: 'Terms of Service', leading: Icon(Icons.description)),
            SettingsTile(
                title: 'Open source licenses',
                leading: Icon(Icons.collections_bookmark)),
          ],
        ),
        CustomSection(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 22, bottom: 8),
                child: Image.asset(
                  'assets/settings.png',
                  height: 50,
                  width: 50,
                  color: Color(0xFF777777),
                ),
              ),
              Text(
                'Version'.tr(args: [": 0.0.1.alpha"]),
                style: TextStyle(color: Color(0xFF777777)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
