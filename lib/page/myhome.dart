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
  final List<String> _tabValues = ["新回复", "热帖"];
  var index = 0;
  List<Widget> _list = <Widget>[
    HomeNew(),
    HomeHot(),
  ];

  @override
  void initState() {
    super.initState();
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
            SeachBtn(),
            Padding(padding: EdgeInsets.all(2)),
          ],
          title: Row(
            children: [
              TabTip(
                txt: "热门",
                tap: () {
                  setState(() {
                    index = 0;
                  });
                },
                select: index == 0,
              ),
              TabTip(
                txt: "新回复",
                tap: () {
                  setState(() {
                    index = 1;
                  });
                },
                select: index == 1,
              ),
            ],
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: _list[index],
      ),
    );
  }
}

class TabTip extends StatefulWidget {
  bool select;
  String txt;
  Function tap;
  TabTip({
    Key key,
    @required this.select,
    @required this.txt,
    @required this.tap,
  }) : super(key: key);

  @override
  State<TabTip> createState() => _TabTipState();
}

class _TabTipState extends State<TabTip> {
  @override
  Widget build(BuildContext context) {
    return myInkWell(
      tap: () {
        widget.tap();
      },
      color: Colors.transparent,
      widget: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Text(
              widget.txt,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Container(height: 3),
            Container(
              width: 18,
              height: 3,
              decoration: BoxDecoration(
                color: widget.select ? os_color : Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ],
        ),
      ),
      radius: 0,
    );
  }
}

class SeachBtn extends StatelessWidget {
  const SeachBtn({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return myInkWell(
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
    );
  }
}
