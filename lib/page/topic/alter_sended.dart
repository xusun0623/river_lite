import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/page/new/new.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class AlterSended extends StatefulWidget {
  AlterSended({Key key}) : super(key: key);

  @override
  State<AlterSended> createState() => _AlterSendedState();
}

class _AlterSendedState extends State<AlterSended> {
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
