import 'package:flutter/material.dart';

class BottomTip extends StatefulWidget {
  String txt;
  double top;
  double bottom;
  BottomTip({
    Key key,
    this.txt,
    this.top,
    this.bottom,
  }) : super(key: key);

  @override
  State<BottomTip> createState() => _BottomTipState();
}

class _BottomTipState extends State<BottomTip> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding:
            EdgeInsets.only(top: widget.top ?? 10, bottom: widget.bottom ?? 10),
        child: Text(
          widget.txt ?? "分割线",
          style: TextStyle(
            color: Color(0xFFDBDBDB),
          ),
        ),
      ),
    );
  }
}
