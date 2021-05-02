import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/components/niw.dart';

class RightButtons extends StatefulWidget {
  @override
  _RightButtonsState createState() => _RightButtonsState();
}

class _RightButtonsState extends State<RightButtons> {
  @override
  Widget build(BuildContext context) {
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
            widget: RightButtonSingle(
              txt: "收藏",
              path: "lib/img/detail-collect.svg",
            ),
            height: 50,
            radius: 2.0,
            width: os_width * 0.12,
          ),
          myInkWell(
            widget: RightButtonSingle(
              txt: "不可信",
              path: "lib/img/detail-unlike.svg",
            ),
            height: 50,
            radius: 2.0,
            width: os_width * 0.12,
          ),
          myInkWell(
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
