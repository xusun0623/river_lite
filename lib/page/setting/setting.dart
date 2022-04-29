import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/page/login/login_helper.dart';
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

  @override
  void initState() {
    _getShowExplore();
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
        children: [
          SwitchListTile(
            onChanged: (change_val) {
              setStorage(key: "showExplore", value: change_val ? "1" : "");
              provider.loadIndex = change_val ? [0, 1, 2, 3] : [0, 2, 3];
              provider.index = 0;
              provider.refresh();
              setState(() {
                showExplore = change_val;
              });
            },
            value: showExplore,
            title: Text("展示探索页面"),
            subtitle: Text("是否要在首页展示探索页面，关闭后仅显示主页、消息页、我的页面"),
          ),
        ],
      ),
    );
  }
}
