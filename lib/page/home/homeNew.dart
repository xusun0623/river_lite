import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/components/banner.dart';
import 'package:offer_show/components/hot_btn.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/components/nomore.dart';
import 'package:offer_show/components/topic.dart';
import 'package:offer_show/components/totop.dart';
import 'package:offer_show/page/essence/essence.dart';
import 'package:offer_show/page/hot/homeHot.dart';
import 'package:offer_show/page/new_reply/homeNewReply.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
import 'package:provider/provider.dart';

class HomeNew extends StatefulWidget {
  @override
  _HomeNewState createState() => _HomeNewState();
}

class _HomeNewState extends State<HomeNew> with SingleTickerProviderStateMixin {
  ScrollController _scrollController;
  var data = [];
  var loading = false;
  var load_done = false;
  bool showBackToTop = false;
  bool vibrate = false;

  @override
  void initState() {
    super.initState();
    _getStorageData();
    _getInitData();
    tabController = TabController(length: 4, vsync: this);
    _scrollController = Provider.of<HomeRefrshProvider>(context, listen: false)
        .homeScrollController;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels < -100) {
        if (!vibrate) {
          vibrate = true; //不允许再震动
          Vibrate.feedback(FeedbackType.impact);
        }
      }
      if (_scrollController.position.pixels >= 0) {
        vibrate = false; //允许震动
      }
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // print("触底");
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
        .forum_topiclist({"page": 1, "pageSize": 20, "sortby": "new"});
    if (tmp != null && tmp["list"] != null && tmp["list"].length != 0) {
      data = tmp["list"];
    }
    if (data != null && data.length != 0)
      setStorage(key: "home_new", value: jsonEncode(data));
    load_done = false;
    setState(() {});
  }

  _getStorageData() async {
    var tmp = await getStorage(key: "home_new", initData: "[]");
    setState(() {
      data = jsonDecode(tmp);
    });
  }

  _getData() async {
    if (loading || load_done) return;
    loading = true;
    int pageSize = 20;
    var tmp = await Api().forum_topiclist({
      "page": (data.length / pageSize + 1).toInt(),
      "pageSize": pageSize,
      "sortby": "new"
    });
    if (tmp != null &&
        tmp["rs"] != 0 &&
        tmp["list"] != null &&
        tmp["list"].length != 0) {
      data.addAll(tmp["list"]);
      setStorage(key: "home_new_reply", value: jsonEncode(data));
    }
    load_done = tmp == null || ((tmp["list"] ?? []).length < pageSize);
    loading = false;
    setState(() {});
  }

  Widget _buildComponents() {
    List<Widget> t = [];
    t.add(ImgBanner());
    t.add(Container(height: 10));
    t.add(HomeBtn());
    if (data != null && data.length != 0) {
      for (var i in data) {
        t.add(Topic(data: i));
      }
    }
    if (data.length == 0) {
      t.add(Container(
        height: MediaQuery.of(context).size.height - 100,
      ));
    }
    t.add(
      load_done || data.length == 0
          ? NoMore()
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
      animation: true,
      attachBtn: true,
      tap: () {
        Navigator.pushNamed(context, "/new", arguments: {});
      },
      child: ListView(
        physics: BouncingScrollPhysics(),
        controller: _scrollController,
        children: t,
      ),
      controller: _scrollController,
    );
  }

  TabController tabController;
  int stack_index = 0;

  @override
  Widget build(BuildContext context) {
    HomeRefrshProvider provider = Provider.of<HomeRefrshProvider>(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: os_back,
          foregroundColor: os_black,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/search");
              },
              icon: os_svg(
                path: "lib/img/search.svg",
                width: 24,
                height: 24,
              ),
            ),
            Container(width: 5),
          ],
          title: Container(
            width: 300,
            height: 60,
            child: TabBar(
              labelPadding: EdgeInsets.symmetric(horizontal: 12),
              isScrollable: true,
              splashBorderRadius: BorderRadius.all(Radius.circular(5)),
              labelColor: os_deep_blue,
              unselectedLabelColor: Color(0xFF7A7A7A),
              unselectedLabelStyle: TextStyle(
                fontSize: 16,
              ),
              indicator: TabSizeIndicator(
                wantWidth: 20,
                borderSide: BorderSide(width: 3.0, color: os_deep_blue),
              ),
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              tabs: [
                Tab(text: "新发表"),
                Tab(text: "新回复"),
                Tab(text: "热门"),
                Tab(text: "精华"),
              ],
              onTap: (index) {
                setState(() {
                  stack_index = index;
                });
              },
              controller: tabController,
            ),
          ),
        ),
        backgroundColor: os_back,
        body: IndexedStack(
          index: stack_index,
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
              child: RefreshIndicator(
                color: os_color,
                key: provider.homeRefreshIndicator,
                onRefresh: () async {
                  var data = await _getInitData();
                  vibrate = false;
                  return data;
                },
                child: _buildComponents(),
              ),
            ),
            HomeNewReply(),
            Hot(),
            Essence(),
          ],
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => throw UnimplementedError();
}

class StackIndex extends StatefulWidget {
  int index;
  Function tap;
  StackIndex({
    Key key,
    this.index,
    this.tap,
  }) : super(key: key);

  @override
  State<StackIndex> createState() => _StackIndexState();
}

class _StackIndexState extends State<StackIndex> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ToSearch extends StatefulWidget {
  const ToSearch({Key key}) : super(key: key);

  @override
  State<ToSearch> createState() => _ToSearchState();
}

class _ToSearchState extends State<ToSearch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: os_edge, right: os_edge, bottom: 10),
      child: myInkWell(
        radius: 10,
        tap: () {
          Navigator.pushNamed(context, "/search");
        },
        widget: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "搜一搜",
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 171, 171, 171),
                ),
              ),
              os_svg(
                path: "lib/img/search_grey.svg",
                width: 20,
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TabSizeIndicator extends Decoration {
  final double wantWidth; //传入的指示器宽度，默认20
  const TabSizeIndicator(
      {this.borderSide = const BorderSide(width: 2.0, color: Colors.blue),
      this.insets = EdgeInsets.zero,
      this.wantWidth = 20})
      : assert(borderSide != null),
        assert(insets != null),
        assert(wantWidth != null);
  final BorderSide borderSide; //指示器高度以及颜色 ，默认高度2，颜色蓝
  final EdgeInsetsGeometry insets;

  @override
  Decoration lerpFrom(Decoration a, double t) {
    if (a is UnderlineTabIndicator) {
      return UnderlineTabIndicator(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration lerpTo(Decoration b, double t) {
    if (b is TabSizeIndicator) {
      return TabSizeIndicator(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t),
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  _MyUnderlinePainter createBoxPainter([VoidCallback onChanged]) {
    return _MyUnderlinePainter(this, wantWidth, onChanged);
  }
}

class _MyUnderlinePainter extends BoxPainter {
  final double wantWidth;
  _MyUnderlinePainter(this.decoration, this.wantWidth, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  final TabSizeIndicator decoration;

  BorderSide get borderSide => decoration.borderSide;
  EdgeInsetsGeometry get insets => decoration.insets;

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    assert(rect != null);
    assert(textDirection != null);
    final Rect indicator = insets.resolve(textDirection).deflateRect(rect);
    double cw = (indicator.left + indicator.right) / 2;
    return Rect.fromLTWH(
      cw - wantWidth / 2,
      indicator.bottom - borderSide.width,
      wantWidth,
      borderSide.width,
    );
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size;
    final TextDirection textDirection = configuration.textDirection;
    final Rect indicator =
        _indicatorRectFor(rect, textDirection).deflate(borderSide.width / 2.0);
    final Paint paint = borderSide.toPaint()..strokeCap = StrokeCap.round;
    canvas.drawLine(
      indicator.bottomLeft.translate(0, -12),
      indicator.bottomRight.translate(0, -12),
      paint,
    );
  }
}
