import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/components/loading.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/components/nomore.dart';
import 'package:offer_show/components/topic.dart';
import 'package:offer_show/components/totop.dart';
import 'package:offer_show/outer/showActionSheet/action_item.dart';
import 'package:offer_show/outer/showActionSheet/bottom_action_item.dart';
import 'package:offer_show/outer/showActionSheet/bottom_action_sheet.dart';
import 'package:offer_show/outer/showActionSheet/top_action_item.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/util/interface.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool manualPull = false;
  bool showTopTitle = false; //是否显示顶部标题

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
    if (tmp != null && tmp["list"] != null) data["list"].addAll(tmp["list"]);
    load_done = data["list"].length < 10;
    loading_more = false;
    setState(() {});
  }

  _getData() async {
    setState(() {
      if (!manualPull) loading = true;
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
    if (data["rs"] != 0) {
      // await Future.delayed(Duration(milliseconds: 200));
      var list = data["classificationType_list"];
      theme = ["全部分栏"];
      if (list != null && list.length != 0) {
        for (var i = 0; i < list.length; i++) {
          theme.add(list[i]["classificationType_name"]);
        }
      }
      loading = false;
      load_done = (data["list"] ?? []).length < 10;
    } else {
      loading = false;
      load_done = true;
    }
    setState(() {});
    return;
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
            isScrollControlled: true,
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
            bottomActionItem: BottomActionItem(
              title: "取消",
              titleTextStyle: TextStyle(
                fontSize: 18,
              ),
            ),
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
      load_done ? NoMore() : BottomLoading(color: Colors.transparent),
    );
    return tmp;
  }

  bool vibrate = false;

  @override
  void initState() {
    _getData();
    _controller.addListener(() {
      if (_controller.position.pixels > 80) {
        setState(() {
          showTopTitle = true;
        });
      } else {
        setState(() {
          showTopTitle = false;
        });
      }
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        _getMore();
      }
      if (_controller.position.pixels < -100) {
        if (!vibrate) {
          vibrate = true; //不允许再震动
          Vibrate.feedback(FeedbackType.impact);
        }
      }
      if (_controller.position.pixels >= 0) {
        vibrate = false; //允许震动
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
          title: Text(
            showTopTitle ? data["forumInfo"]["title"] : "",
            style: TextStyle(
              color: os_black,
              fontSize: 16,
            ),
          ),
          backgroundColor: os_back,
          elevation: 0,
        ),
        body: data == null || data["list"] == null
            ? Loading(
                showError: load_done,
                msg: "帖子专栏走丢了，或许网页端可以连接该星球",
                backgroundColor: os_back,
                tapTxt: "前往网页版 >",
                tap: () {
                  launch(
                      "https://bbs.uestc.edu.cn/forum.php?mod=forumdisplay&fid=${widget.columnID}");
                },
              )
            : BackToTop(
                animation: false,
                show: showBackToTop,
                bottom: 100,
                controller: _controller,
                child: RefreshIndicator(
                  onRefresh: () async {
                    manualPull = true;
                    await _getData();
                    vibrate = false;
                    manualPull = false;
                    return;
                  },
                  child: ListView(
                    controller: _controller,
                    physics: BouncingScrollPhysics(),
                    children: _buildCont(),
                  ),
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
      width: MediaQuery.of(context).size.width - os_edge * 2,
      margin: EdgeInsets.symmetric(horizontal: os_edge),
      child: myInkWell(
        tap: () {
          widget.fold();
        },
        radius: 15,
        widget: Container(
          height: 60,
          padding: EdgeInsets.only(left: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width - 95,
                child: Text(
                  widget.themes[widget.select],
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
              Container(
                width: 60,
                height: 60,
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF004FFF),
                ),
              ),
            ],
          ),
        ),
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
