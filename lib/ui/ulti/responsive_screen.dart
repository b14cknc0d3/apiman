import 'package:flutter/material.dart';

class Screen {
  Size screenSize;
  // Screen._internal();
  // https://stackoverflow.com/questions/11112506/what-are-the-semantics-of-internal
  Screen(this.screenSize);

  double wp(percentage) {
    return percentage / 100 * screenSize.width;
  }

  double hp(percentage) {
    return percentage / 100 * screenSize.height;
  }

  double getWithPx(int pixels) {
    return (pixels / 3.61) / 100 * screenSize.width;
  }
}
