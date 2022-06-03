import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Setting extends StatefulWidget {
  Setting({Key key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  List<Widget> _buildWidget() {
    List<Widget> tmp = [];
    tmp.addAll([
      ListTile(
        title: Text(
          "意见反馈",
          style: TextStyle(
              color: Provider.of<ColorProvider>(context).isDark
                  ? os_dark_white
                  : os_black),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: Provider.of<ColorProvider>(context).isDark
              ? os_dark_dark_white
              : os_deep_grey,
        ),
        onTap: () {
          launchUrlString("https://www.wjx.cn/vj/mzgzO5S.aspx");
        },
      ),
      ListTile(
        title: Text(
          "拉黑/黑名单",
          style: TextStyle(
              color: Provider.of<ColorProvider>(context).isDark
                  ? os_dark_white
                  : os_black),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: Provider.of<ColorProvider>(context).isDark
              ? os_dark_dark_white
              : os_deep_grey,
        ),
        onTap: () {
          Navigator.pushNamed(context, "/black_list");
        },
      ),
      SwitchListTile(
        inactiveTrackColor: Provider.of<ColorProvider>(context).isDark
            ? Color(0x33FFFFFF)
            : os_middle_grey,
        onChanged: (change_val) {
          Provider.of<ShowPicProvider>(context, listen: false).isShow =
              change_val;
          Provider.of<ShowPicProvider>(context, listen: false).refresh();
          Provider.of<TabShowProvider>(context, listen: false).index = 0;
          Provider.of<TabShowProvider>(context, listen: false).refresh();
        },
        value: Provider.of<ShowPicProvider>(context).isShow,
        title: Row(
          children: [
            Text(
              "展示图区",
              style: TextStyle(
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_dark_white
                      : os_black),
            ),
          ],
        ),
        subtitle: Text(
          "手动切换是否展示图区（仅针对手机端生效）",
          style: TextStyle(
            color: Provider.of<ColorProvider>(context).isDark
                ? os_dark_dark_white
                : os_deep_grey,
          ),
        ),
      ),
      Container(height: 15),
      Opacity(
          opacity: Provider.of<ColorProvider>(context).isDark ? 0.6 : 1,
          child: SelectCard()),
      Container(height: 15),
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
      backgroundColor:
          Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_white,
      appBar: AppBar(
        backgroundColor: Provider.of<ColorProvider>(context).isDark
            ? os_dark_back
            : os_white,
        elevation: 0,
        title: Text(
          "应用设置",
          style: TextStyle(
            fontSize: 16,
            color: Provider.of<ColorProvider>(context).isDark
                ? os_dark_white
                : os_black,
          ),
        ),
        foregroundColor: os_black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.chevron_left_rounded,
            color: Provider.of<ColorProvider>(context).isDark
                ? os_dark_white
                : os_black,
          ),
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
  SelectCard({
    Key key,
  }) : super(key: key);

  @override
  State<SelectCard> createState() => _SelectCardState();
}

class _SelectCardState extends State<SelectCard> {
  @override
  Widget build(BuildContext context) {
    ShowPicProvider provider = Provider.of<ShowPicProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Provider.of<ShowPicProvider>(context, listen: false).isShow = false;
            Provider.of<ShowPicProvider>(context, listen: false).refresh();
            Provider.of<TabShowProvider>(context, listen: false).index = 0;
            Provider.of<TabShowProvider>(context, listen: false).refresh();
          },
          child: os_svg(
            width: 150,
            height: 250,
            path: !provider.isShow
                ? "lib/img/setting/2-se.svg"
                : "lib/img/setting/2.svg",
          ),
        ),
        Container(width: 15),
        GestureDetector(
          onTap: () {
            Provider.of<ShowPicProvider>(context, listen: false).isShow = true;
            Provider.of<ShowPicProvider>(context, listen: false).refresh();
            Provider.of<TabShowProvider>(context, listen: false).index = 0;
            Provider.of<TabShowProvider>(context, listen: false).refresh();
          },
          child: os_svg(
            width: 150,
            height: 250,
            path: provider.isShow
                ? "lib/img/setting/1-se.svg"
                : "lib/img/setting/1.svg",
          ),
        ),
      ],
    );
  }
}
