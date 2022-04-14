import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/asset/time.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/components/topic.dart';
import 'package:offer_show/components/totop.dart';
import 'package:offer_show/outer/cached_network_image/cached_image_widget.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/storage.dart';

class MeFunc extends StatefulWidget {
  int type;
  int uid;
  MeFunc({
    Key key,
    this.type,
    this.uid,
  }) : super(key: key);

  @override
  _MeFuncState createState() => _MeFuncState();
}

class _MeFuncState extends State<MeFunc> {
  List data = [];
  bool load_done = false;
  bool loading = false;
  ScrollController _scrollController = new ScrollController();
  bool _showBackToTop = false;

  _getData() async {
    if (loading) return;
    loading = true;
    if (widget.type <= 3) {
      //收藏、发表、回复
      var tmp = await Api().user_topiclist({
        "type": ["favorite", "topic", "reply"][widget.type - 1],
        "uid": widget.uid ?? 221788,
        "page": 1,
        "pageSize": 10,
      });
      if (tmp != null && tmp["list"] != null) {
        data = tmp["list"];
        load_done = data.length % 10 != 0;
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
    loading = false;
  }

  _getMore() async {
    if (loading) return;
    loading = true;
    if (load_done) return;
    if (widget.type <= 3) {
      //收藏、发表、回复
      var tmp = await Api().user_topiclist({
        "type": ["favorite", "topic", "reply"][widget.type - 1],
        "uid": widget.uid ?? 221788,
        "page": (data.length / 10).ceil() + 1,
        "pageSize": 10,
      });
      if (tmp != null && tmp["list"] != null) {
        data.addAll(tmp["list"]);
        load_done = data.length % 10 != 0;
        setState(() {});
      }
    }
    loading = false;
  }

  List<Widget> _buildCont() {
    List<Widget> tmp = [];
    tmp.add(MeFuncHead(type: widget.type));
    data.forEach((element) {
      tmp.add(FuncWidget(data: element, type: widget.type));
    });
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
    super.initState();
  }

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
      body: BackToTop(
        bottom: 100,
        controller: _scrollController,
        show: _showBackToTop,
        child: RefreshIndicator(
          onRefresh: () async {
            return await _getData();
          },
          child: ListView(
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            children: _buildCont(),
          ),
        ),
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
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
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

class FuncWidget extends StatefulWidget {
  int type;
  Map data;
  FuncWidget({
    Key key,
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
      Topic(data: widget.data),
      Topic(data: widget.data),
      Topic(data: widget.data),
      HistoryCard(data: widget.data),
    ][widget.type - 1];
  }
}

class HistoryCard extends StatefulWidget {
  Map data;
  HistoryCard({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  _setHistory() async {
    var history_data = await getStorage(key: "history", initData: "[]");
    List history_arr = jsonDecode(history_data);
    bool flag = false;
    for (int i = 0; i < history_arr.length; i++) {
      var ele = history_arr[i];
      if (ele["userAvatar"] == widget.data["userAvatar"] &&
          ele["title"] == widget.data["title"] &&
          ele["subject"] == widget.data["subject"]) {
        history_arr.removeAt(i);
      }
    }
    List tmp_list_history = [
      {
        "userAvatar": widget.data["userAvatar"],
        "title": widget.data["title"],
        "subject": widget.data["subject"],
        "time": widget.data["time"],
        "topic_id": widget.data["topic_id"],
      }
    ];
    tmp_list_history.addAll(history_arr);
    setStorage(key: "history", value: jsonEncode(tmp_list_history));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: os_edge, right: os_edge, bottom: 10),
      child: myInkWell(
        radius: 10,
        tap: () {
          _setHistory();
          Navigator.pushNamed(
            context,
            "/topic_detail",
            arguments: widget.data["topic_id"],
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
                  imageUrl: widget.data["userAvatar"],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              Container(width: 15),
              Container(
                width: MediaQuery.of(context).size.width - 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 200,
                      child: Text(
                        widget.data["title"],
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(height: 5),
                    Text(
                      RelativeDateFormat.format(
                        DateTime.fromMillisecondsSinceEpoch(
                          int.parse(widget.data["time"]),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFBBBBBB),
                      ),
                    ),
                    Container(height: 5),
                    Text(
                      widget.data["subject"] == ""
                          ? "无"
                          : widget.data["subject"],
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFA3A3A3),
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
