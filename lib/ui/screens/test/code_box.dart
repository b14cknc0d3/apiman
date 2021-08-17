import 'package:code_text_field/code_text_field.dart';
import 'package:highlight/languages/all.dart';
import 'package:flutter/material.dart';
import 'package:websocket_tester/ui/screens/test/themes.dart';

class JsonCodeBox extends StatefulWidget {
  final String language;
  final String theme;
  const JsonCodeBox({Key? key, required this.language, required this.theme})
      : super(key: key);

  @override
  _JsonCodeBoxState createState() => _JsonCodeBoxState();
}

class _JsonCodeBoxState extends State<JsonCodeBox> {
  String? language;
  String? theme;
  @override
  void initState() {
    language = widget.language;
    theme = widget.theme;

    super.initState();
  }

  List<String?> get themeList {
    const TOP = <String>{
      "monokai-sublime",
      "a11y-dark",
      "an-old-hope",
      "vs2015",
      "vs",
      "atom-one-dark"
    };
    return <String?>[...TOP];
  }

  @override
  Widget build(BuildContext context) {
    print(theme);
    final themeDropDown =
        _buildDropDown(themeList, theme!, Icons.color_lens, (val) {
      if (val == null) return;
      setState(() {
        theme = val;
        print(theme);
      });
    });

    final dropdown = Row(
      children: [
        Container(
            color: Colors.black87,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: themeDropDown,
            )),
      ],
    );
    final codeField = InnerField(
      key: ValueKey("$language - $theme"),
      language: language ?? "json",
      theme: theme!,
    );
    return Column(
      children: [
        // dropdown,
        Divider(),
        codeField,
        Divider(),
        _buildBottomCommandRow(),
        // Divider(),
      ],
    );
  }

  Widget _buildDropDown(Iterable<String?> choices, String value, IconData icon,
      Function(String?) onChanged) {
    return DropdownButton<String>(
      value: value,
      items: choices.map((String? value) {
        return DropdownMenuItem<String>(
          value: value,
          child: value == null
              ? Divider()
              : Text(value, style: TextStyle(color: Colors.white)),
        );
      }).toList(),
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      onChanged: onChanged,
      dropdownColor: Colors.black87,
    );
  }

  _buildBottomCommandRow() {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: IconButton(
            tooltip: "save",
            splashRadius: 15.0,
            hoverColor: Colors.blue,
            icon: Icon(Icons.save_rounded),
            onPressed: () {},
          ),
        ),
        VerticalDivider(
          color: Colors.black87,
          width: 1,
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: IconButton(
            hoverColor: Colors.blue,
            tooltip: "run_test",
            splashRadius: 15.0,
            icon: Icon(Icons.play_circle),
            onPressed: () {},
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: IconButton(
            hoverColor: Colors.blue,
            tooltip: "share test",
            splashRadius: 15.0,
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

class InnerField extends StatefulWidget {
  final String language;
  final String theme;
  const InnerField({Key? key, this.language = "json", required this.theme})
      : super(key: key);

  @override
  _InnerFieldState createState() => _InnerFieldState();
}

class _InnerFieldState extends State<InnerField> {
  CodeController? _codeController;

  @override
  void initState() {
    super.initState();

    _codeController = CodeController(
      webSpaceFix: false,
      text: CODE_SNIPPETS["json"],
      patternMap: {
        r"\B#[a-zA-Z0-9]+\b": TextStyle(color: Colors.red),
        r"\B@[a-zA-Z0-9]+\b": TextStyle(
          fontWeight: FontWeight.w800,
          color: Colors.blue,
        ),
        r"\B![a-zA-Z0-9]+\b":
            TextStyle(color: Colors.yellow, fontStyle: FontStyle.italic),
      },
      theme: THEMES[widget.theme],
      language: allLanguages["json"],
    );
  }

  @override
  void dispose() {
    _codeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CodeField(
      controller: _codeController!,
      textStyle: TextStyle(fontFamily: "SourceCode"),
    );
  }
}

const CODE_SNIPPETS = {
  'json':
      '[\n  {\n    "title": "apples",\n    "count": [12000, 20000],\n    "description": {"text": "...", "sensitive": false}\n  },\n  {\n    "title": "oranges",\n    "count": [17500, null],\n    "description": {"text": "...", "sensitive": false}\n  }\n]\n',
};
