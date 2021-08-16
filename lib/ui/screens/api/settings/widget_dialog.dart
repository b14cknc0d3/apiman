import 'package:flutter/material.dart';
import 'package:websocket_tester/database/database.dart';

class DeleteAllDialog extends StatelessWidget {
  final dbHelper = DatabaseHelper.instance;
  // const DeleteAllDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Wipe All Data?'),
      content: Text(
          'This will wipe all  your data to its default factory settings.'),
      actions: [
        TextButton(
          // style: ButtonStyle(
          //   backgroundColor: MaterialStateProperty.all(Color(0xFF6200EE)),
          // ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'CANCEL',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        TextButton(
          // textColor: Color(0xFF6200EE),
          onPressed: () {
            try {
              dbHelper.deleleAll().then(
                    (_) => Navigator.pop(context),
                  );
            } catch (e) {}
          },
          child: Text(
            'ACCEPT',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
