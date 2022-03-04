import 'package:flutter/material.dart';
import 'package:noripple_overscroll/noripple_overscroll.dart';
import 'package:offer_show/asset/color.dart';
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
    list = tmp["list"];
    setState(() {});
  }

  Widget _buildComponents() {
    List<Widget> t = [];
    t.addAll([
      os_svg(
        path: "lib/img/banner.svg",
        width: MediaQuery.of(context).size.width - 30,
        height: (MediaQuery.of(context).size.width - 30) / 360 * 144,
      ),
      HomeBtnCollect(),
    ]);
    if (list != null && list.length != 0) {
      for (var i in list) {
        t.add(Topic(data: i));
      }
    }
    t.add(Padding(padding: EdgeInsets.all(7.5)));
    return ListView(
      physics: BouncingScrollPhysics(),
      children: t,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: os_color,
      onRefresh: () async {
        return await _getData();
      },
      child: NoRippleOverScroll(
        child: _buildComponents(),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
