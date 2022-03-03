import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/components/niw.dart';

class TopicColumn extends StatefulWidget {
  int columnID;
  TopicColumn({
    Key key,
    this.columnID,
  }) : super(key: key);

  @override
  _TopicColumnState createState() => _TopicColumnState();
}

class _TopicColumnState extends State<TopicColumn> {
  var theme = [
    "标题一",
    "标题二",
    "标题三",
    "标题四",
    "标题五",
    "标题六",
    "标题七",
    "标题八",
  ];
  var select = 0;
  var data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: os_back,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded),
          color: os_black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: os_back,
        elevation: 0,
      ),
      body: data == null
          ? Container()
          : ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  child: Text(
                    "视觉艺术",
                    style: TextStyle(
                      fontSize: 29,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Container(height: 30),
                DefineTabBar(
                  select: select,
                  themes: theme,
                  tap: (idx) {
                    setState(() {
                      select = idx;
                    });
                  },
                ),
              ],
            ),
    );
  }
}

class DefineTabBar extends StatefulWidget {
  int select;
  List<String> themes;
  Function tap;
  DefineTabBar({
    Key key,
    @required this.select,
    @required this.themes,
    @required this.tap,
  }) : super(key: key);

  @override
  State<DefineTabBar> createState() => _DefineTabBarState();
}

class _DefineTabBarState extends State<DefineTabBar> {
  List<Widget> _buildList() {
    List<Widget> tmp = [];
    for (var i = 0; i < widget.themes.length; i++) {
      tmp.add(DefineTabBarTip(
        tap: () {
          widget.tap(i);
        },
        selected: widget.select == i,
        txt: widget.themes[i],
      ));
    }
    return tmp;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      height: 60,
      margin: EdgeInsets.symmetric(horizontal: 15),
      padding: EdgeInsets.only(left: 5),
      decoration: BoxDecoration(
        color: os_white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 95,
            child: ListView(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
              scrollDirection: Axis.horizontal,
              children: _buildList(),
            ),
          ),
          myInkWell(
            widget: Container(
              width: 60,
              height: 60,
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF004FFF),
              ),
            ),
            radius: 100,
          ),
        ],
      ),
    );
  }
}

class DefineTabBarTip extends StatefulWidget {
  bool selected;
  String txt;
  Function tap;
  DefineTabBarTip({
    Key key,
    @required this.selected,
    @required this.txt,
    @required this.tap,
  }) : super(key: key);

  @override
  State<DefineTabBarTip> createState() => _DefineTabBarTipState();
}

class _DefineTabBarTipState extends State<DefineTabBarTip> {
  @override
  Widget build(BuildContext context) {
    return myInkWell(
      tap: () {
        widget.tap();
      },
      color: Colors.transparent,
      radius: 5,
      widget: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.txt,
              style: TextStyle(
                fontSize: 16,
                fontWeight:
                    widget.selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Container(height: 4),
            Container(
              width: 16,
              height: 2,
              decoration: BoxDecoration(
                color: widget.selected ? Color(0xFF004FFF) : Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
