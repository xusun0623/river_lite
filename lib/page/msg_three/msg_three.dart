import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/util/interface.dart';

import '../../asset/time.dart';
import '../../outer/cached_network_image/cached_image_widget.dart';

class MsgThree extends StatefulWidget {
  int type; //0-@我 1-回复 2-通知
  MsgThree({
    Key key,
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
  Map data = {
    "dateline": "1647182840000",
    "type": "at",
    "note": "xusun000 在主题 水水 中提到了您水水 @北冥小鱼 \n🥰🥰现在去看看。",
    "fromId": 1923366,
    "fromIdType": "at",
    "author": "xusun000",
    "authorId": 221788,
    "authorAvatar":
        "https://bbs.uestc.edu.cn/uc_server/avatar.php?uid=221788&size=middle",
    "actions": []
  };
  List datas = [];
  List lists = [];
  ScrollController _scrollController = new ScrollController();
  bool vibrate = false;
  bool load_done = false;
  bool loading = false;

  _getData() async {
    if (widget.type == 0 || widget.type == 1) {
      var tmp = await Api().message_notifylist({
        "type": ["at", "post"][widget.type],
        "page": 1,
        "pageSize": 10,
      });
      if (tmp != null && tmp["body"] != null && tmp["body"]["data"] != null) {
        setState(() {
          datas = tmp["body"]["data"];
          lists = tmp["list"];
          load_done = datas.length % 10 != 0;
        });
      }
    }
  }

  _getMore() async {
    if (widget.type == 0 || widget.type == 1) {
      var tmp = await Api().message_notifylist({
        "type": ["at", "post"][widget.type],
        "page": (datas.length / 10 + 1).ceil(),
        "pageSize": 10,
      });
      if (tmp != null && tmp["body"] != null && tmp["body"]["data"] != null) {
        setState(() {
          datas.addAll(tmp["body"]["data"]);
          lists.addAll(tmp["list"]);
          load_done = tmp["body"]["data"].length < 10;
        });
      } else {
        setState(() {
          load_done = true;
        });
      }
    }
  }

  List<Widget> _buildCont() {
    List<Widget> tmp = [];
    tmp.add(Container(height: 10));
    for (int i = 0; i < datas.length; i++) {
      tmp.add(ForumCard(data: datas[i], topic_id: lists[i]["topic_id"]));
    }
    if (!load_done) tmp.add(BottomLoading(color: Colors.transparent));
    tmp.add(Container(height: 10));
    return tmp;
  }

  @override
  void initState() {
    _getData();
    _scrollController.addListener(() {
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
        backgroundColor: colors[widget.type],
        foregroundColor: os_white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0,
        leading: BackIcon(),
      ),
      body: Container(
        color: colors[widget.type],
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
                  color: os_white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                margin: EdgeInsets.symmetric(horizontal: os_edge),
                child: RefreshIndicator(
                  onRefresh: () async {
                    await _getData();
                    return;
                  },
                  child: ListView(
                    controller: _scrollController,
                    physics: BouncingScrollPhysics(),
                    children: _buildCont(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ForumCard extends StatefulWidget {
  Map data;
  int topic_id;
  ForumCard({
    Key key,
    this.data,
    this.topic_id,
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
          arguments: widget.topic_id,
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
                  imageUrl: widget.data["authorAvatar"],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(width: 10),
            Container(
              width: MediaQuery.of(context).size.width - headImgSize - 64,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.data["author"],
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
                  Container(
                    width: MediaQuery.of(context).size.width - headImgSize - 90,
                    child: Text(
                      widget.data["note"].toString().split("现在去看看。")[0] +
                          " · " +
                          RelativeDateFormat.format(
                            DateTime.fromMillisecondsSinceEpoch(
                              int.parse(widget.data["dateline"]),
                            ),
                          ).toString(),
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

class BackIcon extends StatelessWidget {
  const BackIcon({
    Key key,
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
      ),
    );
  }
}

class Head extends StatelessWidget {
  const Head({
    Key key,
    @required this.titles,
    @required this.widget,
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
            Text(
              "   ${titles[widget.type]}",
              style: TextStyle(
                color: os_white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            os_svg(
              path: "lib/page/msg_three/${widget.type + 1}.svg",
              width: 80,
              height: 80,
            )
          ],
        ),
      ),
    );
  }
}
