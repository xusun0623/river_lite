// ColumnWaterfall
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:offer_show/asset/bigScreen.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/mouse_speed.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/vibrate.dart';
import 'package:offer_show/components/leftNavi.dart';
import 'package:offer_show/components/occu_loading.dart';
import 'package:offer_show/components/topic_waterfall.dart';
import 'package:offer_show/components/totop.dart';
import 'package:offer_show/page/column_waterfall/column_btn.dart';
import 'package:offer_show/page/column_waterfall/waterfall_selection.dart';
import 'package:offer_show/page/home/homeNew.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
import 'package:provider/provider.dart';

class ColumnWaterfall extends StatefulWidget {
  @override
  _ColumnWaterfallState createState() => _ColumnWaterfallState();
}

class _ColumnWaterfallState extends State<ColumnWaterfall>
    with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController = new ScrollController();
  List<String> theme = [];
  var data = [];
  var loading = false;
  var init_loading = false;
  var load_done = false;
  bool showBackToTop = false;
  bool vibrate = false;
  int pageSize = 24;
  int columnID = 61;
  String columnName = "二手专区";
  GlobalKey<RefreshIndicatorState> _indicatorKey =
      GlobalKey<RefreshIndicatorState>();

  prepareData() async {
    String id_name = await getStorage(
      key: "left_column",
      initData: jsonEncode({
        "name": "二手专区",
        "fid": 61,
      }),
    );
    Map id_name_map = jsonDecode(id_name);
    setState(() {
      columnID = id_name_map["fid"];
      columnName = id_name_map["name"];
    });
    _getStorageData();
    _getInitData();
  }

  @override
  void initState() {
    prepareData();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels < -100) {
        if (!vibrate) {
          vibrate = true; //不允许再震动
          XSVibrate();
        }
      }
      if (_scrollController.position.pixels >= 0) {
        vibrate = false; //允许震动
      }
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50) {
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
    speedUp(_scrollController);
  }

  _getInitData() async {
    var tmp = await Api().certain_forum_topiclist({
      "page": 1,
      "pageSize": pageSize,
      "boardId": columnID,
      "filterType": "typeid",
      "filterId": "",
      "sortby": "all",
      "topOrder": 1,
    });
    setState(() {
      init_loading = false;
    });
    if (tmp != null && tmp["list"] != null && tmp["list"].length != 0) {
      data = tmp["list"];
    } else {
      try {
        Fluttertoast.showToast(
          msg: tmp["errcode"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } catch (e) {}
    }
    if (data != null && data.length != 0)
      setStorage(key: "home_left_column", value: jsonEncode(data));
    load_done = false;
    setState(() {});
  }

  _getStorageData() async {
    var tmp = await getStorage(key: "home_left_column", initData: "[]");
    setState(() {
      data = jsonDecode(tmp);
    });
  }

  _getData() async {
    if (loading || load_done) return;
    loading = true;
    setState(() {});
    var tmp = await Api().certain_forum_topiclist({
      "page": data.length / pageSize + 1,
      "pageSize": pageSize,
      "boardId": columnID, //columnID
      "filterType": "typeid",
      "filterId": "",
      "sortby": "all",
      "topOrder": 1,
    });
    setState(() {
      loading = false;
    });
    if (tmp != null &&
        tmp["rs"] != 0 &&
        tmp["list"] != null &&
        tmp["list"].length != 0) {
      var list = tmp["classificationType_list"];
      theme = ["全部分栏"];
      if (list != null && list.length != 0) {
        for (var i = 0; i < list.length; i++) {
          theme.add(list[i]["classificationType_name"]);
        }
      }
      data.addAll(tmp["list"]);
      setStorage(key: "home_left_column", value: jsonEncode(data));
    }
    load_done = tmp == null || ((tmp["list"] ?? []).length < pageSize);
    setState(() {});
  }

  Widget _buildComponents() {
    List<Widget> t = [];
    double w = MediaQuery.of(context).size.width;
    if (data != null && data.length != 0) {
      for (var i in data) {
        t.add(
          TopicWaterFall(
            isLeftNaviUI: isDesktop() && true,
            data: i,
          ),
        );
      }
    }
    if (data.length == 0) {
      t.add(Container(
        height: MediaQuery.of(context).size.height - 100,
      ));
    }
    if (w < 800) {
      t.add(
        load_done || data.length == 0
            ? TapMore(
                tap: () {
                  XSVibrate();
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
      padding: EdgeInsets.all(load_done || data.length == 0 ? 7.5 : 0),
    ));
    return Stack(
      children: [
        BackToTop(
          show: showBackToTop,
          animation: true,
          bottom: 50,
          refresh: () {
            _indicatorKey.currentState.show();
          },
          child: MasonryGridView.count(
            controller: _scrollController,
            itemCount: t.length,
            padding: EdgeInsets.all(os_edge),
            crossAxisCount: w > 1200 ? 6 : (w > 800 ? 4 : 2),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            itemBuilder: (BuildContext context, int index) {
              return t[index];
            },
          ),
          controller: _scrollController,
        ),
        Positioned(
          bottom: 20,
          left: (MediaQuery.of(context).size.width - LeftNaviWidth) / 2 - 30,
          child: ColumnBtn(
            needPush: true,
            loading: init_loading,
            name: columnName,
            fid: columnID,
            backData: (res) {
              if (res != null) {
                setState(() {
                  columnName = res["name"];
                  columnID = res["fid"];
                  init_loading = true;
                });
                setStorage(
                  key: "left_column",
                  value: jsonEncode({
                    "name": columnName,
                    "fid": columnID,
                  }),
                );
                _getInitData();
              }
              // print("接收到$res");
            },
          ),
        ),
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
      body: RefreshIndicator(
        color: os_color,
        key: _indicatorKey,
        onRefresh: () async {
          var data = await _getInitData();
          return data;
        },
        child: data.length == 0 ? OccuLoading() : _buildComponents(), //11223344
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
