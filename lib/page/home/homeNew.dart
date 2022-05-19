import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/components/hot_btn.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/components/topic.dart';
import 'package:offer_show/components/totop.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
import 'package:provider/provider.dart';

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
  bool vibrate = false;
  int pageSize = 25;

  @override
  void initState() {
    super.initState();
    _getStorageData();
    _getInitData();
    _scrollController =
        Provider.of<HomeRefrshProvider>(context, listen: false).send;
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
        .forum_topiclist({"page": 1, "pageSize": pageSize, "sortby": "new"});
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
    var tmp = await Api().forum_topiclist({
      "page": (data.length / pageSize + 1).toInt(),
      "pageSize": pageSize,
      "sortby": "new"
    });
    Api().forum_topiclist({
      "page": (data.length / pageSize + 1).toInt() + 1,
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
    t.add(HomeBtn());
    if (data.length == 0 && !load_done) {
      t.add(Container(
        padding: EdgeInsets.symmetric(vertical: 50),
        child: Column(
          children: [
            BottomLoading(
              color: Colors.transparent,
              txt: "初次连接星球中(下拉可以刷新)…",
            ),
          ],
        ),
      ));
    }
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
          ? TapMore(
              tap: () {
                Vibrate.feedback(FeedbackType.impact);
                setState(() {
                  loading = false;
                  load_done = false;
                  _getData();
                });
              },
            )
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
      bottom: 50,
      animation: true,
      attachBtn: true,
      tap: () {
        Navigator.pushNamed(context, "/new", arguments: 25);
      },
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
    HomeRefrshProvider provider = Provider.of<HomeRefrshProvider>(context);
    ColorProvider provider_color = Provider.of<ColorProvider>(context);
    return Scaffold(
      backgroundColor: provider_color.os_back,
      body: Container(
        padding: EdgeInsets.only(top: 10),
        child: RefreshIndicator(
          color: os_color,
          onRefresh: () async {
            var data = await _getInitData();
            vibrate = false;
            return data;
          },
          child: _buildComponents(),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class TapMore extends StatefulWidget {
  Function tap;
  TapMore({
    Key key,
    this.tap,
  }) : super(key: key);

  @override
  State<TapMore> createState() => _TapMoreState();
}

class _TapMoreState extends State<TapMore> {
  @override
  Widget build(BuildContext context) {
    ColorProvider provider = Provider.of<ColorProvider>(context);
    return GestureDetector(
      onTap: () {
        widget.tap();
      },
      child: Container(
        color: provider.os_back,
        child: Center(
            child: Padding(
          padding: EdgeInsets.only(top: 20, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "加载更多",
                style: TextStyle(color: os_deep_grey),
              ),
              Icon(
                Icons.keyboard_double_arrow_down_rounded,
                size: 16,
                color: os_deep_grey,
              )
            ],
          ),
        )),
      ),
    );
  }
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
      {this.borderSide = const BorderSide(width: 2.0, color: Colors.black87),
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
