import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/data.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/components/byxusun.dart';
import 'package:offer_show/components/empty.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/components/occu.dart';
import 'package:offer_show/components/salary.dart';
import 'package:offer_show/components/scaffold.dart';
import 'package:offer_show/components/title.dart';
import 'package:offer_show/database/collect_salary.dart';
import 'dart:math' as math;

import 'package:offer_show/page/broke.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class Me extends StatefulWidget {
  const Me({Key key}) : super(key: key);
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
  void initState() {
    new Future.delayed(Duration.zero, () {
      getData();
    });
    super.initState();
  }

  getData() async {
    await Provider.of<CollectData>(context, listen: false).refresh();
  }

  Widget _buildList(salaryData) {
    print("build");
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
    return Column(children: t);
  }

  @override
  Widget build(BuildContext context) {
    CollectData provider = Provider.of<CollectData>(context);
    final double additionalBottomPadding =
        math.max(MediaQuery.of(context).padding.bottom - 12.0 / 2.0, 0.0);
    double height = MediaQuery.of(context).size.height;
    EdgeInsets padding = MediaQuery.of(context).padding;
    double top = max(padding.top, EdgeInsets.zero.top);
    return Scaffold(
      backgroundColor: os_back,
      body: EasyRefresh(
        header: MaterialHeader(
          enableHapticFeedback: true,
        ),
        onRefresh: () async {
          await getData();
          return;
        },
        child: ListView(
          children: [
            occu(height: top + 20.0),
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
            occu(height: 20.0),
            provider.salaryData.length == 0
                ? OSEmpty(txt: "您还没有收藏薪资哦", show: true)
                : _buildList(provider.salaryData),
            provider.salaryData.length == 0
                ? Container()
                : ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(os_back),
                      shadowColor:
                          MaterialStateProperty.all(Colors.transparent),
                      foregroundColor: MaterialStateProperty.all(os_deep_grey),
                    ),
                    onPressed: () async {
                      CollectSalary().clear();
                      provider.clear();
                    },
                    child: Text("清空收藏"),
                  ),
            occu(height: 20.0),
          ],
        ),
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
