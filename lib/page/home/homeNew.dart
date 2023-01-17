import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:offer_show/asset/bigScreen.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/home_desktop_mode.dart';
import 'package:offer_show/asset/mouse_speed.dart';
import 'package:offer_show/asset/showPop.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/asset/vibrate.dart';
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
  GlobalKey<RefreshIndicatorState> _indicatorKey =
      GlobalKey<RefreshIndicatorState>();

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
          XSVibrate();
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
    speedUp(_scrollController);
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

  showPopNew() {
    Widget getImgCard(String path) {
      return Image.asset(
        path,
        width: MediaQuery.of(context).size.width > 500
            ? 160
            : (MediaQuery.of(context).size.width - 80 - MinusSpace(context)) /
                2,
        height: MediaQuery.of(context).size.width > 500
            ? 160 * 88 / 160
            : (MediaQuery.of(context).size.width - 80 - MinusSpace(context)) /
                2 *
                88 /
                160,
      );
    }

    showPopWithHeightColor(
      context,
      [
        Center(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            width: 40,
            height: 6,
            decoration: BoxDecoration(
              color: Provider.of<ColorProvider>(context, listen: false).isDark
                  ? os_light_dark_card
                  : os_middle_grey,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
        Container(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () async {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, "/new", arguments: 25);
              },
              child: getImgCard("lib/img/home/new_topic.png"),
            ),
            ...(MediaQuery.of(context).size.width > 500
                ? [Container(width: 10)]
                : []),
            GestureDetector(
              onTap: () {},
              child: getImgCard("lib/img/home/new_pic_topic.png"),
            ),
          ],
        ),
        Container(height: 50),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Text(
                "推荐板块",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFA9A9A9),
                ),
              ),
            ],
          ),
        ),
        Container(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: wrapNew(),
        ),
      ],
      550,
      os_white,
    );
  }

  Widget wrapNew() {
    List<String> columnString = ["二手专区", "情感专区", "密语区", "鹊桥", "吃喝玩乐", "就业创业"];
    List<Widget> tapBtn() {
      List<Widget> tmp = [];
      columnString.forEach((element) {
        tmp.add(
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              if (element == "二手专区") {
                Navigator.of(context).pushNamed("/new_transaction");
              }
              if (element == "情感专区") {
                Navigator.of(context).pushNamed("/new", arguments: 45);
              }
              if (element == "鹊桥") {
                Navigator.of(context).pushNamed("/new", arguments: 313);
              }
              if (element == "密语区") {
                Navigator.of(context).pushNamed("/new", arguments: 371);
              }
              if (element == "吃喝玩乐") {
                Navigator.of(context).pushNamed("/new", arguments: 370);
              }
              if (element == "就业创业") {
                Navigator.of(context).pushNamed("/new", arguments: 174);
              }
            },
            child: Container(
              width: isDesktop()
                  ? null
                  : (MediaQuery.of(context).size.width -
                          MinusSpace(context) -
                          90) /
                      3,
              margin: EdgeInsets.only(left: 5, right: 5, bottom: 10),
              padding: EdgeInsets.symmetric(horizontal: 17.5, vertical: 12.5),
              decoration: BoxDecoration(
                color: Provider.of<ColorProvider>(context, listen: false).isDark
                    ? os_light_dark_card
                    : Color(0xFFF1F4F8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  element,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Provider.of<ColorProvider>(context, listen: false)
                            .isDark
                        ? os_dark_dark_white
                        : Color(0xFF42546B),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        );
      });
      return tmp;
    }

    return Wrap(
      children: tapBtn(),
    );
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
        t.add(Topic(isLeftNaviUI: isDesktop() && true, data: i));
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
                XSVibrate();
                setState(() {
                  loading = false;
                  load_done = false;
                  _getData();
                });
              },
            )
          : BottomLoading(
              color: Colors.transparent,
              txt: "努力加载中…",
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
      refresh: () {
        _indicatorKey.currentState.show();
      },
      tap: () {
        // Navigator.pushNamed(context, "/new_transaction");
        showPopNew();
      },
      child: ListView(
        controller: _scrollController,
        children: t,
      ),
      controller: _scrollController,
    );
  }

  @override
  Widget build(BuildContext context) {
    ColorProvider provider_color = Provider.of<ColorProvider>(context);
    return Scaffold(
      backgroundColor: provider_color.isDark ? os_dark_back : os_back,
      body: Container(
        padding: EdgeInsets.only(top: 10),
        child: RefreshIndicator(
          key: _indicatorKey,
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
        // color: provider.isDark ? Color(0xFF111111) : os_back,
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
          Navigator.pushNamed(context, "/search", arguments: 0);
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
