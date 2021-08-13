import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

List<AppTheme> themes = [
  AppTheme(
    id: "theme_green",
    description: "Green Theme",
    data: ThemeData(
      buttonTheme: ButtonThemeData(),
      primarySwatch: Colors.green,
      primaryColor: Color(0xFF33691e),
      primaryColorLight: Color(0xff629749),
      primaryColorDark: Color(0xff003d00),
      snackBarTheme: SnackBarThemeData(
        contentTextStyle: TextStyle(color: Colors.white),
        backgroundColor: Color(0xFF33691e),
      ),
    ),
  ),
  AppTheme(
    id: "theme_yellow",
    description: "Green Theme",
    data: ThemeData(
      primarySwatch: Colors.yellow,
    ),
  ),
  AppTheme(
    id: "theme_red",
    description: "Green Theme",
    data: ThemeData(
      primarySwatch: Colors.red,
    ),
  ),
  AppTheme(
    id: "theme_deepPurple",
    description: "DeepPurlple Theme",
    data: ThemeData(
      primarySwatch: Colors.deepPurple,
    ),
  ),
];
