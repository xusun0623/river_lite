import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/cookie.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Account extends StatefulWidget {
  Account({Key key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
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
    if (txt_manage != "") {
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
  }

  _switchLogin(String username, String password, int index) async {
    showToast(context: context, type: XSToast.loading, txt: "加载中…");
    await getWebCookie(username: username, password: password);
    await Future.delayed(Duration(milliseconds: 400));
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
        await setStorage(key: "myinfo", value: jsonEncode(data));
        UserInfoProvider provider =
            Provider.of<UserInfoProvider>(context, listen: false);
        provider.data = data;
        provider.refresh();
        setState(() {
          logined = index;
        });
        Provider.of<MsgProvider>(context, listen: false).getMsg();
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

  void setExplore(bool isShow) {
    setStorage(key: "showExplore", value: isShow ? "1" : "");
    Provider.of<TabShowProvider>(context, listen: false).index = 0;
    Provider.of<TabShowProvider>(context, listen: false).refresh();
    setState(() {
      showExplore = isShow;
    });
  }

  List<Widget> _buildWidget() {
    List<Widget> tmp = [];
    tmp.addAll([
      Container(height: 10),
      ListTile(
        onTap: () {
          showModal(
              context: context,
              title: "请确认",
              cont: "即将退出登录，并删除你在本地的所有个人信息和收藏，请确认",
              confirm: () {
                UserInfoProvider provider =
                    Provider.of<UserInfoProvider>(context, listen: false);
                Provider.of<MsgProvider>(context, listen: false).clearMsg();
                provider.data = null;
                provider.refresh();
                setStorage(key: "myinfo", value: "");
                setStorage(key: "topic_like", value: "");
                setStorage(key: "history", value: "[]");
                setStorage(key: "draft", value: "[]");
                setStorage(key: "search-history", value: "[]");
                setState(() {});
                Navigator.pop(context);
              });
        },
        title: Row(
          children: [
            Icon(Icons.logout,
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_white
                    : os_black),
            Container(width: 5),
            Text(
              "退出登录",
              style: TextStyle(
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_white
                    : os_black,
              ),
            ),
          ],
        ),
        subtitle: Text(
          "即将退出登录，并删除你在本地的所有个人信息和收藏，请确认",
          style: TextStyle(
            color: os_deep_grey,
          ),
        ),
      ),
      Container(height: 5),
      ListTile(
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "快速切换账号",
              style: TextStyle(
                color: os_deep_grey,
              ),
            ),
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
        title: Text(
          accountData[i]["name"],
          style: TextStyle(
            color: Provider.of<ColorProvider>(context).isDark
                ? os_dark_white
                : os_black,
          ),
        ),
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
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: os_deep_grey,
                ),
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
            Navigator.pushNamed(context, "/login", arguments: 1);
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(vertical: 20, horizontal: 40)),
            backgroundColor: MaterialStateProperty.all(
                Provider.of<ColorProvider>(context).isDark
                    ? os_dark_back
                    : os_white),
            foregroundColor: MaterialStateProperty.all(
                Provider.of<ColorProvider>(context).isDark
                    ? os_dark_white
                    : os_black),
            elevation: MaterialStateProperty.all(0),
            overlayColor: MaterialStateProperty.all(
                Provider.of<ColorProvider>(context).isDark
                    ? os_light_dark_card
                    : os_grey),
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
      backgroundColor:
          Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_white,
      appBar: AppBar(
        backgroundColor: Provider.of<ColorProvider>(context).isDark
            ? os_dark_back
            : os_white,
        elevation: 0,
        title: Text("账号管理", style: TextStyle(fontSize: 16)),
        foregroundColor: Provider.of<ColorProvider>(context).isDark
            ? os_dark_white
            : os_black,
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
