import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/mouse_speed.dart';
import 'package:offer_show/asset/toWebUrl.dart';
import 'package:offer_show/asset/to_user.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class About extends StatefulWidget {
  About({Key key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  ScrollController _scrollController = new ScrollController();
  @override
  void initState() {
    speedUp(_scrollController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
        elevation: 0,
        foregroundColor: Provider.of<ColorProvider>(context).isDark
            ? os_dark_white
            : os_black,
        centerTitle: true,
        title: Text(
          "关于",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.chevron_left_rounded),
        ),
      ),
      backgroundColor:
          Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
      body: ListView(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        children: [
          AboutCard(
            head: Icon(
              Icons.chat_bubble,
              color: os_wonderful_color[0],
              size: 40,
            ),
            title: "UESTC官方论坛",
            cont:
                "清水河畔是电子科技大学官方论坛（bbs.uestc.edu.cn），由电子科技大学网络文化建设工作办公室指导，星辰工作室开发并提供技术支持。\n2007年11月13日正式开放注册。欢迎你加入到清水河畔大家庭。",
          ),
          AboutCard(
            head: Icon(
              Icons.cloud,
              color: os_wonderful_color[5],
              size: 40,
            ),
            title: "开源地址",
            cont: "https://gitee.com/xusun000/offershow.git",
            withUrl: true,
          ),
          AboutCard(
            head: Icon(
              Icons.burst_mode,
              color: os_wonderful_color[4],
              size: 40,
            ),
            title: "设计文件",
            cont:
                "https://www.figma.com/file/McSp35qqjsUuWAbucxXdXn/河畔Max版-XS-Designed",
            withUrl: true,
          ),
          AboutCard(
            head: Icon(
              Icons.qr_code,
              color: os_wonderful_color[1],
              size: 40,
            ),
            title: "开发相关",
            cont: '''河畔Lite由开源跨端框架Flutter开发完成，所有代码和设计文件均开源，任何人可以查看、修改、商用、重新分发。
使用了如下开源项目，在此鸣谢：
flutter_picker: ^2.0.3
badges: ^2.0.2
characters: ^1.2.0
flutter_vibrate: ^1.3.0
vibration: ^1.7.3
image_picker: ^0.8.4+10
file_picker: ^4.5.0
photo_view: ^0.10.2
provider:
shared_preferences: ^2.0.5
fluttertoast: ^8.0.6
flutter_svg: ^0.21.0+1
dio: ^4.0.0
url_launcher: ^6.0.20
heic_to_jpg: ^0.2.0
image_gallery_saver: ^1.7.1
octo_image: ^1.0.1
flutter_cache_manager: ^3.3.0
cached_network_image_platform_interface: ^1.0.0
cached_network_image_web: ^1.0.0
crop_your_image: ^0.7.2
share_plus: ^4.0.4
lottie: ^1.3.0
flutter_bounce: ^1.1.0
syncfusion_flutter_sliders: ^20.1.51
sticky_headers: ^0.2.0
adaptive_theme: ^3.0.0
animate_do: ^2.1.0
percent_indicator: ^4.2.2
html: ^0.15.0''',
          ),
          AboutCard(
            head: Icon(
              Icons.verified_user,
              color: os_wonderful_color[2],
              size: 40,
            ),
            title: "鸣谢",
            cont: '''测试者：Star🌟、北冥小鱼、weijifen、TYTSSN、hola、fix
功能&Bug贡献者：司空临风、炎舞、月夜的飘零
代码贡献者：Dnieper
河畔水滴答题题库：Zhenger666
代码仓库：https://gitee.com
设计工具：https://figma.com''',
          ),
          AboutCard(
            head: Icon(
              Icons.person,
              color: os_wonderful_color[3],
              size: 50,
            ),
            title: "开发&设计者",
            cont: '''xusun000''',
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Center(
              child: Text(
                "@UESTC 河畔Lite",
                style: TextStyle(
                  color: os_deep_grey,
                ),
              ),
            ),
          ),
          Container(height: 10),
        ],
      ),
    );
  }
}

class AboutCard extends StatefulWidget {
  Widget head;
  String title;
  String cont;
  bool withUrl;
  AboutCard({
    Key key,
    @required this.head,
    @required this.title,
    @required this.cont,
    this.withUrl,
  }) : super(key: key);

  @override
  State<AboutCard> createState() => _AboutCardState();
}

class _AboutCardState extends State<AboutCard> {
  @override
  Widget build(BuildContext context) {
    return Bounce(
      onPressed: () {
        if (widget.withUrl != null) {
          xsLanuch(url: widget.cont);
        }
        if (widget.title == "开发&设计者") {
          toUserSpace(context, 221788);
        }
      },
      duration: Duration(milliseconds: 100),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7.5),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Provider.of<ColorProvider>(context).isDark
              ? os_light_dark_card
              : os_white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: widget.head),
            Container(height: 10),
            Center(
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_dark_white
                      : os_black,
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                ),
              ),
            ),
            Container(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width -
                      ((widget.withUrl ?? false) || widget.title == "开发&设计者"
                          ? 124
                          : 100),
                  child: Text(
                    (widget.title == "开发&设计者" ? "      " : "") + widget.cont,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Provider.of<ColorProvider>(context).isDark
                          ? os_dark_dark_white
                          : os_light_dark_card,
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                ),
                (widget.withUrl ?? false) || widget.title == "开发&设计者"
                    ? Container(
                        padding: EdgeInsets.only(top: 5),
                        child: Icon(
                          Icons.chevron_right,
                          color: Provider.of<ColorProvider>(context).isDark
                              ? os_dark_dark_white
                              : os_black,
                        ))
                    : Container()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
