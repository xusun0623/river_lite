import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/util/interface.dart';
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

  _switchLogin(String username, String password, int index) async {
    showToast(context: context, type: XSToast.loading, txt: "加载中…");
    await Future.delayed(Duration(milliseconds: 500));
    var data = await Api().user_login({
      "type": "login",
      "username": username,
      "password": password,
    });
    hideToast();
    if (data != null) {
      if (data["rs"] == 0) {
        showToast(context: context, type: XSToast.none, txt: data["errcode"]);
      }
      if (data["rs"] == 1) {
        setStorage(key: "myinfo", value: jsonEncode(data));
        UserInfoProvider provider =
            Provider.of<UserInfoProvider>(context, listen: false);
        provider.data = data;
        provider.refresh();
        setState(() {
          logined = index;
        });
      }
    }
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

  List<Widget> _buildWidget() {
    List<Widget> tmp = [];
    tmp.addAll([
      Container(height: 25),
      SwitchListTile(
        onChanged: (change_val) {
          setStorage(key: "showExplore", value: change_val ? "1" : "");
          Provider.of<TabShowProvider>(context, listen: false).loadIndex =
              change_val ? [0, 1, 2, 3] : [0, 2, 3];
          Provider.of<TabShowProvider>(context, listen: false).index = 0;
          Provider.of<TabShowProvider>(context, listen: false).refresh();
          setState(() {
            showExplore = change_val;
          });
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
      ListTile(
        onTap: () {
          showModal(
              context: context,
              title: "请确认",
              cont: "即将退出登录，并删除你在本地的所有个人信息和收藏，请确认",
              confirm: () {
                UserInfoProvider provider =
                    Provider.of<UserInfoProvider>(context, listen: false);
                provider.data = null;
                provider.refresh();
                setStorage(key: "myinfo", value: "");
                setStorage(key: "topic_like", value: "");
                setStorage(key: "history", value: "[]");
                setStorage(key: "draft", value: "[]");
                setStorage(key: "search-history", value: "[]");
                setState(() {});
              });
        },
        title: Row(
          children: [
            Icon(Icons.logout, color: os_black),
            Container(width: 5),
            Text("退出登录"),
          ],
        ),
        subtitle: Text("即将退出登录，并删除你在本地的所有个人信息和收藏，请确认"),
      ),
      Container(height: 20),
      ListTile(
        subtitle: Row(
          children: [
            Text("快速切换账号"),
            IconButton(
              onPressed: () {
                _setManage();
              },
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.refresh,
                    size: 20,
                    color: os_color,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ]);
    for (int i = 0; i < accountData.length; i++) {
      tmp.add(ListTile(
        title: Text(accountData[i]["name"]),
        onTap: () {
          if (i == logined) return;
          _switchLogin(accountData[i]["name"], accountData[i]["password"], i);
        },
        trailing: Container(
          width: 100,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  if (i == logined) return;
                  _switchLogin(
                      accountData[i]["name"], accountData[i]["password"], i);
                },
                icon: Icon(
                  logined == i
                      ? Icons.radio_button_checked_outlined
                      : Icons.radio_button_off_outlined,
                  color: logined == i ? os_color : os_deep_grey,
                ),
              ),
              IconButton(
                onPressed: () {
                  showModal(
                    context: context,
                    title: "请确认",
                    cont: "是否要删除该账号信息，此操作不可逆",
                    confirm: () {
                      _deleteAccount(accountData[i]["name"]);
                    },
                  );
                },
                icon: Icon(Icons.delete_outline_rounded),
              ),
            ],
          ),
        ),
      ));
    }
    tmp.add(Container(height: 10));
    tmp.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, "/login");
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(vertical: 20, horizontal: 40)),
            backgroundColor: MaterialStateProperty.all(os_white),
            foregroundColor: MaterialStateProperty.all(os_black),
            elevation: MaterialStateProperty.all(0),
            overlayColor: MaterialStateProperty.all(os_grey),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, size: 20),
              Container(width: 5),
              Text("新增账号"),
            ],
          ),
        ),
      ],
    ));
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
