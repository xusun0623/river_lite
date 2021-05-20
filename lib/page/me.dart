import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/data.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/components/byxusun.dart';
import 'package:offer_show/components/niw.dart';
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
        "salarytype": "校招",
        "limit": 5,
      },
    );
    salaryData = toLocalSalary(res['info']);
    this.setState(() {});
  }

  List<Widget> _buildList() {
    var t = <Widget>[];
    salaryData.forEach((element) {
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
      ..add(byxusun(
        show: salaryData.length != 0,
        txt: "一键清除收藏",
      ))
      ..add(occu());
    return t;
  }

  @override
  Widget build(BuildContext context) {
    final double additionalBottomPadding =
        math.max(MediaQuery.of(context).padding.bottom - 12.0 / 2.0, 0.0);
    EdgeInsets padding = MediaQuery.of(context).padding;
    double top = max(padding.top, EdgeInsets.zero.top);
    return Scaffold(
      backgroundColor: os_back,
      body: Column(
        children: [
          occu(height: top + 20),
          Container(
            color: os_back,
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
          Container(
            child: ListView(
              children: _buildList(),
            ),
            width: os_width - 2 * os_padding,
            margin: EdgeInsets.only(top: 15),
            height: 400,
            decoration: BoxDecoration(
              color: os_white,
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
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
        myInkWell(
          color: os_white,
          widget: Container(
            width: 80,
            height: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  widget.icon,
                  width: os_width * 0.1,
                  height: os_width * 0.1,
                  color: os_color,
                  placeholderBuilder: (BuildContext context) => Container(
                    child: const CircularProgressIndicator(),
                  ),
                ),
              ],
            ),
          ),
          width: 70,
          height: 70,
          radius: 1000.0,
        ),
        Container(
          height: 5,
        ),
        Text(
          widget.txt,
          style: TextStyle(
            color: os_color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
