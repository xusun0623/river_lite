import 'package:flutter/material.dart';
import 'package:offer_show/asset/svg.dart';

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
          Image(
            image: AssetImage("lib/img/empty.png"),
            width: 200,
            height: 200,
          ),
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
