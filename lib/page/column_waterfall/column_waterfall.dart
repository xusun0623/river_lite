import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:offer_show/asset/bigScreen.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/mouse_speed.dart';
import 'package:offer_show/asset/refreshIndicator.dart';
import 'package:offer_show/asset/vibrate.dart';
import 'package:offer_show/components/expansion_custom.dart';
import 'package:offer_show/components/leftNavi.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:offer_show/components/occu_loading.dart';
import 'package:offer_show/components/topic_waterfall.dart';
import 'package:offer_show/components/totop.dart';
import 'package:offer_show/page/column_waterfall/column_btn.dart';
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
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  ScrollController _scrollController = new ScrollController();
  List theme = [];
  int lastThemeIndex = 0;

  List<dynamic>? data = [];
  var loading = false;
  var init_loading = false;
  var load_done = false;
  bool showBackToTop = false;
  bool vibrate = false;
  int pageSize = 24;
  int? columnID = 61;
  String? columnName = "二手专区";
  int? subColumnID = -1;
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
    Map? id_name_map = jsonDecode(id_name);
    setState(() {
      columnID = id_name_map!["fid"];
      columnName = id_name_map["name"];
    });
    await _getStorageData();
    await _getThemeData();
    await _getInitData();
  }

  bool showTabbar = true;

  @override
  void initState() {
    prepareData();
    super.initState();
    _tabController = TabController(
      length: 0,
      vsync: this,
      initialIndex: lastThemeIndex,
    );
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
      if (_scrollController.position.pixels > 400 &&
          showTabbar &&
          !isDesktop()) {
        setState(() {
          showTabbar = false;
        });
      }
      if (_scrollController.position.pixels < 400 &&
          !showTabbar &&
          !isDesktop()) {
        setState(() {
          showTabbar = true;
        });
      }
    });
    speedUp(_scrollController);
  }

  bool dontRePullTab = false;

  _setThemeIndex() async {
    await setStorage(key: "themeIndex", value: lastThemeIndex.toString());
  }

  _getThemeIndex() async {
    var tmp = await getStorage(key: "themeIndex", initData: "0");
    setState(() {
      lastThemeIndex = int.parse(tmp);
    });
  }

  _getThemeData() async {
    await _getThemeIndex();
    var tmp = await getStorage(key: "themeData", initData: "[]");
    theme = jsonDecode(tmp);
    setState(() {});
    if (lastThemeIndex > 0) {
      subColumnID = theme[lastThemeIndex - 1]["classificationType_id"];
    }
    print("初始化themeID:${subColumnID}");
    if (!dontRePullTab) {
      _tabController = TabController(
        length: theme.length + 1,
        vsync: this,
        initialIndex: lastThemeIndex,
      );
    }
    setState(() {});
  }

  setThemeData() async {
    await setStorage(key: "themeData", value: jsonEncode(theme));
  }

  _getInitData() async {
    if (dontRePullTab) {
      setState(() {
        init_loading = true;
      });
    }
    var tmp = await Api().certain_forum_topiclist({
      "page": 1,
      "pageSize": pageSize,
      "boardId": columnID,
      "filterType": "typeid",
      "filterId": subColumnID == -1 ? "" : subColumnID,
      "sortby": "all",
      "topOrder": 1,
    });
    setState(() {
      init_loading = false;
    });
    if (tmp != null && tmp["list"] != null && tmp["list"].length != 0) {
      var list = tmp["classificationType_list"];
      theme = [];
      if (list != null && list.length != 0) {
        for (var i = 0; i < list.length; i++) {
          theme.add(list[i]);
        }
      }
      setThemeData();
      if (!dontRePullTab) {
        _tabController = TabController(
          length: theme.length + 1,
          vsync: this,
          initialIndex: lastThemeIndex,
        );
      }
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
    if (data != null && data!.length != 0)
      setStorage(key: "home_left_column", value: jsonEncode(data));
    load_done = false;
    dontRePullTab = false;
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
    setState(() {
      // init_loading = true;
    });
    var tmp = await Api().certain_forum_topiclist({
      "page": data!.length / pageSize + 1,
      "pageSize": pageSize,
      "boardId": columnID, //columnID
      "filterType": "typeid",
      "filterId": subColumnID == -1 ? "" : subColumnID,
      "sortby": "all",
      "topOrder": 1,
    });
    setState(() {
      loading = false;
      init_loading = false;
    });
    if (tmp != null &&
        tmp["rs"] != 0 &&
        tmp["list"] != null &&
        tmp["list"].length != 0) {
      data!.addAll(tmp["list"]);
      setStorage(key: "home_left_column", value: jsonEncode(data));
    }
    load_done = tmp == null || ((tmp["list"] ?? []).length < pageSize);
    setState(() {});
  }

  late TabController _tabController;

  Widget _buildComponents() {
    List<Widget> t = [];
    double w = MediaQuery.of(context).size.width;
    if (data != null && data!.length != 0) {
      for (var i in data!) {
        t.add(
          TopicWaterFall(
            isLeftNaviUI: isDesktop(),
            data: i,
          ),
        );
      }
    }
    if (data!.length == 0) {
      t.add(Container(
        height: MediaQuery.of(context).size.height - 100,
      ));
    }
    // if (w < 800) {
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
          : BottomLoading(),
    );
    // }
    t.add(Padding(
      padding: EdgeInsets.all(load_done || data!.length == 0 ? 7.5 : 0),
    ));

    int count = w > 1200 ? 5 : (w > 800 ? 4 : 2);
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: BackToTop(
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
                  padding: EdgeInsets.only(
                      left: isDesktop() ? 10 : 5,
                      right: isDesktop() ? 10 : 5,
                      top: 10,
                      bottom: isDesktop() ? 10 : 5),
                  crossAxisCount: count,
                  mainAxisSpacing: 6.5,
                  crossAxisSpacing: 6.5,
                  itemBuilder: (BuildContext context, int index) {
                    return t[index];
                  },
                ),
                controller: _scrollController,
              ),
            ),
          ],
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 500),
          curve: Curves.ease,
          bottom:
              init_loading ? (MediaQuery.of(context).size.height / 2 - 60) : 20,
          left: (MediaQuery.of(context).size.width -
                      (isDesktop() ? LeftNaviWidth : 0)) /
                  2 -
              (init_loading ? 180 / 2 : 120 / 2),
          child: ColumnBtn(
            needPush: true,
            loading: init_loading,
            name: columnName,
            fid: columnID,
            backData: (res) async {
              setState(() {
                columnName = res["name"];
                columnID = res["fid"];
                subColumnID = -1;
              });
              setState(() {
                lastThemeIndex = 0;
                init_loading = true;
              });
              _setThemeIndex();
              await Future.delayed(Duration(milliseconds: 400));
              if (res != null) {
                setStorage(
                  key: "left_column",
                  value: jsonEncode({
                    "name": columnName,
                    "fid": columnID,
                  }),
                );
                _scrollController.animateTo(
                  0,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.ease,
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
      body: Column(
        children: [
          if (theme.length != 1 && theme.length != 0)
            ExpansionCustom(
              padding: EdgeInsets.only(top: 0, bottom: 0),
              title: Container(),
              onExpansionChanged: (res) {},
              isExpanded: showTabbar,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: Provider.of<ColorProvider>(context).isDark
                            ? os_dark_back
                            : os_back,
                        child: TabBar(
                          padding: EdgeInsets.only(left: 10, right: 15),
                          controller: _tabController,
                          isScrollable: true,
                          dividerColor: Colors.transparent,
                          tabAlignment: TabAlignment.start,
                          labelPadding: EdgeInsets.symmetric(horizontal: 14.5),
                          indicator: BubbleTabIndicator(
                            indicatorColor:
                                Provider.of<ColorProvider>(context).isDark
                                    ? os_white_opa
                                    : os_dark_back,
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.5,
                              vertical: 7.5,
                            ),
                          ),
                          // indicatorColor:
                          //     const Color.fromARGB(0, 194, 181, 181),
                          // labelPadding: EdgeInsets.symmetric(horizontal: 10),
                          unselectedLabelStyle: TextStyle(
                            color: Provider.of<ColorProvider>(context).isDark
                                ? os_deep_grey
                                : (isDesktop()
                                    ? Color(0xff666666)
                                    : os_dark_back),
                          ),
                          labelStyle: TextStyle(
                            color: Provider.of<ColorProvider>(context).isDark
                                ? os_dark_white
                                : os_white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          onTap: (res) {
                            var tmpId = [
                              {
                                "classificationType_name": "全部",
                                "classificationType_id": -1
                              },
                              ...theme
                            ][res]["classificationType_id"];
                            dontRePullTab = true;
                            subColumnID = tmpId;
                            lastThemeIndex = res;
                            setState(() {});
                            _setThemeIndex();
                            _getInitData();
                          },
                          tabs: [
                            {
                              "classificationType_name": "全部",
                              "classificationType_id": -1
                            },
                            ...theme
                          ].map((ele) {
                            // classificationType_id
                            return Tab(text: ele["classificationType_name"]);
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          Expanded(
            child: getMyRrefreshIndicator(
              context: context,
              color: Provider.of<ColorProvider>(context).isDark
                  ? os_dark_dark_white
                  : os_dark_back,
              key: _indicatorKey,
              onRefresh: () async {
                await _getInitData();
                return;
              },
              child: data!.length == 0 ? OccuLoading() : _buildComponents(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
