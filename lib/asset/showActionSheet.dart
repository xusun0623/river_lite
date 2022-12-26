import 'package:flutter/material.dart';
import 'package:offer_show/asset/showPop.dart';

showAction({
  required List<String> options,
  required List<IconData> icons,
  required BuildContext context,
  Function? cancel,
  Function? tap,
}) {
  assert(options.length == icons.length);
  showPop(
    context,
    height: 100,
    widgets: [
      Wrap(
        children: [],
      ),
    ],
  );
}
