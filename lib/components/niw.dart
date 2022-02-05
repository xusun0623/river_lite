import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';

class myInkWell extends StatefulWidget {
  final Widget widget;
  final double width;
  final double height;
  final double radius;
  final Color highlightColor;
  final Color splashColor;
  final Color color;
  final Function tap;

  const myInkWell({
    Key key,
    @required this.widget,
    @required this.radius,
    this.width,
    this.height,
    this.highlightColor,
    this.splashColor,
    this.tap,
    this.color,
  }) : super(key: key);
  @override
  _myInkWellState createState() => _myInkWellState();
}

class _myInkWellState extends State<myInkWell> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          color: widget.color ?? os_white,
        ),
        width: widget.width,
        height: widget.height,
        child: InkWell(
          highlightColor: widget.highlightColor ?? null,
          splashColor: widget.splashColor ?? null,
          onTap: () {
            if (widget.tap != null) {
              widget.tap();
            }
          },
          borderRadius: BorderRadius.circular(widget.radius),
          child: widget.widget,
        ),
      ),
    );
  }
}
