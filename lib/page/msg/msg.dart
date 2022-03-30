import 'dart:ffi';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/asset/time.dart';
import 'package:offer_show/components/BottomTip.dart';
import 'package:offer_show/components/empty.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/components/totop.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/util/interface.dart';

import '../../outer/cached_network_image/cached_image_widget.dart';

class Msg extends StatefulWidget {
  Msg({
    Key key,
  }) : super(key: key);

  @override
  _MsgState createState() => _MsgState();
}

class _MsgState extends State<Msg> {
  Map msg;
  List pmMsgArr = [];
  bool vibrate = false;
  ScrollController _scrollController = new ScrollController();
  bool load_done = false;
  bool loading = false;
  bool showBackToTop = false;

  List<Widget> _buildPMMsg() {
    List<Widget> tmp = [];
    pmMsgArr.forEach((element) {
      tmp.add(
        MsgCard(
          data: element,
        ),
      );
    });
    return tmp;
  }

  _getPm() async {
    var tmp = await Api().message_pmsessionlist({
      "json": {
        "page": 1,
        "pageSize": 10,
      }.toString()
    });
    if (tmp != null && tmp["body"] != null) {
      pmMsgArr = tmp["body"]["list"];
      load_done = tmp["body"]["list"].length < 10;
    }
    setState(() {});
  }

  _getMore() async {
    if (load_done || loading) return;
    loading = true;
    var tmp = await Api().message_pmsessionlist({
      "json": {
        "page": (pmMsgArr.length / 10 + 1).toInt(),
        "pageSize": 10,
      }.toString()
    });
    if (tmp != null &&
        tmp["body"] != null &&
        int.parse(tmp["body"]["list"][0]["lastDateline"]) <
            int.parse(pmMsgArr[pmMsgArr.length - 1]["lastDateline"])) {
      pmMsgArr.addAll(tmp["body"]["list"]);
      load_done = tmp["body"]["list"].length < 10;
    } else {
      load_done = true;
    }
    loading = false;
    setState(() {});
  }

  _getData() async {
    var data = await Api().message_heart({});
    if (data != null && data["body"] != null) {
      setState(() {
        msg = data["body"];
      });
    }
  }

  @override
  void initState() {
    _getData();
    _getPm();
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
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: os_white,
        foregroundColor: os_black,
        elevation: 0,
        title: Text(
          "消息",
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: os_white,
        child: RefreshIndicator(
          onRefresh: () async {
            await _getData();
            await _getPm();
            return;
          },
          child: BackToTop(
            show: showBackToTop,
            controller: _scrollController,
            animation: true,
            child: ListView(
              physics: BouncingScrollPhysics(),
              controller: _scrollController,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7),
                  child: msg == null
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ColorBtn(
                              path: "lib/img/msg/@.svg",
                              title: "@我",
                              data: msg["atMeInfo"],
                            ),
                            ColorBtn(
                              path: "lib/img/msg/reply.svg",
                              title: "回复",
                              data: msg["replyInfo"],
                            ),
                            ColorBtn(
                              path: "lib/img/msg/noti.svg",
                              title: "通知",
                              data: msg["systemInfo"],
                            ),
                          ],
                        ),
                ),
                pmMsgArr.length == 0
                    ? Container()
                    : BottomTip(
                        top: 25,
                        bottom: 5,
                        txt: "- 私信内容 -",
                      ),
                pmMsgArr.length != 0
                    ? Container()
                    : Empty(
                        txt: "暂无私信内容",
                      ),
                Column(
                  children: _buildPMMsg(),
                ),
                load_done ? Container() : BottomLoading(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ColorBtn extends StatefulWidget {
  Map data;
  String path;
  String title;
  ColorBtn({
    Key key,
    this.data,
    this.path,
    this.title,
  }) : super(key: key);

  @override
  State<ColorBtn> createState() => _ColorBtnState();
}

class _ColorBtnState extends State<ColorBtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          os_svg(
            path: widget.path,
            width: 108,
            height: 51,
          ),
          Positioned(
            top: 14,
            left: 20,
            child: Badge(
              position: BadgePosition(top: -12, end: -12),
              showBadge: widget.data["count"] != 0,
              badgeContent: Text(
                widget.data["count"].toString(),
                style: TextStyle(
                  color: os_white,
                  fontSize: 10,
                ),
              ),
              child: Container(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: os_white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MsgCard extends StatefulWidget {
  Map data;
  bool isNew;
  MsgCard({
    Key key,
    this.data,
    this.isNew,
  }) : super(key: key);

  @override
  State<MsgCard> createState() => _MsgCardState();
}

class _MsgCardState extends State<MsgCard> {
  double headImgSize = 40;
  @override
  Widget build(BuildContext context) {
    return myInkWell(
      radius: 0,
      color: Colors.transparent,
      widget: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Badge(
              showBadge: widget.data["isNew"] == 0 ? false : true,
              position: BadgePosition.topEnd(top: -2, end: -2),
              child: Container(
                width: headImgSize,
                height: headImgSize,
                decoration: BoxDecoration(
                  color: os_grey,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  child: CachedNetworkImage(
                    imageUrl: widget.data["toUserAvatar"],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(width: 10),
            Container(
              width: MediaQuery.of(context).size.width - headImgSize - 42,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.data["toUserName"],
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF000000),
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
                  Text(
                    widget.data["lastSummary"] +
                        " · " +
                        RelativeDateFormat.format(
                          DateTime.fromMillisecondsSinceEpoch(
                            int.parse(widget.data["lastDateline"]),
                          ),
                        ).toString(),
                    style: TextStyle(
                      color: Color(0xFFA0A0A0),
                      fontSize: 14,
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
