import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/database/collect_salary.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class RightButtons extends StatefulWidget {
  @override
  _RightButtonsState createState() => _RightButtonsState();
}

class _RightButtonsState extends State<RightButtons> {
  bool _isCollect = false;

  @override
  void initState() {
    super.initState();
    new Future.delayed(Duration.zero, () {
      isCollect();
    });
  }

  void isCollect() async {
    bool tmp = await CollectSalary().isCollected(
        "" + Provider.of<KeyBoard>(context, listen: false).nowSalaryId);
    print("$tmp");
    setState(() {
      _isCollect = tmp;
    });
  }

  @override
  Widget build(BuildContext context) {
    KeyBoard provider = Provider.of<KeyBoard>(context);
    CollectData providerCollect = Provider.of<CollectData>(context);
    return Container(
      width: os_width * 0.48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          myInkWell(
            widget: RightButtonSingle(
              txt: "举报反馈",
              path: "lib/img/detail-feedback.svg",
            ),
            height: 50,
            radius: 2.0,
            width: os_width * 0.12,
          ),
          myInkWell(
            tap: () async {
              if (!_isCollect) {
                await CollectSalary().addCollect("${provider.nowSalaryId}");
                CollectSalary().lookCollect();
                setState(() {
                  _isCollect = true;
                });
              } else {
                await CollectSalary().delCollect("${provider.nowSalaryId}");
                CollectSalary().lookCollect();
                setState(() {
                  _isCollect = false;
                });
              }
              providerCollect.refresh();
            },
            widget: _isCollect
                ? RightButtonSingle(
                    txt: "收藏",
                    path: "lib/img/detail-collected.svg",
                  )
                : RightButtonSingle(
                    txt: "收藏",
                    path: "lib/img/detail-collect.svg",
                  ),
            height: 50,
            radius: 2.0,
            width: os_width * 0.12,
          ),
          myInkWell(
            tap: () async {
              final res = await Api().webapi_jobdislike(
                param: {
                  "id": "${provider.nowSalaryId}",
                },
              );
              if (res['msg'] != null) {
                Fluttertoast.showToast(
                  msg: "${res['msg']}",
                  gravity: ToastGravity.CENTER,
                );
              }
            },
            widget: RightButtonSingle(
              txt: "不可信",
              path: "lib/img/detail-unlike.svg",
            ),
            height: 50,
            radius: 2.0,
            width: os_width * 0.12,
          ),
          myInkWell(
            tap: () async {
              final res = await Api().webapi_joblike(
                param: {
                  "id": "${provider.nowSalaryId}",
                },
              );
              if (res['msg'] != null) {
                Fluttertoast.showToast(
                  msg: "${res['msg']}",
                  gravity: ToastGravity.CENTER,
                );
              }
            },
            widget: RightButtonSingle(
              txt: "可信",
              path: "lib/img/detail-like.svg",
            ),
            height: 50,
            radius: 2.0,
            width: os_width * 0.12,
          ),
        ],
      ),
    );
  }
}

class RightButtonSingle extends StatefulWidget {
  final String txt;
  final String path;

  const RightButtonSingle({
    Key key,
    @required this.txt,
    @required this.path,
  }) : super(key: key);
  @override
  _RightButtonSingleState createState() => _RightButtonSingleState();
}

class _RightButtonSingleState extends State<RightButtonSingle> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        os_svg(
          path: widget.path ?? "lib/img/detail-collect.svg",
          size: 30,
        ),
        Container(height: 2),
        Text(
          widget.txt ?? "收藏",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6E6E6E),
          ),
        ),
      ],
    );
  }
}
