import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offer_show/asset/bigScreen.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/home_desktop_mode.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/asset/time.dart';
import 'package:offer_show/asset/vibrate.dart';
import 'package:offer_show/components/empty.dart';
import 'package:offer_show/components/newNaviBar.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/components/totop.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class MsgThree extends StatefulWidget {
  int? type; //0-@我 1-回复 2-通知
  MsgThree({
    Key? key,
    this.type,
  }) : super(key: key);

  @override
  _MsgThreeState createState() => _MsgThreeState();
}

class _MsgThreeState extends State<MsgThree> {
  List<Color> colors = [
    Color(0xFF717DFE),
    Color(0xFF2FCC7E),
    Color(0xFFFF9F23)
  ];
  List<String> titles = ["@我", "回复", "通知"];
  List? datas = [];
  List? lists = [];
  ScrollController _scrollController = new ScrollController();
  bool vibrate = false;
  bool? load_done = false;
  bool loading = false;
  bool showBackToTop = false;

  _getData() async {
    if (widget.type == 0 || widget.type == 1) {
      var tmp = await Api().message_notifylist({
        "type": ["at", "post"][widget.type!],
        "page": 1,
        "pageSize": 10,
      });
      if (tmp != null &&
          tmp["rs"] != null &&
          tmp["rs"] != 0 &&
          tmp["body"] != null &&
          tmp["body"]["data"] != null) {
        setState(() {
          datas = tmp["body"]["data"];
          if (tmp["list"] != null) lists = tmp["list"];
          if (datas != null && datas!.length != 0) {
            load_done = datas!.length % 10 != 0 || datas!.length == 0;
          } else {
            load_done = true;
          }
        });
      } else {
        datas = [];
        lists = [];
        load_done = true;
        setState(() {});
      }
    } else {
      var tmp = await Api().message_notifylistex({
        "type": "system",
        "page": 1,
        "pageSize": 10,
      });
      if (tmp != null &&
          tmp["rs"] != 0 &&
          tmp["body"] != null &&
          tmp["body"]["data"] != null) {
        setState(() {
          datas = tmp["body"]["data"];
          load_done = datas!.length % 10 != 0 || datas!.length == 0;
        });
      } else {
        datas = [];
        lists = [];
        load_done = true;
        setState(() {});
      }
    }
  }

  _getMore() async {
    if (widget.type == 0 || widget.type == 1) {
      var tmp = await Api().message_notifylist({
        "type": ["at", "post"][widget.type!],
        "page": (datas!.length / 10 + 1).ceil(),
        "pageSize": 10,
      });
      if (tmp != null && tmp["body"] != null && tmp["body"]["data"] != null) {
        setState(() {
          datas!.addAll(tmp["body"]["data"]);
          if (tmp["list"] != null) lists!.addAll(tmp["list"]);
          load_done = tmp["body"]["data"].length < 10;
        });
      } else {
        datas = [];
        lists = [];
        load_done = true;
        setState(() {});
      }
    } else {
      var tmp = await Api().message_notifylistex({
        "type": "system",
        "page": (datas!.length / 10 + 1).ceil(),
        "pageSize": 10,
      });
      if (tmp != null && tmp["body"] != null && tmp["body"]["data"] != null) {
        setState(() {
          datas!.addAll(tmp["body"]["data"]);
          load_done = tmp["body"]["data"].length < 10;
        });
      } else {
        datas = [];
        lists = [];
        load_done = true;
        setState(() {});
      }
    }
  }

  List<Widget> _buildCont() {
    List<Widget> tmp = [];
    tmp.add(Container(height: 10));
    if (widget.type == 0 || widget.type == 1) {
      //@我 回复
      if (lists!.length != 0) {
        for (int i = 0; i < datas!.length; i++) {
          if (i < datas!.length && i < lists!.length) {
            tmp.add(Padding(
              padding: const EdgeInsets.all(8.0),
              child: ResponsiveWidget(
                child: ForumCard(data: datas![i], forum: lists![i]),
              ),
            ));
          }
        }
      }
    } else {
      //系统通知
      for (int i = 0; i < datas!.length; i++) {
        tmp.add(ResponsiveWidget(child: SysNoti(data: datas![i])));
      }
    }
    if (datas!.length == 0 && load_done!) {
      tmp.add(Empty(
        txt: "这里是一颗空的星球",
      ));
    }
    if (!load_done!) tmp.add(BottomLoading(color: Colors.transparent));
    if (datas!.length < 6) {
      tmp.add(Container(
        height: (6 - datas!.length) * 100.0,
      ));
    }
    tmp.add(Container(height: 10));
    return tmp;
  }

  @override
  void initState() {
    _getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels > 1000 && !showBackToTop) {
        setState(() {
          showBackToTop = true;
        });
      }
      if (_scrollController.position.pixels < 1000 && showBackToTop) {
        setState(() {
          showBackToTop = false;
        });
      }
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMore();
      }
      if (_scrollController.position.pixels < -100) {
        if (!vibrate) {
          vibrate = true; //不允许再震动
          XSVibrate();
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
    return Baaaar(
      hideLogo: true,
      color: Provider.of<ColorProvider>(context).isDark
          ? os_dark_back
          : colors[widget.type!],
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Provider.of<ColorProvider>(context).isDark
              ? os_dark_back
              : colors[widget.type!],
          backgroundColor: Provider.of<ColorProvider>(context).isDark
              ? os_dark_back
              : colors[widget.type!],
          foregroundColor: os_white,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          elevation: 0,
          leading: BackIcon(),
        ),
        body: Container(
          color: Provider.of<ColorProvider>(context).isDark
              ? os_dark_back
              : colors[widget.type!],
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Head(titles: titles, widget: widget),
              Positioned(
                top: 60,
                child: Container(
                  width: MediaQuery.of(context).size.width - 2 * os_edge,
                  height: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      125,
                  decoration: BoxDecoration(
                    color: Provider.of<ColorProvider>(context).isDark
                        ? os_light_dark_card
                        : os_white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: os_edge),
                  child: RefreshIndicator(
                    color: colors[widget.type!],
                    onRefresh: () async {
                      return await _getData();
                    },
                    child: BackToTop(
                      color: colors[widget.type!],
                      show: showBackToTop,
                      bottom: 80,
                      controller: _scrollController,
                      animation: true,
                      child: ListView(
                        controller: _scrollController,
                        //physics: BouncingScrollPhysics(),
                        children: _buildCont(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SysNoti extends StatefulWidget {
  Map? data;
  SysNoti({
    Key? key,
    this.data,
  }) : super(key: key);

  @override
  State<SysNoti> createState() => _SysNotiState();
}

class _SysNotiState extends State<SysNoti> {
  double headImgSize = 0;
  @override
  Widget build(BuildContext context) {
    return myInkWell(
      color: Colors.transparent,
      radius: 0,
      widget: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 10),
            Container(
              width: MediaQuery.of(context).size.width -
                  (isDesktop() ? (MinusSpace(context)) : 0) -
                  headImgSize -
                  64,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.data!["user_name"],
                          style: TextStyle(
                            fontSize: 16,
                            color: Provider.of<ColorProvider>(context).isDark
                                ? os_dark_dark_white
                                : Color(0xFF000000),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              RelativeDateFormat.format(
                                DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(widget.data!["replied_date"]),
                                ),
                              ),
                              style: TextStyle(
                                color:
                                    Provider.of<ColorProvider>(context).isDark
                                        ? os_deep_grey
                                        : Color(0xFFCCCCCC),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(height: 5),
                  Container(
                    width: MediaQuery.of(context).size.width - headImgSize - 90,
                    child: Text(
                      widget.data!["note"].toString().trim(),
                      style: TextStyle(
                        color: Color(0xFFA0A0A0),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ForumCard extends StatefulWidget {
  Map? data;
  Map? forum;
  ForumCard({
    Key? key,
    this.data,
    this.forum,
  }) : super(key: key);

  @override
  State<ForumCard> createState() => _ForumCardState();
}

class _ForumCardState extends State<ForumCard> {
  double headImgSize = 40;

  @override
  Widget build(BuildContext context) {
    return myInkWell(
      radius: 0,
      tap: () {
        Navigator.pushNamed(
          context,
          "/topic_detail",
          arguments: widget.forum!["topic_id"],
        );
      },
      color: Colors.transparent,
      widget: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: headImgSize,
              height: headImgSize,
              decoration: BoxDecoration(
                color: os_grey,
                borderRadius: BorderRadius.all(Radius.circular(100)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                child: CachedNetworkImage(
                  imageUrl: widget.data!["authorAvatar"] ??
                      "https://t7.baidu.com/it/u=1595072465,3644073269&fm=193&f=GIF",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(width: 10),
            Container(
              width: MediaQuery.of(context).size.width -
                  (isDesktop() ? (MinusSpace(context)) + 12 : 0) -
                  headImgSize -
                  64 -
                  15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.data!["author"] ?? "",
                        style: TextStyle(
                          fontSize: 16,
                          color: Provider.of<ColorProvider>(context).isDark
                              ? os_dark_dark_white
                              : Color(0xFF000000),
                        ),
                      ),
                      os_svg(
                        path: "lib/img/msg_card_right.svg",
                        width: 6,
                        height: 11,
                      )
                    ],
                  ),
                  Container(height: 5),
                  (widget.forum!["topic_subject"] ?? "").toString().trim() == ""
                      ? Container()
                      : Container(
                          decoration: BoxDecoration(
                            color: Provider.of<ColorProvider>(context).isDark
                                ? Color(0x11FFFFFF)
                                : os_black_opa_opa,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          child: Column(children: [
                            Container(
                              width: MediaQuery.of(context).size.width -
                                  headImgSize -
                                  (isDesktop() ? (MinusSpace(context)) : 0) -
                                  90,
                              child: Text(
                                widget.forum!["topic_subject"]
                                    .toString()
                                    .trim(),
                                style: TextStyle(
                                  color: Color(0xFFA0A0A0),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ]),
                        ),
                  Container(height: 5),
                  Container(
                    width: MediaQuery.of(context).size.width -
                        headImgSize -
                        (isDesktop() ? (MinusSpace(context)) : 0) -
                        90,
                    child: Text(
                      (widget.forum!["reply_content"] ?? "").toString().trim() +
                          ((widget.forum!["reply_content"] ?? "")
                                      .toString()
                                      .trim()
                                      .length ==
                                  0
                              ? "查看图片"
                              : "") +
                          " · " +
                          RelativeDateFormat.format(
                            DateTime.fromMillisecondsSinceEpoch(
                              int.parse(widget.forum!["replied_date"]),
                            ),
                          ),
                      style: TextStyle(
                        color: Provider.of<ColorProvider>(context).isDark
                            ? os_dark_dark_white
                            : Color.fromARGB(255, 57, 57, 57),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BackIcon extends StatelessWidget {
  const BackIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(
        Icons.arrow_back_ios_new_rounded,
        size: 16,
        color: os_white,
      ),
    );
  }
}

class Head extends StatelessWidget {
  const Head({
    Key? key,
    required this.titles,
    required this.widget,
  }) : super(key: key);

  final List<String> titles;
  final MsgThree widget;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: "${titles[widget.type!]}",
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 100,
                  child: Text(
                    "   ${titles[widget.type!]}",
                    style: TextStyle(
                      color: Provider.of<ColorProvider>(context).isDark
                          ? os_dark_white
                          : os_white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: Provider.of<ColorProvider>(context).isDark ? 0 : 1,
              child: os_svg(
                path: "lib/page/msg_three/${widget.type! + 1}.svg",
                width: 80,
                height: 80,
              ),
            )
          ],
        ),
      ),
    );
  }
}
