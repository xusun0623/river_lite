import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/home_desktop_mode.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/showPop.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/asset/toWebUrl.dart';
import 'package:offer_show/components/newNaviBar.dart';
import 'package:offer_show/util/cache_manager.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
import 'package:provider/provider.dart';

class Setting extends StatefulWidget {
  Setting({Key? key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  List<Widget> _buildWidget() {
    List<Widget> tmp = [];
    tmp.addAll([
      ResponsiveWidget(
        child: SwitchListTile(
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
      ),
      Container(height: 15),
      Opacity(
          opacity: Provider.of<ColorProvider>(context).isDark ? 0.6 : 1,
          child: SelectCard()),
      Container(height: 20),
      ResponsiveWidget(
        child: SwitchListTile(
          inactiveTrackColor: Provider.of<ColorProvider>(context).isDark
              ? Color(0x33FFFFFF)
              : os_middle_grey,
          title: Text(
            "水滴自动答题",
            style: TextStyle(
              color: Provider.of<ColorProvider>(context).isDark
                  ? os_dark_white
                  : os_black,
            ),
          ),
          value: autoAnswer,
          onChanged: (bool value) {
            setStorage(key: "auto", value: value ? "1" : "");
            setState(() {
              autoAnswer = value;
            });
          },
        ),
      ),
      ResponsiveWidget(
        child: ListTile(
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
      ),
      ResponsiveWidget(
        child: ListTile(
          title: Text(
            "清除所有图片缓存",
            style: TextStyle(
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_white
                    : os_black),
          ),
          subtitle: Text(
            "清除缓存可以释放占用空间，但在需要对应图片时，须重新请求",
            style: TextStyle(
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_white
                    : os_deep_grey),
          ),
          trailing: Icon(
            Icons.chevron_right_rounded,
            color: Provider.of<ColorProvider>(context).isDark
                ? os_dark_dark_white
                : os_deep_grey,
          ),
          onTap: () async {
            showModal(
                context: context,
                title: "请确认",
                cont: "将会清除所有已缓存的图片和头像以释放存储资源，但可能需要花较长时间重新请求",
                confirm: () async {
                  showToast(
                      context: context, type: XSToast.loading, txt: "请稍后…");
                  await RiverListCacheManager.instance.emptyCache();
                  await Future.delayed(Duration(milliseconds: 500));
                  hideToast();
                  showToast(
                      context: context, type: XSToast.success, txt: "清除成功！");
                });
          },
        ),
      ),
      ResponsiveWidget(
        child: ListTile(
          title: Text(
            "清除所有视频缓存",
            style: TextStyle(
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_white
                    : os_black),
          ),
          subtitle: Text(
            "清除缓存可以释放占用空间，但在需要对应视频时，须重新请求",
            style: TextStyle(
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_white
                    : os_deep_grey),
          ),
          trailing: Icon(
            Icons.chevron_right_rounded,
            color: Provider.of<ColorProvider>(context).isDark
                ? os_dark_dark_white
                : os_deep_grey,
          ),
          onTap: () async {
            showModal(
                context: context,
                title: "请确认",
                cont: "将会清除所有已缓存的视频以释放存储资源，但可能需要花较长时间重新请求",
                confirm: () async {
                  showToast(
                      context: context, type: XSToast.loading, txt: "请稍后…");
                  String video_arr_txt =
                      await getStorage(key: "video", initData: "[]");
                  List video_arr = jsonDecode(video_arr_txt);
                  for (var path in video_arr) {
                    if (path.toString().contains("mp4") ||
                        path.toString().contains("m4a") ||
                        path.toString().contains("flv")) {
                      var tmp = File(path);
                      if (tmp.existsSync()) {
                        tmp.deleteSync();
                      }
                    }
                  }
                  await Future.delayed(Duration(milliseconds: 500));
                  hideToast();
                  showToast(
                      context: context, type: XSToast.success, txt: "清除成功！");
                });
          },
        ),
      ),
      ResponsiveWidget(
        child: ListTile(
          title: Text(
            "删除河畔账号",
            style: TextStyle(
              color: Provider.of<ColorProvider>(context).isDark
                  ? os_dark_white
                  : os_black,
            ),
          ),
          onTap: () async {
            xsLanuch(
              url:
                  "https://bbs.uestc.edu.cn/forum.php?mod=viewthread&tid=1822104&extra=page%3D1",
              isExtern: false,
            );
          },
        ),
      )
    ]);
    tmp.add(Container(height: 10));
    return tmp;
  }

  bool autoAnswer = true;

  getAnsStatus() async {
    String txt = await getStorage(key: "auto");
    setState(() {
      autoAnswer = txt != "";
    });
  }

  @override
  void initState() {
    getAnsStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabShowProvider provider = Provider.of<TabShowProvider>(context);
    return Baaaar(
      child: Scaffold(
        backgroundColor: Provider.of<ColorProvider>(context).isDark
            ? os_dark_back
            : os_white,
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
          //physics: BouncingScrollPhysics(),
          children: _buildWidget(),
        ),
      ),
    );
  }
}

class SelectCard extends StatefulWidget {
  SelectCard({
    Key? key,
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
