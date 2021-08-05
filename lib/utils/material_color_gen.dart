import 'dart:math';
import 'package:flutter/material.dart';

MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: tintColor(color, 0.5),
    100: tintColor(color, 0.4),
    200: tintColor(color, 0.3),
    300: tintColor(color, 0.2),
    400: tintColor(color, 0.1),
    500: tintColor(color, 0),
    600: tintColor(color, -0.1),
    700: tintColor(color, -0.2),
    800: tintColor(color, -0.3),
    900: tintColor(color, -0.4),
  });
}

int tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

Color tintColor(Color color, double factor) => Color.fromRGBO(
    tintValue(color.red, factor),
    tintValue(color.green, factor),
    tintValue(color.blue, factor),
    1);

class Palette {
  static const Color primary = Color(0xff66bb6a);
}




// class CustomTheme {
//   static ThemeData get lightTheme { //1
//     return ThemeData( //2
//       primaryColor: CustomColors.purple,
//       scaffoldBackgroundColor: Colors.white,
//       fontFamily: 'Montserrat', //3
//       buttonTheme: ButtonThemeData( // 4
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
//         buttonColor: CustomColors.lightPurple,
//       )
//     );
//   }
// }