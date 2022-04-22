import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/outer/cached_network_image/cached_image_widget.dart';
import 'package:offer_show/util/interface.dart';

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
      setState(() {});
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
      body: RefreshIndicator(
        color: os_deep_blue,
        onRefresh: () async {
          return await _getData();
        },
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            data == null
                ? MeInfoHead(
                    head: null,
                    name: "请登陆",
                    score: 0,
                  )
                : MeInfoHead(
                    head: data["icon"],
                    name: data["name"],
                    score: data["score"],
                  ),
            MeFiveBtns(),
            Container(height: 17.5),
            MeListGroup(),
            Container(height: 100),
            MeBottom(),
            Container(height: 80),
          ],
        ),
      ),
    );
  }
}

class MeBottom extends StatefulWidget {
  MeBottom({Key key}) : super(key: key);

  @override
  State<MeBottom> createState() => _MeBottomState();
}

class _MeBottomState extends State<MeBottom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CupertinoButton(
          padding: EdgeInsets.all(0),
          onPressed: () {},
          child: Container(
            padding:
                EdgeInsets.only(left: 17.5, right: 17.5, top: 13, bottom: 15),
            child: Text(
              "@UESTC 河畔Lite",
              style: TextStyle(color: Color(0xFFCCCCCC), fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }
}

class MeListGroup extends StatefulWidget {
  MeListGroup({Key key}) : super(key: key);

  @override
  State<MeListGroup> createState() => _MeListGroupState();
}

class _MeListGroupState extends State<MeListGroup> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MeList(txt: "水滴相关"),
        MeList(txt: "在线用户"),
        MeList(txt: "意见&Bug反馈"),
        MeList(txt: "应用设置"),
        MeList(txt: "关于"),
      ],
    );
  }
}

class MeList extends StatefulWidget {
  String txt;
  MeList({
    Key key,
    this.txt,
  }) : super(key: key);

  @override
  State<MeList> createState() => _MeListState();
}

class _MeListState extends State<MeList> {
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      pressedOpacity: 0.6,
      padding: EdgeInsets.all(0),
      onPressed: () {
        print("hhhhh");
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 27.5, vertical: 18.5),
        color: os_white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.txt ?? "水滴相关",
              style: TextStyle(
                color: Color(0xFF5C5C5C),
                fontSize: 16,
              ),
            ),
            os_svg(
              path: "lib/img/me_arrow_right.svg",
              width: 7,
              height: 14,
            ),
          ],
        ),
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
            txt: "浏览历史",
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
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              blurRadius: 3,
              spreadRadius: 1,
              offset: Offset(1.5, 1.5),
            ),
          ]),
      child: myInkWell(
        tap: () {
          Navigator.pushNamed(context, "/me_func", arguments: widget.type);
        },
        radius: 20,
        color: os_white,
        widget: Container(
          width: 60 + (widget.txt ?? "收藏").length * 14.0,
          padding: EdgeInsets.symmetric(vertical: 12.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: widget.img ?? "lib/img/me/btn1.svg",
                child: Material(
                  color: Colors.transparent,
                  child: os_svg(
                    path: widget.img ?? "lib/img/me/btn1.svg",
                    width: 32,
                    height: 32,
                  ),
                ),
              ),
              Hero(
                tag: widget.txt ?? "收藏",
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    widget.txt ?? "收藏",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF505050),
                    ),
                  ),
                ),
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
    return GestureDetector(
      onTap: () {
        if (widget.head == null) {
          print("前往授权登陆");
        } else {
          Navigator.pushNamed(
            context,
            "/person_center",
            arguments: {"uid": 221788, "isMe": true},
          );
        }
      },
      child: Container(
        color: os_white,
        padding: EdgeInsets.only(left: 25, right: 25, bottom: 40, top: 50),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                child: widget.head == null
                    ? Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: os_grey,
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        child: os_svg(
                          path: "lib/img/anoy.svg",
                          width: 60,
                          height: 60,
                        ),
                      )
                    : CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: os_grey,
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                          ),
                        ),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
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
      ),
    );
  }
}
