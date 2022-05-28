import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
import 'package:provider/provider.dart';

class Start extends StatefulWidget {
  const Start({Key key}) : super(key: key);

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  _navi() async {
    await Future.delayed(Duration(milliseconds: 500));
    Navigator.pushNamed(context, "/body");
  }

  _dark() async {
    String dark_mode_txt = await getStorage(key: "dark", initData: "");
    Provider.of<ColorProvider>(context, listen: false).isDark =
        dark_mode_txt != "";
    Provider.of<ColorProvider>(context, listen: false).refresh();
  }

  @override
  void initState() {
    _navi();
    _dark();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
      body: Center(
        child: FlutterLogo(
          size: 100,
        ),
      ),
    );
  }
}
