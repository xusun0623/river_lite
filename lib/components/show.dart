import 'package:flutter/material.dart';

class Show extends StatefulWidget {
  final bool isShow;
  final Widget widget;

  const Show({Key key, @required this.isShow, @required this.widget})
      : super(key: key);
  @override
  _ShowState createState() => _ShowState();
}

class _ShowState extends State<Show> {
  @override
  Widget build(BuildContext context) {
    return widget.isShow
        ? widget
        : Container(
            width: 0,
            height: 0,
          );
  }
}
