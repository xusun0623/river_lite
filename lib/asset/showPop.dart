import 'package:flutter/material.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

import 'color.dart';

showPop(BuildContext context, List<Widget> widgets) {
  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Provider.of<ColorProvider>(context, listen: false).isDark
        ? os_light_dark_card
        : os_white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    context: context,
    builder: (context) {
      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: 30,
        ),
        height: MediaQuery.of(context).size.height - 100,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...widgets,
          ],
        ),
      );
    },
  );
}
