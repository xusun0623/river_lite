import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class Empty extends StatefulWidget {
  String txt;
  Empty({
    Key key,
    this.txt,
  }) : super(key: key);

  @override
  _EmptyState createState() => _EmptyState();
}

class _EmptyState extends State<Empty> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Provider.of<ColorProvider>(context).isDark
              ? Container()
              : Image(
                  image: AssetImage("lib/img/empty.png"),
                  width: 200,
                  height: 200,
                ),
          Provider.of<ColorProvider>(context).isDark
              ? Container(height: 20)
              : Container(),
          Text(
            widget.txt ?? "暂无评论, 快去抢沙发吧~",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFBBBBBB),
            ),
          ),
        ],
      ),
    );
  }
}
