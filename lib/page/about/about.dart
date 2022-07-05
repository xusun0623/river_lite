import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/home_desktop_mode.dart';
import 'package:offer_show/asset/mouse_speed.dart';
import 'package:offer_show/asset/toWebUrl.dart';
import 'package:offer_show/asset/to_user.dart';
import 'package:offer_show/components/maxwidth.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

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
            cont: "https://gitee.com/xusun000/offershow",
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
            cont:
                '''河畔Lite由开源跨端框架Flutter开发完成。Flutter框架使用Skia调用GPU直接渲染，渲染速度和表现力十分优秀，并可以移植到诸多平台。所有代码和设计文件均开源，任何人可以查看、修改、商用、重新分发。''',
          ),
          AboutCard(
            head: Icon(
              Icons.verified_user,
              color: os_wonderful_color[2],
              size: 40,
            ),
            title: "鸣谢",
            cont:
                '''测试者：Star🌟、北冥小鱼、weijifen、TYTSSN、hola、fix\n功能&Bug贡献者：司空临风、炎舞、月夜的飘零\n代码贡献者：Dnieper、方觉\n河畔水滴答题题库：Zhenger666\n代码仓库：https://gitee.com\n设计工具：https://figma.com''',
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
      child: MaxWidth(
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
                        MinusSpace(context) -
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
      ),
    );
  }
}
