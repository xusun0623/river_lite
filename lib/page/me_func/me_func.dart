import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/home_desktop_mode.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/mouse_speed.dart';
import 'package:offer_show/asset/nowMode.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/asset/time.dart';
import 'package:offer_show/asset/xs_textstyle.dart';
import 'package:offer_show/components/empty.dart';
import 'package:offer_show/components/newNaviBar.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/components/topic.dart';
import 'package:offer_show/components/totop.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
import 'package:provider/provider.dart';

class MeFunc extends StatefulWidget {
  int type;
  int? uid;
  MeFunc({
    Key? key,
    required this.type,
    this.uid,
  }) : super(key: key);

  @override
  _MeFuncState createState() => _MeFuncState();
}

class _MeFuncState extends State<MeFunc> {
  List? data = [];
  bool load_done = false;
  bool loading = false;
  ScrollController _scrollController = new ScrollController();
  bool _showBackToTop = false;
  bool _showTopTitle = false;

  _getData() async {
    if (loading) return;
    loading = true;
    if (widget.type! <= 3) {
      //收藏、发表、回复
      var tmp = await Api().user_topiclist({
        "type": ["favorite", "topic", "reply"][widget.type! - 1],
        "uid": widget.uid,
        "page": 1,
        "pageSize": 10,
      });
      if (tmp != null && tmp["rs"] != 0 && tmp["list"] != null) {
        data = tmp["list"];
        load_done = data!.length % 10 != 0 || data!.length == 0;
        setState(() {});
      } else {
        load_done = true;
        setState(() {});
      }
    }
    if (widget.type == 4) {
      //浏览记录
      var arr_txt = await getStorage(key: "history", initData: "[]");
      data = jsonDecode(arr_txt);
      load_done = true;
      setState(() {});
    }
    if (widget.type == 5) {
      //草稿
      var arr_txt = await getStorage(key: "draft", initData: "[]");
      data = jsonDecode(arr_txt);
      load_done = true;
      setState(() {});
    }
    loading = false;
  }

  _getMore() async {
    if (loading) return;
    loading = true;
    if (load_done) return;
    if (widget.type! <= 3) {
      //收藏、发表、回复
      var tmp = await Api().user_topiclist({
        "type": ["favorite", "topic", "reply"][widget.type! - 1],
        "uid": widget.uid,
        "page": (data!.length / 10).ceil() + 1,
        "pageSize": 10,
      });
      if (tmp != null && tmp["rs"] != 0 && tmp["list"] != null) {
        data!.addAll(tmp["list"]);
        load_done = data!.length % 10 != 0;
        setState(() {});
      }
    }
    loading = false;
  }

  List<Widget> _buildCont() {
    List<Widget> tmp = [];
    tmp.add(ResponsiveWidget(child: MeFuncHead(type: widget.type)));
    if (widget.type == 5) {
      data!.forEach((element) {
        tmp.add(ResponsiveWidget(child: DraftCard(data: element)));
      });
    } else {
      data!.forEach((element) {
        tmp.add(ResponsiveWidget(
          child: FuncWidget(data: element, type: widget.type),
        ));
      });
    }
    if (data!.length == 0 && load_done) {
      tmp.add(Empty(txt: "这里是一颗空的星球"));
    }
    if (!load_done) {
      tmp.add(BottomLoading(color: Colors.transparent));
    } else {
      tmp.add(Container(height: 15));
    }
    return tmp;
  }

  @override
  void initState() {
    _getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= 100) {
        setState(() {
          _showTopTitle = true;
        });
      } else {
        setState(() {
          _showTopTitle = false;
        });
      }
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMore();
      }
      if (_scrollController.position.pixels > 1000 && !_showBackToTop) {
        setState(() {
          _showBackToTop = true;
        });
      }
      if (_scrollController.position.pixels < 1000 && _showBackToTop) {
        setState(() {
          _showBackToTop = false;
        });
      }
    });
    speedUp(_scrollController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    nowMode(context);
    return Baaaar(
      color:
          Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Provider.of<ColorProvider>(context).isDark
              ? os_dark_back
              : os_back,
          foregroundColor: Provider.of<ColorProvider>(context).isDark
              ? os_dark_white
              : Color(0xFF505050),
          elevation: 0,
          title: Text(
            _showTopTitle
                ? ["", "收藏", "发表", "回复", "足迹", "草稿"][widget.type]
                : "",
            style: XSTextStyle(
              context: context,
              fontSize: 16,
            ),
          ),
          actions: (widget.type == 4 || widget.type == 5) && !_showTopTitle
              ? [
                  IconButton(
                      onPressed: () {
                        showModal(
                          context: context,
                          cont: "确定清除所有记录?此操作不可逆，请谨慎操作",
                          title: "请确认",
                          confirm: () async {
                            if (widget.type == 4) {
                              await setStorage(key: "history", value: "[]");
                              _getData();
                            }
                            if (widget.type == 5) {
                              await setStorage(key: "draft", value: "[]");
                              _getData();
                            }
                          },
                        );
                      },
                      icon: Icon(Icons.delete_outline_rounded)),
                  Container(width: 10),
                ]
              : [],
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left_rounded,
              color: Provider.of<ColorProvider>(context).isDark
                  ? os_dark_white
                  : Color(0xFF505050),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: Provider.of<ColorProvider>(context).isDark
            ? os_dark_back
            : Color(0xFFF3F3F3),
        body: DismissiblePage(
          backgroundColor: Provider.of<ColorProvider>(context).isDark
              ? os_dark_back
              : os_back,
          direction: DismissiblePageDismissDirection.startToEnd,
          onDismissed: () {
            Navigator.of(context).pop();
          },
          child: BackToTop(
            bottom: 100,
            controller: _scrollController,
            show: _showBackToTop,
            child: RefreshIndicator(
              onRefresh: () async {
                return await _getData();
              },
              child: ListView(
                controller: _scrollController,
                //physics: BouncingScrollPhysics(),
                children: _buildCont(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MeFuncHead extends StatefulWidget {
  int type;
  MeFuncHead({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  State<MeFuncHead> createState() => _MeFuncHeadState();
}

class _MeFuncHeadState extends State<MeFuncHead> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      child: Row(
        children: [
          Hero(
            tag: "me_btn_${widget.type}",
            child: Material(
              color: Colors.transparent,
              child: os_svg(
                path: Provider.of<ColorProvider>(context).isDark
                    ? "lib/img/me_dark/btn${widget.type}.svg"
                    : "lib/img/me/btn${widget.type}.svg",
                width: 50,
                height: 50,
              ),
            ),
          ),
          Container(width: 10),
          Hero(
            tag: ["", "收藏", "发表", "回复", "足迹", "草稿"][widget.type],
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 200,
                child: Text(
                  ["", "收藏", "发表", "回复", "足迹", "草稿"][widget.type],
                  style: XSTextStyle(
                    context: context,
                    fontSize: 22,
                    color: Provider.of<ColorProvider>(context).isDark
                        ? os_dark_white
                        : Color(0xFF505050),
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

class FuncWidget extends StatefulWidget {
  int? type;
  Map? data;
  FuncWidget({
    Key? key,
    this.type,
    this.data,
  }) : super(key: key);

  @override
  State<FuncWidget> createState() => _FuncWidgetState();
}

class _FuncWidgetState extends State<FuncWidget> {
  @override
  Widget build(BuildContext context) {
    return [
      Topic(data: widget.data, blackOccu: true),
      Topic(data: widget.data, blackOccu: true),
      Topic(data: widget.data, blackOccu: true),
      HistoryCard(data: widget.data),
    ][widget.type! - 1];
  }
}

class DraftCard extends StatefulWidget {
  String? data;
  DraftCard({
    Key? key,
    this.data,
  }) : super(key: key);

  @override
  State<DraftCard> createState() => _DraftCardState();
}

class _DraftCardState extends State<DraftCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: os_edge, vertical: 5),
      decoration: BoxDecoration(
        // color: os_white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: myInkWell(
        radius: 17.5,
        color: Provider.of<ColorProvider>(context).isDark
            ? os_light_dark_card
            : os_white,
        longPress: () {
          Clipboard.setData(ClipboardData(text: widget.data!));
          showToast(context: context, type: XSToast.success, txt: "复制成功！");
        },
        tap: () {
          Clipboard.setData(ClipboardData(text: widget.data!));
          showToast(context: context, type: XSToast.success, txt: "复制成功！");
        },
        widget: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                  widget.data!,
                  style: XSTextStyle(
                    context: context,
                    fontSize: 14,
                    color: Provider.of<ColorProvider>(context).isDark
                        ? os_dark_white
                        : os_black,
                  ),
                ),
              ),
              Text(
                "复制",
                style: XSTextStyle(
                  context: context,
                  fontSize: 14,
                  color: os_color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HistoryCard extends StatefulWidget {
  Map? data;
  HistoryCard({
    Key? key,
    this.data,
  }) : super(key: key);

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: os_edge, right: os_edge, bottom: 10),
      child: myInkWell(
        radius: 17.5,
        color: Provider.of<ColorProvider>(context).isDark
            ? os_light_dark_card
            : os_white,
        tap: () {
          Navigator.pushNamed(
            context,
            "/topic_detail",
            arguments: widget.data!["topic_id"],
          );
        },
        widget: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                child: CachedNetworkImage(
                  imageUrl: widget.data!["userAvatar"],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: os_grey,
                  ),
                ),
              ),
              Container(width: 15),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 120,
                      child: Text(
                        widget.data!["title"],
                        style: XSTextStyle(
                          context: context,
                          fontSize: 16,
                          color: Provider.of<ColorProvider>(context).isDark
                              ? os_dark_white
                              : os_black,
                        ),
                      ),
                    ),
                    Container(height: 5),
                    Text(
                      RelativeDateFormat.format(
                        DateTime.fromMillisecondsSinceEpoch(
                          int.parse(widget.data!["time"]),
                        ),
                      ),
                      style: XSTextStyle(
                        context: context,
                        fontSize: 12,
                        color: Provider.of<ColorProvider>(context).isDark
                            ? os_deep_grey
                            : Color(0xFFBBBBBB),
                      ),
                    ),
                    Container(height: 5),
                    Container(
                      width: MediaQuery.of(context).size.width - 120,
                      child: Text(
                        widget.data!["subject"] == ""
                            ? "无"
                            : widget.data!["subject"],
                        style: XSTextStyle(
                          context: context,
                          fontSize: 14,
                          color: Color(0xFFA3A3A3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
