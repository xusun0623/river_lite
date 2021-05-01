import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/data.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/components/occu.dart';
import 'package:offer_show/components/salary.dart';
import 'package:offer_show/components/scaffold.dart';
import 'package:offer_show/components/title.dart';
import 'dart:math' as math;

import 'package:offer_show/page/broke.dart';

class Me extends StatefulWidget {
  @override
  _MeState createState() => _MeState();
}

class _MeState extends State<Me> {
  final icons = [
    "lib/img/me-agreement.svg",
    "lib/img/me-poster.svg",
    "lib/img/me-discuss.svg",
    "lib/img/me-feedback.svg",
  ];
  @override
  Widget build(BuildContext context) {
    final double additionalBottomPadding =
        math.max(MediaQuery.of(context).padding.bottom - 12.0 / 2.0, 0.0);
    return OSScaffold(
      bodyColor: os_grey,
      headerHeight: 130.0,
      header: Container(
        padding: new EdgeInsets.only(
          left: os_width * 0.075,
          right: os_width * 0.075,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HeadButton(icon: icons[0], txt: "平台公约"),
            HeadButton(icon: icons[1], txt: "薪资海报"),
            HeadButton(icon: icons[2], txt: "薪资论坛"),
            HeadButton(icon: icons[3], txt: "意见反馈"),
          ],
        ),
      ),
      columnHeight:
          os_height - kBottomNavigationBarHeight - additionalBottomPadding,
      body: Column(
        children: [
          occu(),
          OSTitle(
            title: "我的收藏",
            tip: "本地存储，不记录个人信息；如需屏蔽，请在对应薪资下反馈",
          ),
          OSSalary(
            data: new SalaryData(
              company: "滴滴",
            ),
          ),
          OSSalary(
            data: new SalaryData(),
          ),
          OSSalary(
            data: new SalaryData(),
          ),
          OSSalary(
            data: new SalaryData(),
          ),
          OSSalary(
            data: new SalaryData(),
          ),
          Card(),
          Card(),
          Card(),
          Card(),
          Card(),
          Card(),
          Card(),
          Card(),
          Card(),
          occu(),
          occu(),
          occu(),
          occu(),
          occu(),
          occu(),
          occu(),
          occu(),
          occu(),
        ],
      ),
    );
  }
}

class Card extends StatelessWidget {
  const Card({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: os_width * 0.95,
      height: 200,
      decoration: BoxDecoration(
        color: os_color,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: new EdgeInsets.only(
        left: os_width * 0.025,
        right: os_width * 0.025,
        top: 5,
        bottom: 5,
      ),
    );
  }
}

class HeadButton extends StatefulWidget {
  String icon;
  String txt;
  HeadButton({Key key, @required this.icon, @required this.txt})
      : super(key: key);
  @override
  _HeadButtonState createState() => _HeadButtonState();
}

class _HeadButtonState extends State<HeadButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 50,
          height: 50,
          padding: new EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: os_white,
            borderRadius: BorderRadius.circular(10000),
          ),
          child: SvgPicture.asset(
            widget.icon,
            placeholderBuilder: (BuildContext context) =>
                Container(child: const CircularProgressIndicator()),
          ),
        ),
        Container(
          height: 8,
        ),
        Text(
          widget.txt,
          style: TextStyle(
            color: os_white,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
