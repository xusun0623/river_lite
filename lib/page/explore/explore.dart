import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class Explore extends StatefulWidget {
  Explore({Key key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: os_white,
        elevation: 0,
        foregroundColor: os_black,
      ),
      backgroundColor: os_white,
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ExploreHead(),
          ExploreCard(index: 1),
          ExploreCard(index: 2),
          ExploreCard(index: 3),
          ExploreCard(index: 4),
          ExploreCard(index: 5),
          ExploreCard(index: 6),
          BottomBtns(),
          Container(height: 10),
        ],
      ),
    );
  }
}

class BottomBtns extends StatefulWidget {
  BottomBtns({Key key}) : super(key: key);

  @override
  State<BottomBtns> createState() => _BottomBtnsState();
}

class _BottomBtnsState extends State<BottomBtns> {
  List<Widget> _buildWidget() {
    List<Widget> tmp = [];
    for (int i = 1; i <= 5; i++) {
      tmp.add(Container(
        width: MediaQuery.of(context).size.width / 3,
        child: CupertinoButton(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12.5),
          child: Row(
            children: [
              os_svg(
                path: "lib/img/explore/bottom$i.svg",
                width: 35,
                height: 35,
              ),
              Text(
                ["校园地图", "校园VPN", "学校官网", "合成大河畔", "河畔Web版"][i - 1],
                style: TextStyle(
                  color: Color(0xFF5E5E5E),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          onPressed: () {
            List urls = [
              "https://gis.uestc.edu.cn/",
              "https://vpn.uestc.edu.cn/",
              "https://www.uestc.edu.cn/",
              "https://bbs.uestc.edu.cn/merge_qshp/",
              "https://bbs.uestc.edu.cn/",
            ];
            launch(urls[i - 1]);
          },
        ),
      ));
    }
    return tmp;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Wrap(
        children: _buildWidget(),
      ),
    );
  }
}

class ExploreCard extends StatefulWidget {
  int index;
  ExploreCard({
    Key key,
    this.index,
  }) : super(key: key);

  @override
  State<ExploreCard> createState() => _ExploreCardState();
}

class _ExploreCardState extends State<ExploreCard> {
  @override
  Widget build(BuildContext context) {
    return Bounce(
      onPressed: () {
        Navigator.pushNamed(
          context,
          "/explore_detail",
          arguments: widget.index,
        );
      },
      duration: Duration(milliseconds: 100),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: os_edge,
          vertical: 5,
        ),
        child: Hero(
          tag: "lib/img/explore/${widget.index}.png",
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Image.asset("lib/img/explore/${widget.index}.png"),
          ),
        ),
      ),
    );
  }
}

class ExploreHead extends StatefulWidget {
  const ExploreHead({Key key}) : super(key: key);

  @override
  State<ExploreHead> createState() => _ExploreHeadState();
}

class _ExploreHeadState extends State<ExploreHead> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: os_edge,
            right: os_edge,
            top: 30,
            bottom: 25,
          ),
          child: os_svg(
            path: "lib/img/explore/explore.svg",
            width: 220,
            height: 20,
          ),
        ),
      ],
    );
  }
}
