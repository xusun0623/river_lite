import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:offer_show/asset/bigScreen.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/home_desktop_mode.dart';
import 'package:offer_show/asset/mouse_speed.dart';
import 'package:offer_show/asset/refreshIndicator.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/vibrate.dart';
import 'package:offer_show/asset/xs_textstyle.dart';
import 'package:offer_show/components/leftNavi.dart';
import 'package:offer_show/components/occu_loading.dart';
import 'package:offer_show/components/topic.dart';
import 'package:offer_show/components/totop.dart';
import 'package:offer_show/page/home/homeNew.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
import 'package:provider/provider.dart';

class HomeNewReply extends StatefulWidget {
  @override
  _HomeNewReplyState createState() => _HomeNewReplyState();
}

class _HomeNewReplyState extends State<HomeNewReply>
    with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController = new ScrollController();
  List<dynamic>? data = [];
  var loading = false;
  var load_done = false;
  bool showBackToTop = false;
  bool vibrate = false;
  int pageSize = 25;
  GlobalKey<RefreshIndicatorState> _indicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _getStorageData();
    _getInitData();
    _scrollController =
        Provider.of<HomeRefrshProvider>(context, listen: false).reply;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels < -100) {
        if (!vibrate) {
          vibrate = true; //不允许再震动
          XSVibrate().impact();
        }
      }
      if (_scrollController.position.pixels >= 0) {
        vibrate = false; //允许震动
      }
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50) {
        // print("触底");
        _getData();
      }
      // if (_scrollController.position.pixels ==
      //     _scrollController.position.maxScrollExtent) {
      //   // print("触底");
      //   _getData();
      // }
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
    speedUp(_scrollController);
  }

  _getInitData() async {
    var tmp = await Api()
        .forum_topiclist({"page": 1, "pageSize": pageSize, "sortby": "all"});
    if (tmp != null && tmp["list"] != null && tmp["list"].length != 0) {
      data = tmp["list"];
    }
    if (data != null && data!.length != 0)
      setStorage(key: "home_new_reply", value: jsonEncode(data));
    load_done = false;
    setState(() {});
  }

  _getStorageData() async {
    var tmp = await getStorage(key: "home_new_reply", initData: "[]");
    setState(() {
      data = jsonDecode(tmp);
    });
  }

  _getData() async {
    if (loading || load_done) return;
    loading = true;
    setState(() {});
    var tmp = await Api().forum_topiclist({
      "page": (data!.length / pageSize + 1).toInt(),
      "pageSize": pageSize,
      "sortby": "all"
    });
    setState(() {
      loading = false;
    });
    Api().forum_topiclist({
      "page": (data!.length / pageSize + 1).toInt() + 1,
      "pageSize": pageSize,
      "sortby": "all"
    });
    if (tmp != null &&
        tmp["rs"] != 0 &&
        tmp["list"] != null &&
        tmp["list"].length != 0) {
      data!.addAll(tmp["list"]);
      setStorage(key: "home_new_reply", value: jsonEncode(data));
    }
    load_done = tmp == null || ((tmp["list"] ?? []).length < pageSize);
    setState(() {});
  }

  Widget _buildComponents() {
    List<Widget> t = [];
    double w = MediaQuery.of(context).size.width;
    if (data != null && data!.length != 0) {
      for (var i in data!) {
        t.add(
          Topic(
            isLeftNaviUI: isDesktop() && true,
            data: i,
            top: 0,
            removeMargin: true,
          ),
        );
      }
    }
    if (data!.length == 0) {
      t.add(Container(
        height: MediaQuery.of(context).size.height - 100,
      ));
    }
    if (w < 800) {
      t.add(
        load_done || data!.length == 0
            ? TapMore(
                tap: () {
                  XSVibrate().impact();
                  setState(() {
                    loading = false;
                    load_done = false;
                    _getData();
                  });
                },
              )
            : BottomLoading(color: Colors.transparent, txt: "努力加载中…"),
      );
    }
    t.add(Padding(
      padding: EdgeInsets.all(load_done || data!.length == 0 ? 7.5 : 0),
    ));
    return Stack(
      children: [
        BackToTop(
          show: showBackToTop,
          animation: true,
          bottom: 50,
          refresh: () {
            _indicatorKey.currentState!.show();
          },
          child: MasonryGridView.count(
            physics: AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            itemCount: t.length,
            padding: EdgeInsets.all(os_edge),
            crossAxisCount: w > 1200 ? 3 : (w > 800 ? 2 : 1),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            itemBuilder: (BuildContext context, int index) {
              return t[index];
            },
          ),
          controller: _scrollController,
        ),
        loading && w > 800
            ? Positioned(
                bottom: 20,
                left: (MediaQuery.of(context).size.width - LeftNaviWidth) / 2 -
                    30,
                child: Container(
                  width: 120,
                  height: 40,
                  decoration: BoxDecoration(
                    color: os_white,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 20,
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: os_deep_blue,
                        ),
                      ),
                      Container(width: 10),
                      Text(
                        "加载中…",
                        style: XSTextStyle(
                          context: context,
                          fontSize: 14,
                          color: os_black,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: getMyRrefreshIndicator(
        context: context,
        color: os_color,
        key: _indicatorKey,
        onRefresh: () async {
          var data = await _getInitData();
          return data;
        },
        child:
            data!.length == 0 ? OccuLoading() : _buildComponents(), //11223344
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
