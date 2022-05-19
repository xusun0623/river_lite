import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
import 'package:provider/provider.dart';

class Setting extends StatefulWidget {
  Setting({Key key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  void setExplore(bool isShow) {
    Provider.of<ColorProvider>(context, listen: false).isDark = isShow;
    Provider.of<ColorProvider>(context, listen: false).switchMode();
  }

  List<Widget> _buildWidget() {
    List<Widget> tmp = [];
    tmp.addAll([
      Container(height: 25),
      SwitchListTile(
        onChanged: (change_val) {
          setExplore(change_val);
        },
        value: Provider.of<ColorProvider>(context).isDark,
        title: Row(
          children: [
            Text("深色模式"),
          ],
        ),
        subtitle: Text("你可以在此手动切换深色模式"),
      ),
    ]);
    tmp.add(Container(height: 10));
    return tmp;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabShowProvider provider = Provider.of<TabShowProvider>(context);
    return Scaffold(
      backgroundColor: os_white,
      appBar: AppBar(
        backgroundColor: os_white,
        elevation: 0,
        title: Text("应用设置", style: TextStyle(fontSize: 16)),
        foregroundColor: os_black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.chevron_left_rounded),
        ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: _buildWidget(),
      ),
    );
  }
}

class SelectCard extends StatefulWidget {
  int index;
  Function tap;
  SelectCard({
    Key key,
    this.index,
    this.tap,
  }) : super(key: key);

  @override
  State<SelectCard> createState() => _SelectCardState();
}

class _SelectCardState extends State<SelectCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            widget.tap(0);
          },
          child: os_svg(
            width: 150,
            height: 250,
            path: widget.index == 1
                ? "lib/img/setting/2-se.svg"
                : "lib/img/setting/2.svg",
          ),
        ),
        Container(width: 15),
        GestureDetector(
          onTap: () {
            widget.tap(1);
          },
          child: os_svg(
            width: 150,
            height: 250,
            path: widget.index == 0
                ? "lib/img/setting/1-se.svg"
                : "lib/img/setting/1.svg",
          ),
        ),
      ],
    );
  }
}
