import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

RefreshIndicator getMyRrefreshIndicator({
  Key key,
  Color color,
  Widget child,
  Function onRefresh,
  BuildContext context,
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
    onRefresh: onRefresh,
    child: child,
  );
}
