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
  bool showExplore = true;
  _getShowExplore() async {
    String txt =
        await getStorage(key: "showExplore", initData: ""); //空代表不显示探索页面
    setState(() {
      showExplore = txt != "";
    });
  }

  List accountData = [];
  int logined = 0;

  _setManage() async {
    List quick = [];
    String txt_quick = await getStorage(key: "quick", initData: "[]");
    quick = jsonDecode(txt_quick);
    String txt_manage = await getStorage(key: "myinfo", initData: "");
    Map map_manage = jsonDecode(txt_manage);
    for (int i = 0; i < quick.length; i++) {
      if (map_manage["userName"] == quick[i]["name"]) {
        logined = i;
      }
    }
    setState(() {
      accountData = quick;
    });
  }

  //删除某账号
  _deleteAccount(String name) async {
    List quick = [];
    String txt_quick = await getStorage(key: "quick", initData: "[]");
    quick = jsonDecode(txt_quick);
    for (int i = 0; i < quick.length; i++) {
      if (name == quick[i]["name"]) {
        quick.removeAt(i);
      }
    }
    accountData = quick;
    await setStorage(key: "quick", value: jsonEncode(quick));
    _setManage();
  }

  void setExplore(bool isShow) {
    setStorage(key: "showExplore", value: isShow ? "1" : "");
    Provider.of<TabShowProvider>(context, listen: false).loadIndex =
        isShow ? [0, 1, 2, 3] : [0, 2, 3];
    Provider.of<TabShowProvider>(context, listen: false).index = 0;
    Provider.of<TabShowProvider>(context, listen: false).refresh();
    setState(() {
      showExplore = isShow;
    });
  }

  List<Widget> _buildWidget() {
    List<Widget> tmp = [];
    tmp.addAll([
      Container(height: 25),
      SwitchListTile(
        onChanged: (change_val) {
          setExplore(change_val);
        },
        value: showExplore,
        title: Row(
          children: [
            Text("展示探索页面"),
          ],
        ),
        subtitle: Text("是否要在首页展示探索页面，关闭后仅显示主页、消息页、我的页面"),
      ),
      Container(height: 25),
      SelectCard(
        index: showExplore ? 0 : 1,
        tap: (index) {
          setExplore(index == 1);
        },
      ),
    ]);
    tmp.add(Container(height: 10));
    return tmp;
  }

  @override
  void initState() {
    _getShowExplore();
    _setManage();
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
