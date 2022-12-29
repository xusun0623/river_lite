import 'package:flutter/material.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

import 'color.dart';

showPopWithHeight(BuildContext context, List<Widget> widgets, double height) {
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
        padding: EdgeInsets.symmetric(
          horizontal: 15,
        ),
        height: height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Provider.of<ColorProvider>(context).isDark
              ? os_dark_back
              : Color(0xFFF6F6F6),
        ),
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
        padding: EdgeInsets.symmetric(
          horizontal: 30,
        ),
        decoration: BoxDecoration(
          color: Provider.of<ColorProvider>(context, listen: false).isDark
              ? os_light_dark_card
              : os_white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
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
