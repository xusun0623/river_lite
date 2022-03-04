import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/components/home_btn.dart';
import 'package:offer_show/components/topic.dart';
import 'package:offer_show/util/interface.dart';

class HomeHot extends StatefulWidget {
  @override
  _HomeHotState createState() => _HomeHotState();
}

class _HomeHotState extends State<HomeHot> with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController = new ScrollController();
  var list = [];

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("滑动到底部");
      }
    });
  }

  _getData() async {
    var tmp = await Api().portal_newslist();
    list = tmp["list"] ?? [];
    showToast(context: context, type: XSToast.done, txt: jsonEncode(list));
    setState(() {});
  }

  List<Widget> _buildComponents() {
    List<Widget> t = [];
    t.addAll([
      HomeBtnCollect(),
    ]);
    for (var i in list) {
      t.add(Topic(data: i));
    }
    t.add(Padding(padding: EdgeInsets.all(7.5)));
    return t;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: os_color,
      onRefresh: () async {
        return await _getData();
      },
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: _buildComponents(),
      ),
    );
  }
}
