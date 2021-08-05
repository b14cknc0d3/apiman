import 'package:flutter/material.dart';

class ActionMenu extends StatelessWidget {
  const ActionMenu(
      {Key? key, required this.addPageView, required this.removePageView})
      : super(key: key);
  final Function? addPageView, removePageView;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuOptions>(
        onSelected: (MenuOptions value) {
          switch (value) {
            case MenuOptions.addPageAtEnd:
              this.addPageView!();
              break;
            case MenuOptions.deletePageCurrent:
              this.removePageView!();
              break;
          }
        },
        itemBuilder: (BuildContext ctx) => <PopupMenuItem<MenuOptions>>[
              PopupMenuItem(
                  value: MenuOptions.addPageAtEnd,
                  child: const Text("Add Page at end")),
              PopupMenuItem(
                  value: MenuOptions.deletePageCurrent,
                  child: const Text("Delete current page")),
            ]);
  }
}

enum MenuOptions { addPageAtEnd, deletePageCurrent }
