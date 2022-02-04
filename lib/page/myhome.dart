import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:loading/indicator.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/components/niw.dart';

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> with SingleTickerProviderStateMixin {
  TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 6, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: os_back,
      appBar: AppBar(
        backgroundColor: os_back,
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: os_svg(path: "lib/img/search.svg", width: 23, height: 23),
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
            borderSide: BorderSide(width: 8.0, color: Color(0x440092FF)),
          ),
          tabs: [
            Tab(text: "新帖"),
            Tab(text: "新回复"),
            Tab(text: '热门'),
            Tab(text: '精华'),
            Tab(text: '专辑'),
            Tab(text: '抢沙发'),
          ],
          controller: tabController,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: TabBarView(
        physics: BouncingScrollPhysics(),
        children: [
          ListView(
            physics: BouncingScrollPhysics(),
            children: [
              myInkWell(
                widget: os_svg(
                  path: "lib/img/home.svg",
                ),
                width: 322,
                height: 196,
                radius: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新发表')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新发表')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新发表')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新发表')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新发表')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新发表')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新发表')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新发表')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新发表')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新发表')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新发表')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新发表')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新发表')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新发表')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新发表')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新发表')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新发表')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新发表')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新发表')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新发表')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新发表')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新发表')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新发表')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新发表')),
              ),
            ],
          ),
          ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新回复')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新回复')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新回复')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新回复')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新回复')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新回复')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新回复')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新回复')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新回复')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新回复')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新回复')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新回复')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新回复')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新回复')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新回复')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新回复')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新回复')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新回复')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新回复')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新回复')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新回复')),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(child: Text('最新回复')),
              ),
            ],
          ),
          Center(child: Text('热门')),
          Center(child: Text('精华')),
          Center(child: Text('专辑')),
          Center(child: Text('抢沙发')),
        ],
        controller: tabController,
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
      indicator.bottomLeft.translate(0, -10),
      indicator.bottomRight.translate(0, -10),
      paint,
    );
  }
}
