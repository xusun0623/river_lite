import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/data.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/components/byxusun.dart';
import 'package:offer_show/components/occu.dart';
import 'package:offer_show/components/salary.dart';
import 'package:offer_show/components/scaffold.dart';
import 'package:offer_show/components/title.dart';
import 'dart:math' as math;

import 'package:offer_show/page/broke.dart';
import 'package:offer_show/util/interface.dart';

class Me extends StatefulWidget {
  @override
  _MeState createState() => _MeState();
}

class _MeState extends State<Me> {
  var salaryData = [];

  final icons = [
    "lib/img/me-agreement.svg",
    "lib/img/me-poster.svg",
    "lib/img/me-discuss.svg",
    "lib/img/me-feedback.svg",
  ];
  @override
  void initState() {
    print("Hello");
    _getData();
    super.initState();
  }

  void _getData() async {
    final res = await Api().webapi_v2_offers_4_lr(
      param: {
        // "xueli": "全部",
        "salarytype": "校招",
        "limit": 5,
      },
    );
    salaryData = toLocalSalary(res['info']);
    this.setState(() {});
  }

  List<Widget> _buildList() {
    var t = <Widget>[];
    t
      ..add(occu(height: 10.0))
      ..add(
        OSTitle(
          title: "我的收藏",
          tip: "本地存储，不记录个人信息；如需屏蔽，请在对应薪资下反馈",
        ),
      );
    salaryData.forEach((element) {
      // print("$element");
      t.add(OSSalary(
        data: SalaryData(
          company: element["company"].toString(),
          city: element["city"].toString(),
          confidence: element["confidence"].toString(),
          education: element["education"].toString(),
          money: element["money"].toString(),
          job: element["job"].toString(),
          remark: element["remark"].toString(),
          look: element["look"].toString(),
          time: element["time"].toString(),
          industry: element["industry"].toString(),
          type: element["type"].toString(),
          salaryId: element["salaryId"].toString(),
        ),
      ));
    });
    t
      ..add(occu())
      ..add(byxusun(
        show: salaryData.length != 0,
        txt: "一键清除收藏",
      ))
      ..add(occu())
      ..add(occu())
      ..add(occu());
    return t;
  }

  @override
  Widget build(BuildContext context) {
    final double additionalBottomPadding =
        math.max(MediaQuery.of(context).padding.bottom - 12.0 / 2.0, 0.0);
    return OSScaffold(
      onRefresh: () async {
        await _getData();
        return new Future.delayed(Duration(microseconds: 1));
      },
      bodyColor: os_grey,
      headerHeight: 100.0,
      header: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
        children: _buildList(),
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
      width: os_width - 2 * os_padding,
      height: 200,
      decoration: BoxDecoration(
        color: os_color,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: new EdgeInsets.only(
        left: os_padding,
        right: os_padding,
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
          height: 5,
        ),
        Text(
          widget.txt,
          style: TextStyle(
            color: Color(0xAAFFFFFF),
            // fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
