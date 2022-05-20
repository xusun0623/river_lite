import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/outer/cached_network_image/cached_image_widget.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Me extends StatefulWidget {
  Me({Key key}) : super(key: key);

  @override
  _MeState createState() => _MeState();
}

class _MeState extends State<Me> {
  Map data;
  ScrollController _scrollController = new ScrollController();
  _getData() async {
    var tmp = await Api().user_userinfo({});
    if (tmp != null && tmp["rs"] != 0 && tmp["body"] != null) {
      UserInfoProvider provider =
          Provider.of<UserInfoProvider>(context, listen: false);
      provider.data = tmp;
      provider.refresh();
    } else {
      UserInfoProvider provider =
          Provider.of<UserInfoProvider>(context, listen: false);
      var arr_txt = await getStorage(key: "myinfo", initData: "");
      if (arr_txt != "") {
        provider.data = jsonDecode(arr_txt);
        provider.refresh();
      }
    }
  }

  bool vibrate = false;

  @override
  void initState() {
    _getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels < -100) {
        if (!vibrate) {
          vibrate = true; //不允许再震动
          Vibrate.feedback(FeedbackType.impact);
        }
      }
      if (_scrollController.position.pixels >= 0) {
        vibrate = false; //允许震动
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserInfoProvider provider = Provider.of<UserInfoProvider>(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: Provider.of<ColorProvider>(context).isDark
            ? os_dark_back
            : os_white,
        foregroundColor: Provider.of<ColorProvider>(context).isDark
            ? os_dark_white
            : os_black,
        elevation: 0,
        actions: [
          // IconButton(
          //   onPressed: () {
          //     Provider.of<ColorProvider>(context, listen: false).isDark =
          //         !Provider.of<ColorProvider>(context, listen: false).isDark;
          //     Provider.of<ColorProvider>(context, listen: false).switchMode();
          //     Provider.of<ColorProvider>(context, listen: false).refresh();
          //   },
          //   icon: Icon(
          //     Provider.of<ColorProvider>(context, listen: false).isDark
          //         ? Icons.light_mode
          //         : Icons.dark_mode,
          //     color: Provider.of<ColorProvider>(context, listen: false).isDark
          //         ? os_middle_grey
          //         : os_middle_grey,
          //   ),
          // ),
        ],
      ),
      backgroundColor:
          Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_white,
      body: RefreshIndicator(
        color: os_deep_blue,
        onRefresh: () async {
          return await _getData();
        },
        child: ListView(
          controller: _scrollController,
          physics: BouncingScrollPhysics(),
          children: [
            provider.data == null
                ? MeInfoHead(
                    head: null,
                    name: "请登陆",
                    score: 0,
                  )
                : MeInfoHead(
                    head: provider.data["icon"] ?? provider.data["avatar"],
                    name: provider.data["name"] ?? provider.data["userName"],
                    score: provider.data["score"],
                  ),
            MeFiveBtns(),
            Container(height: 17.5),
            MeListGroup(),
            Container(height: MediaQuery.of(context).size.height / 2),
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
          onPressed: () {
            UserInfoProvider provider =
                Provider.of<UserInfoProvider>(context, listen: false);
            provider.data = null;
            provider.refresh();
            setStorage(key: "myinfo", value: "");
            setStorage(key: "topic_like", value: "");
            setStorage(key: "history", value: "[]");
            setStorage(key: "draft", value: "[]");
            setStorage(key: "search-history", value: "[]");
            setState(() {});
          },
          child: Container(
            padding:
                EdgeInsets.only(left: 17.5, right: 17.5, top: 13, bottom: 15),
            child: Text(
              "退出登录 >",
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
        // MeList(txt: "应用设置", index: 0),
        MeList(txt: "应用设置", index: 1),
        MeList(txt: "意见&Bug反馈", index: 2),
        MeList(txt: "拉黑&黑名单", index: 4),
        MeList(txt: "关于", index: 3),
      ],
    );
  }
}

class MeList extends StatefulWidget {
  String txt;
  int index;
  MeList({
    Key key,
    this.txt,
    this.index,
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
        if (widget.index == 0) {
          Navigator.pushNamed(context, "/setting");
        }
        if (widget.index == 1) {
          Navigator.pushNamed(context, "/account");
        }
        if (widget.index == 2) {
          launch("https://www.wjx.cn/vj/mzgzO5S.aspx");
        }
        if (widget.index == 3) {
          Navigator.pushNamed(context, "/about");
        }
        if (widget.index == 4) {
          Navigator.pushNamed(context, "/black_list");
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 27.5, vertical: 18.5),
        color: Provider.of<ColorProvider>(context).isDark
            ? os_dark_back
            : os_white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.txt ?? "水滴相关",
              style: TextStyle(
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_dark_white
                    : Color(0xFF5C5C5C),
                fontSize: 16,
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Provider.of<ColorProvider>(context).isDark
                  ? os_dark_dark_white
                  : Color(0xFFD3D3D3),
              size: 24,
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
        tap: () async {
          String myinfo_txt = await getStorage(key: "myinfo", initData: "");
          if (myinfo_txt != "" && widget.type <= 3) {
            Map myinfo = jsonDecode(myinfo_txt);
            Navigator.pushNamed(context, "/me_func", arguments: {
              "type": widget.type,
              "uid": myinfo["uid"],
            });
          } else
            Navigator.pushNamed(context, "/me_func", arguments: {
              "type": widget.type,
            });
        },
        radius: 20,
        color: Provider.of<ColorProvider>(context).isDark
            ? os_dark_card
            : os_white,
        widget: Container(
          width: 60 + (widget.txt ?? "收藏").length * 14.0,
          padding: EdgeInsets.symmetric(vertical: 12.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(
              color: Provider.of<ColorProvider>(context).isDark
                  ? Color(0x11FFFFFF)
                  : os_white,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag:
                    "lib/img/${Provider.of<ColorProvider>(context).isDark ? "me_dark" : "me"}/btn${widget.type}.svg",
                child: Material(
                  color: Colors.transparent,
                  child: os_svg(
                    path:
                        "lib/img/${Provider.of<ColorProvider>(context).isDark ? "me_dark" : "me"}/btn${widget.type}.svg",
                    width: 32,
                    height: 32,
                  ),
                ),
              ),
              Hero(
                tag: widget.txt,
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    widget.txt,
                    style: TextStyle(
                      fontSize: 15,
                      color: Provider.of<ColorProvider>(context).isDark
                          ? os_dark_white
                          : Color(0xFF505050),
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
      onTap: () async {
        if (widget.head == null) {
          Navigator.pushNamed(context, "/login", arguments: 0);
        } else {
          String myinfo_txt = await getStorage(key: "myinfo", initData: "");
          Map myinfo = jsonDecode(myinfo_txt);
          Navigator.pushNamed(
            context,
            "/person_center",
            arguments: {"uid": myinfo["uid"], "isMe": true},
          );
        }
      },
      child: Container(
        color: Provider.of<ColorProvider>(context).isDark
            ? os_dark_back
            : os_white,
        padding: EdgeInsets.only(left: 25, right: 25, bottom: 40, top: 0),
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
                            color: Provider.of<ColorProvider>(context).isDark
                                ? os_deep_grey
                                : os_grey,
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
                    color: Provider.of<ColorProvider>(context).isDark
                        ? os_dark_white
                        : os_black,
                  ),
                ),
                Container(height: 5),
                Row(
                  children: [
                    Text("Lv.${_getLevel()}",
                        style: TextStyle(
                            color: Provider.of<ColorProvider>(context).isDark
                                ? os_dark_white
                                : Color(0xFF707070))),
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
