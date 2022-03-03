import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/components/topic.dart';
import 'package:offer_show/components/totop.dart';
import 'package:offer_show/outer/showActionSheet/action_item.dart';
import 'package:offer_show/outer/showActionSheet/bottom_action_sheet.dart';
import 'package:offer_show/outer/showActionSheet/top_action_item.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/util/interface.dart';

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
  ScrollController _controller = new ScrollController();
  ScrollController _tabController = new ScrollController();
  List<String> theme = [];
  var select = 0;
  var data;
  bool loading = false;
  bool loading_more = false;
  bool load_done = false;
  bool showBackToTop = false;
  bool fold = true;

  _getMore() async {
    if (loading_more || load_done) return;
    loading_more = true;
    var tmp = await Api().certain_forum_topiclist({
      "page": (data["list"].length / 10 + 1).toInt(),
      "pageSize": 10,
      "boardId": widget.columnID,
      "filterType": "typeid",
      "filterId": data == null || select == 0
          ? ""
          : data["classificationType_list"][select - 1]
              ["classificationType_id"],
      "sortby": "new",
    });
    data["list"].addAll(tmp["list"]);
    load_done = data["list"].length < 10;
    loading_more = false;
    setState(() {});
  }

  _getData() async {
    setState(() {
      loading = true;
      fold = true;
    });
    data = await Api().certain_forum_topiclist({
      "page": 1,
      "pageSize": 10,
      "boardId": widget.columnID,
      "filterType": "typeid",
      "filterId": data == null || select == 0
          ? ""
          : data["classificationType_list"][select - 1]
              ["classificationType_id"],
      "sortby": "new",
    });
    await Future.delayed(Duration(milliseconds: 200));
    var list = data["classificationType_list"];
    theme = ["全部"];
    for (var i = 0; i < list.length; i++) {
      theme.add(list[i]["classificationType_name"]);
    }
    loading = false;
    load_done = data["list"].length < 10;
    setState(() {});
  }

  void _toTop() {
    _controller.animateTo(
      0.0,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  List<ActionItem> _buildSheet() {
    List<ActionItem> tmp = [];
    for (var i = 0; i < theme.length; i++) {
      tmp.add(
        ActionItem(
          title: theme[i],
          onPressed: () {
            select = i;
            setState(() {});
            _getData();
            Navigator.pop(context);
          },
        ),
      );
    }
    return tmp;
  }

  List<Widget> _buildCont() {
    List<Widget> tmp = [];
    tmp.addAll([
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Row(
          children: [
            Text(
              data["forumInfo"]["title"],
              style: TextStyle(
                fontSize: 29,
                fontWeight: FontWeight.w900,
              ),
            ),
            Container(width: 10),
            loading
                ? Container(
                    margin: EdgeInsets.only(top: 5),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: os_black,
                        strokeWidth: 2.5,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
      Container(height: 30),
      DefineTabBar(
        select: select,
        themes: theme,
        controller: _tabController,
        fold: () {
          showActionSheet(
            topActionItem: TopActionItem(
              showBottomLine: false,
              title: "请选择分栏",
              titleTextStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            actionSheetColor: os_white,
            enableDrag: true,
            context: context,
            actions: _buildSheet(),
          );
        },
        tap: (idx) {
          select = idx;
          _getData();
          setState(() {});
        },
      )
    ]);
    data["list"].forEach((e) {
      tmp.add(Topic(
        data: e,
      ));
    });
    tmp.add(
      load_done
          ? Container(height: 15)
          : BottomLoading(color: Colors.transparent),
    );
    return tmp;
  }

  @override
  void initState() {
    _getData();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        _getMore();
      }

      if (_controller.position.pixels > 1000 && !showBackToTop) {
        setState(() {
          showBackToTop = true;
        });
      }
      if (_controller.position.pixels < 1000 && showBackToTop) {
        setState(() {
          showBackToTop = false;
        });
      }
    });
    super.initState();
  }

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
            : BackToTop(
                animation: false,
                show: showBackToTop,
                bottom: 100,
                controller: _controller,
                child: ListView(
                  controller: _controller,
                  physics: BouncingScrollPhysics(),
                  children: _buildCont(),
                ),
              ));
  }
}

class DefineTabBar extends StatefulWidget {
  int select;
  List<String> themes;
  Function tap;
  Function fold;
  ScrollController controller;
  DefineTabBar({
    Key key,
    @required this.select,
    @required this.themes,
    @required this.tap,
    @required this.controller,
    @required this.fold,
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
  void initState() {
    super.initState();
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
              controller: widget.controller,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
              scrollDirection: Axis.horizontal,
              children: _buildList(),
            ),
          ),
          myInkWell(
            tap: () {
              widget.fold();
            },
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
