import 'package:flutter/material.dart';
import 'package:offer_show/asset/xs_textstyle.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class Empty extends StatefulWidget {
  String? txt;
  Empty({
    Key? key,
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
          Opacity(
            opacity: Provider.of<ColorProvider>(context).isDark ? 0.4 : 1,
            child: Image(
              image: AssetImage(Provider.of<ColorProvider>(context).isDark
                  ? "lib/img/empty_dark.png"
                  : "lib/img/empty.png"),
              width: Provider.of<ColorProvider>(context).isDark ? 60 : 200,
              height: Provider.of<ColorProvider>(context).isDark ? 60 : 200,
            ),
          ),
          Provider.of<ColorProvider>(context).isDark
              ? Container(height: 20)
              : Container(),
          Text(
            widget.txt ?? "暂无评论, 快去抢沙发吧",
            style: XSTextStyle(
              context: context,
              fontSize: 14,
              color: Color(0xFFBBBBBB),
            ),
          ),
        ],
      ),
    );
  }
}
