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
  @override
  void initState() {
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
      t.add(
        os_svg(
            path: "lib/img/banner.svg",
            width: MediaQuery.of(context).size.width - 30,
            height: (MediaQuery.of(context).size.width - 30) / 360 * 144),
      );
      if (snapshot.data.length != 0) {
        for (var i in snapshot.data["list"]) {
          t.add(Topic(data: i));
        }
      }
      t.add(Padding(padding: EdgeInsets.all(7.5)));
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
          return await _getData();
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
