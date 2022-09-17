import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/page/new/new.dart';
import 'package:offer_show/page/new/success_display.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class AlterSent extends StatefulWidget {
  AlterSent({Key key}) : super(key: key);

  @override
  State<AlterSent> createState() => _AlterSentState();
}

class _AlterSentState extends State<AlterSent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Provider.of<ColorProvider>(context).isDark
            ? os_dark_white
            : os_black,
        backgroundColor:
            Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
        elevation: 0,
      ),
      backgroundColor:
          Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
      body: SuccessDisplay(),
    );
  }
}
