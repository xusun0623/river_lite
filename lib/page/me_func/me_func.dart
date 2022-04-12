import 'package:flutter/material.dart';
import 'package:offer_show/asset/svg.dart';

class MeFunc extends StatefulWidget {
  int type;
  MeFunc({
    Key key,
    this.type,
  }) : super(key: key);

  @override
  _MeFuncState createState() => _MeFuncState();
}

class _MeFuncState extends State<MeFunc> {
  _getData() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF3F3F3),
        foregroundColor: Color(0xFF505050),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left_rounded,
            color: Color(0xFF505050),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Color(0xFFF3F3F3),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          MeFuncHead(type: widget.type),
          Center(
            child: Container(
              child: Text(widget.type.toString()),
            ),
          ),
        ],
      ),
    );
  }
}

class MeFuncHead extends StatefulWidget {
  int type;
  MeFuncHead({
    Key key,
    this.type,
  }) : super(key: key);

  @override
  State<MeFuncHead> createState() => _MeFuncHeadState();
}

class _MeFuncHeadState extends State<MeFuncHead> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 35, vertical: 60),
      child: Row(
        children: [
          Hero(
            tag: "lib/img/me/btn${widget.type}.svg",
            child: Material(
              color: Colors.transparent,
              child: os_svg(
                path: "lib/img/me/btn${widget.type}.svg",
                width: 50,
                height: 50,
              ),
            ),
          ),
          Container(width: 10),
          Hero(
            tag: ["", "收藏", "我的发表", "我的回复", "浏览历史", "草稿箱"][widget.type],
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 200,
                child: Text(
                  ["", "收藏", "我的发表", "我的回复", "浏览历史", "草稿箱"][widget.type],
                  style: TextStyle(
                    fontSize: 22,
                    color: Color(0xFF505050),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
