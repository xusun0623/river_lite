import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:noripple_overscroll/noripple_overscroll.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/components/topic.dart';
import 'package:offer_show/util/interface.dart';

class HomeHot extends StatefulWidget {
  @override
  _HomeHotState createState() => _HomeHotState();
}

class _HomeHotState extends State<HomeHot> with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController = new ScrollController();
  final List<String> _contentList = [
    '语文',
    '英语',
    '化学',
    '物理',
    '数学',
    '生物',
    '体育',
    '经济',
    '语文',
    '英语',
    '化学',
    '物理',
    '数学',
    '生物',
    '体育',
    '经济',
    '语文',
    '英语',
    '化学',
    '物理',
    '数学',
    '生物',
    '体育',
    '经济',
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("滑动到底部");
        //滑动到了底部判断
      }
    });
  }

  Future _getData() async {
    return await Api().portal_newslist();
  }

  Widget _buildFuture(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      List<Widget> t = [];
      t.add(os_svg(path: "lib/img/banner.svg", width: 360, height: 144));
      if (snapshot.data.length != 0) {
        for (var i in snapshot.data["list"]) {
          t.add(Topic(data: i));
        }
      }
      return ListView(
        children: t,
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: os_back,
      body: RefreshIndicator(
        color: os_color,
        onRefresh: () async {
          return await Future.delayed(Duration(milliseconds: 300));
        },
        child: NoRippleOverScroll(
          child: FutureBuilder(
            future: _getData(),
            builder: _buildFuture,
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
