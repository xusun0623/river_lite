import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/components/niw.dart';

class BrokeButton extends StatefulWidget {
  final Function tap;

  const BrokeButton({Key key, @required this.tap}) : super(key: key);
  @override
  _BrokeButtonState createState() => _BrokeButtonState();
}

class _BrokeButtonState extends State<BrokeButton> {
  @override
  Widget build(BuildContext context) {
    return myInkWell(
      highlightColor: os_red,
      splashColor: os_black_opa,
      tap: widget.tap,
      widget: Center(
        child: Container(
          child: Text(
            "点此爆料",
            style: TextStyle(
              color: os_white,
              fontSize: 16,
            ),
          ),
        ),
      ),
      width: os_width - os_padding * 3,
      color: os_red,
      height: 50.0,
      radius: 15.0,
    );
  }
}
