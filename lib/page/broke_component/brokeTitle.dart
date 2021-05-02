import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/svg.dart';

class BrokeTitle extends StatefulWidget {
  final String txt;
  final String path;

  const BrokeTitle({
    Key key,
    @required this.txt,
    @required this.path,
  }) : super(key: key);

  @override
  _BrokeTitleState createState() => _BrokeTitleState();
}

class _BrokeTitleState extends State<BrokeTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: os_padding * 2,
        right: os_padding * 2,
      ),
      child: Row(
        children: [
          os_svg(
            path: widget.path,
            size: 30,
          ),
          Container(width: 5),
          Text(
            widget.txt,
            style: TextStyle(
              color: os_color,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
