import 'dart:convert';
import 'dart:io';

import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/home_desktop_mode.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/toWebUrl.dart';
import 'package:offer_show/asset/vibrate.dart';
import 'package:offer_show/asset/xs_textstyle.dart';
import 'package:offer_show/components/newNaviBar.dart';
import 'package:offer_show/global_key/app.dart';
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
    FontSizeProvider provider = Provider.of<FontSizeProvider>(context);
    int divisions = ((1.2 - 0.8) / 0.05).round(); // 计算刻度数量
    List<Widget> tmp = [];
    tmp.addAll([
      ResponsiveWidget(
        child: SwitchListTile(
          inactiveTrackColor: Provider.of<ColorProvider>(context).isDark
              ? Color(0x33FFFFFF)
              : os_middle_grey,
          title: Text(
            "使用校园 VPN 访问",
            style: XSTextStyle(
              context: context,
              fontSize: 15,
              color: Provider.of<ColorProvider>(context).isDark
                  ? os_dark_white
                  : os_black,
            ),
          ),
          value: useVpn,
          onChanged: (bool value) {
            setStorage(key: "uestc_webvpn", value: value ? "1" : "");
            setState(() {
              useVpn = value;
              vpnEnabled = value;
            });
          },
        ),
      ),
      ...(useVpn ? [
        Padding(padding: EdgeInsets.symmetric(horizontal: 15), child: Column(children: [
          TextFormField(decoration: InputDecoration(labelText: 'VPN 登录学号'), initialValue: vpnUsername, onChanged: (String? value){
            setStorage(key: 'uestc_webvpn_user', value: value ?? "");
            setState(() {
              vpnUsername = value ?? "";
            });
          }),
          TextFormField(decoration: InputDecoration(labelText: 'VPN 登录密码', suffixIcon: IconButton(onPressed: () {
            setState(() {
              vpnPasswordObscured = !vpnPasswordObscured;
            });
          }, icon: Icon(vpnPasswordObscured ? Icons.visibility : Icons.visibility_off))),
          initialValue: vpnPassword,
          onChanged: (String? value){
            setStorage(key: 'uestc_webvpn_pass', value: value ?? "");
            setState(() {
              vpnPassword = value ?? "";
            });
          },
          obscureText: vpnPasswordObscured),
        ]))
      ] : []),
      ResponsiveWidget(
        child: ListTile(
          title: Text(
            "字体大小",
            style: XSTextStyle(
              context: context,
              color: Provider.of<ColorProvider>(context).isDark
                  ? os_dark_white
                  : os_black,
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
          ),
          trailing: Transform.translate(
            offset: Offset(15, 0),
            child: Container(
              width: 180,
              child: Slider(
                thumbColor: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_white
                    : os_black,
                activeColor: Provider.of<ColorProvider>(context).isDark
                    ? os_color
                    : os_dark_back,
                inactiveColor: Provider.of<ColorProvider>(context).isDark
                    ? os_white_opa
                    : os_black_opa,
                value: provider.fraction,
                min: 0.8,
                max: 1.2,
                divisions: divisions,
                label: provider.fraction.toStringAsFixed(2), // 显示两位小数的字符串
                onChanged: (double value) {
                  XSVibrate().light();
                  provider.setFontScaleFrac(value);
                  setState(() {});
                },
              ),
            ),
          ),
        ),
      ),
      Container(height: 5),
      ResponsiveWidget(
        child: SwitchListTile(
          inactiveTrackColor: Provider.of<ColorProvider>(context).isDark
              ? Color(0x33FFFFFF)
              : os_middle_grey,
          title: Text(
            "水滴自动答题",
            style: XSTextStyle(
              context: context,
              fontSize: 15,
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
            style: XSTextStyle(
                context: context,
                fontSize: 15,
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
            style: XSTextStyle(
                context: context,
                fontSize: 15,
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_white
                    : os_black),
          ),
          subtitle: Text(
            "清除缓存可以释放占用空间，但在需要对应图片时，须重新请求",
            style: XSTextStyle(
                context: context,
                fontSize: 13,
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
            style: XSTextStyle(
                context: context,
                fontSize: 15,
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_white
                    : os_black),
          ),
          subtitle: Text(
            "清除缓存可以释放占用空间，但在需要对应视频时，须重新请求",
            style: XSTextStyle(
                context: context,
                fontSize: 13,
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
            style: XSTextStyle(
              context: context,
              fontSize: 15,
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
  bool useVpn = false;
  String vpnUsername = "";
  String vpnPassword = "";
  bool vpnPasswordObscured = false;

  getAnsStatus() async {
    String txt = await getStorage(key: "auto");
    setState(() {
      autoAnswer = txt != "";
    });
  }

  @override
  void initState() {
    getAnsStatus();
    (() async {
      String vpn = await getStorage(key: 'uestc_webvpn');
      String vpnUser = await getStorage(key: 'uestc_webvpn_user');
      String vpnPass = await getStorage(key: 'uestc_webvpn_pass');
      setState(() {
        useVpn = vpn == "1";
        vpnUsername = vpnUser;
        vpnPassword = vpnPass;
      });
    })();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            style: XSTextStyle(
              context: context,
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
        body: DismissiblePage(
          backgroundColor: Provider.of<ColorProvider>(context).isDark
              ? os_dark_back
              : os_white,
          direction: DismissiblePageDismissDirection.startToEnd,
          onDismissed: () {
            Navigator.of(context).pop();
          },
          child: ListView(
            //physics: BouncingScrollPhysics(),
            children: _buildWidget(),
          ),
        ),
      ),
    );
  }
}
