import 'package:flutter/material.dart';

class HeaderDialog extends StatelessWidget {
  final Map headers;
  const HeaderDialog({
    Key? key,
    required this.headers,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              // height: 300,
              width: 300,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: headers.length,
                  itemBuilder: (ctx, idx) {
                    String key = headers.keys.elementAt(idx);
                    var value = headers.values.elementAt(idx);
                    return Row(
                      children: [
                        Expanded(
                          child: Container(
                            width: 150,
                            height: 20,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Text("$key"),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(child: Text("|")),
                        Container(
                          width: 150,
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1,
                              ),
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Text(
                                  " $value",
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
            SizedBox(
              height: 1.5,
            ),
            ElevatedButton(
              child: const Text('OK'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
