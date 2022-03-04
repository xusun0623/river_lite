import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/components/topic.dart';
import 'package:offer_show/components/totop.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/util/interface.dart';

class HomeNew extends StatefulWidget {
  @override
  _HomeNewState createState() => _HomeNewState();
}

class _HomeNewState extends State<HomeNew> with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController = new ScrollController();
  var data = [];
  var loading = false;
  var load_done = false;
  bool showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _getInitData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("触底");
        _getData();
      }
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
    });
  }

  _getInitData() async {
    var tmp = await Api()
        .forum_topiclist({"page": 1, "pageSize": 20, "sortby": "all"});
    data = tmp["list"];
    load_done = false;
    setState(() {});
  }

  _getData() async {
    if (loading || load_done) return;
    loading = true;
    int pageSize = 20;
    var tmp = await Api().forum_topiclist({
      "page": (data.length / pageSize + 1).toInt(),
      "pageSize": pageSize,
      "sortby": "all"
    });
    if (tmp["list"] != null && tmp["list"].length != 0) {
      data.addAll(tmp["list"]);
    }
    load_done = tmp == null || ((tmp["list"] ?? []).length < pageSize);
    loading = false;
    setState(() {});
  }

  Widget _buildComponents() {
    List<Widget> t = [];
    if (data != null && data.length != 0) {
      for (var i in data) {
        t.add(Topic(data: i));
      }
    }
    t.add(
      load_done || data.length == 0
          ? Container()
          : BottomLoading(
              color: Colors.transparent,
              txt: "加载中…",
            ),
    );
    t.add(Padding(
      padding: EdgeInsets.all(load_done || data.length == 0 ? 7.5 : 0),
    ));
    return BackToTop(
      show: showBackToTop,
      child: ListView(
        physics: BouncingScrollPhysics(),
        controller: _scrollController,
        children: t,
      ),
      controller: _scrollController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: os_back,
      body: RefreshIndicator(
        color: os_color,
        onRefresh: () async {
          return await _getInitData();
        },
        child: _buildComponents(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
