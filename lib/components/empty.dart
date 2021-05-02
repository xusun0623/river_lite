import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/components/byxusun.dart';

class OSEmpty extends StatefulWidget {
  final String txt;
  final bool show;

  const OSEmpty({Key key, @required this.txt, @required this.show})
      : super(key: key);
  @override
  _OSEmptyState createState() => _OSEmptyState();
}

class _OSEmptyState extends State<OSEmpty> {
  @override
  Widget build(BuildContext context) {
    return (widget.show
        ? Container(
            child: Column(
              children: [
                os_svg(
                  path: "lib/img/empty.svg",
                  size: 200,
                ),
                Text(
                  widget.txt ?? "没有数据",
                  style: TextStyle(
                    color: os_deep_grey,
                  ),
                ),
              ],
            ),
          )
        : Container());
  }
}
