import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';

class OSDividender extends StatefulWidget {
  Color color;
  double height;
  double margin;
  OSDividender({
    Key key,
    this.color,
    this.height,
    this.margin,
  }) : super(key: key);
  @override
  _OSDividenderState createState() => _OSDividenderState();
}

class _OSDividenderState extends State<OSDividender> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: widget.margin ?? 0,
        bottom: widget.margin ?? 0,
      ),
      width: os_width,
      height: widget.height ?? 15,
      color: widget.color ?? os_light_grey,
    );
  }
}
