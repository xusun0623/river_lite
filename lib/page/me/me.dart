import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/outer/cached_network_image/cached_image_widget.dart';
import 'package:offer_show/util/interface.dart';

//lv1 - 0
//lv2 - 30
//lv3 - 100
//lv4 - 500
//lv5 - 800
//lv6 - 1200
//lv7 - 2000
//lv8 - 3000
//lv9 - 4500
//lv10 - 7000
//lv11 - 10000
//lv12 - 15000
//lv13 - 30000

class Me extends StatefulWidget {
  Me({Key key}) : super(key: key);

  @override
  _MeState createState() => _MeState();
}

class _MeState extends State<Me> {
  Map data;
  _getData() async {
    var tmp = await Api().user_userinfo({});
    if (tmp != null && tmp["body"] != null) {
      data = tmp;
    }
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: os_white,
        foregroundColor: os_black,
        elevation: 0,
      ),
      backgroundColor: os_white,
      body: data == null
          ? Container()
          : ListView(
              children: [
                MeInfoHead(
                  head: data["icon"],
                  name: data["name"],
                  score: data["score"],
                ),
                MeFiveBtns(),
              ],
            ),
    );
  }
}

class MeFiveBtns extends StatefulWidget {
  MeFiveBtns({Key key}) : super(key: key);

  @override
  State<MeFiveBtns> createState() => _MeFiveBtnsState();
}

class _MeFiveBtnsState extends State<MeFiveBtns> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Wrap(
        children: [
          MeBtnHero(
            img: "lib/img/me/btn1.svg",
            txt: "收藏",
            type: 1,
          ),
          MeBtnHero(
            img: "lib/img/me/btn2.svg",
            txt: "我的发表",
            type: 2,
          ),
          MeBtnHero(
            img: "lib/img/me/btn3.svg",
            txt: "我的回复",
            type: 3,
          ),
          MeBtnHero(
            img: "lib/img/me/btn4.svg",
            txt: "足迹",
            type: 4,
          ),
          MeBtnHero(
            img: "lib/img/me/btn5.svg",
            txt: "草稿箱",
            type: 5,
          ),
        ],
      ),
    );
  }
}

class MeBtnHero extends StatefulWidget {
  String img;
  String txt;
  int type;

  MeBtnHero({
    Key key,
    this.img,
    this.txt,
    this.type,
  }) : super(key: key);

  @override
  State<MeBtnHero> createState() => _MeBtnHeroState();
}

class _MeBtnHeroState extends State<MeBtnHero> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: myInkWell(
        radius: 17,
        color: Color(0xFFF3F3F3),
        widget: Container(
          width: 64 + (widget.txt ?? "收藏").length * 14.0,
          padding: EdgeInsets.symmetric(vertical: 7.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              os_svg(
                path: widget.img ?? "lib/img/me/btn1.svg",
                width: 33.5,
                height: 33.5,
              ),
              Text(
                widget.txt ?? "收藏",
                style: TextStyle(fontSize: 14),
              ),
              Container(width: 5),
            ],
          ),
        ),
      ),
    );
  }
}

class MeInfoHead extends StatefulWidget {
  String head;
  String name;
  int score;
  MeInfoHead({
    Key key,
    @required this.head,
    @required this.name,
    @required this.score,
  }) : super(key: key);

  @override
  State<MeInfoHead> createState() => MeInfo_HeadState();
}

class MeInfo_HeadState extends State<MeInfoHead> {
  List map_tmp = [
    0,
    30,
    100,
    500,
    800,
    1200,
    2000,
    3000,
    4500,
    7000,
    10000,
    15000,
    30000,
  ];

  _getLevel() {
    var score = widget.score;
    for (int i = 0; i < map_tmp.length; i++) {
      if (map_tmp[i] > score) {
        return i;
      }
    }
  }

  _getRate() {
    var score = widget.score;
    for (int i = 0; i < map_tmp.length; i++) {
      if (map_tmp[i] > score) {
        return score / map_tmp[i];
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: os_white,
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              child: CachedNetworkImage(
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                imageUrl: widget.head,
              ),
            ),
          ),
          Container(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(height: 5),
              Row(
                children: [
                  Text("Lv.${_getLevel()}",
                      style: TextStyle(color: Color(0xFF707070))),
                  Container(width: 5),
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 200,
                        height: 7,
                        decoration: BoxDecoration(
                          color: Color(0xFFE3E3E3),
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                      ),
                      Positioned(
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 200) *
                              _getRate(),
                          height: 7,
                          decoration: BoxDecoration(
                            color: os_deep_blue,
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
