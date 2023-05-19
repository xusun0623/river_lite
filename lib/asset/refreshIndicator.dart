import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

RefreshIndicator getMyRrefreshIndicator({
  Key? key,
  Color? color,
  required Widget child,
  required Function onRefresh,
  required BuildContext context,
}) {
  return RefreshIndicator(
    key: key,
    backgroundColor: Provider.of<ColorProvider>(
      context,
      listen: false,
    ).isDark
        ? Color(0xff444444)
        : os_white,
    color: Provider.of<ColorProvider>(
      context,
      listen: false,
    ).isDark
        ? os_dark_white
        : (color ?? os_color),
    onRefresh: onRefresh as Future<void> Function(),
    child: child,
  );
}
