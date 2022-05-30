import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

nowMode(BuildContext context) async {
  // _getDarkMode();
  if (window.platformBrightness == Brightness.dark &&
      !Provider.of<ColorProvider>(context, listen: false).isDark) {
    Provider.of<ColorProvider>(context, listen: false).isDark = true;
    Provider.of<ColorProvider>(context, listen: false).switchMode();
    Provider.of<ColorProvider>(context, listen: false).refresh();
  }
  if (window.platformBrightness == Brightness.light &&
      Provider.of<ColorProvider>(context, listen: false).isDark) {
    Provider.of<ColorProvider>(context, listen: false).isDark = false;
    Provider.of<ColorProvider>(context, listen: false).switchMode();
    Provider.of<ColorProvider>(context, listen: false).refresh();
  }
}
