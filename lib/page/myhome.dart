import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/page/home/homeHot.dart';
import 'package:offer_show/page/home/homeNew.dart';

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> with TickerProviderStateMixin {
  TabController _tabController;

  final List<String> _tabValues = [
    "热帖",
    "新回复",
    "入站必看",
    "专辑",
    "抢沙发",
  ];

  List<Widget> _list = <Widget>[
    HomeHot(),
    HomeNew(),
    HomeNew(),
    HomeNew(),
    HomeNew(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabValues.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: os_back,
        appBar: AppBar(
          backgroundColor: os_back,
          elevation: 0.0,
          actions: [
            myInkWell(
              tap: () {
                Navigator.pushNamed(context, "/search");
              },
              radius: 100,
              color: Colors.transparent,
              widget: Container(
                width: 60,
                height: 30,
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    child: Center(
                      child: os_svg(
                        path: "lib/img/search.svg",
                        width: 22,
                        height: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(2)),
          ],
          title: TabBar(
            isScrollable: true,
            labelColor: os_black,
            labelPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            unselectedLabelColor: os_deep_grey,
            labelStyle: TextStyle(fontSize: 18),
            indicator: TabSizeIndicator(
              wantWidth: 20,
              borderSide: BorderSide(width: 3.0, color: Color(0xFF0092FF)),
            ),
            tabs: _tabValues.map((e) {
              return Tab(text: e);
            }).toList(),
            controller: _tabController,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: TabBarView(
          controller: _tabController,
          physics: CustomTabBarViewScrollPhysics(),
          children: _list,
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
    return Rect.fromLTWH(cw - wantWidth / 2,
        indicator.bottom - borderSide.width, wantWidth, borderSide.width);
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
      indicator.bottomLeft.translate(0, -7.5),
      indicator.bottomRight.translate(0, -7.5),
      paint,
    );
  }
}

class CustomTabBarViewScrollPhysics extends ScrollPhysics {
  const CustomTabBarViewScrollPhysics({ScrollPhysics parent})
      : super(parent: parent);

  @override
  CustomTabBarViewScrollPhysics applyTo(ScrollPhysics ancestor) {
    return CustomTabBarViewScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 50,
        stiffness: 100,
        damping: 0.8,
      );
}
