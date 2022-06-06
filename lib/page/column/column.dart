import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:lottie/lottie.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/mouse_speed.dart';
import 'package:offer_show/asset/nowMode.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/components/loading.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/components/nomore.dart';
import 'package:offer_show/components/topic.dart';
import 'package:offer_show/components/totop.dart';
import 'package:offer_show/outer/card_swiper/swiper.dart';
import 'package:offer_show/outer/showActionSheet/action_item.dart';
import 'package:offer_show/outer/showActionSheet/bottom_action_item.dart';
import 'package:offer_show/outer/showActionSheet/bottom_action_sheet.dart';
import 'package:offer_show/outer/showActionSheet/top_action_item.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/mid_request.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
  List topData = []; //置顶信息
  var select = 0;
  var data;
  bool loading = false;
  bool loading_more = false;
  bool load_done = false;
  bool showBackToTop = false;
  bool fold = true;
  bool manualPull = false;
  bool showTopTitle = false; //是否显示顶部标题
  bool need_50_water = false; //密语区需要支付50水滴才行

  int pageSize = 25;

  _getMore() async {
    if (loading_more || load_done) return;
    loading_more = true;
    var tmp = await Api().certain_forum_topiclist({
      "page": (data["list"].length / pageSize + 1).toInt(),
      "pageSize": pageSize,
      "boardId": widget.columnID,
      "filterType": "typeid",
      "filterId": data == null || select == 0
          ? ""
          : data["classificationType_list"][select - 1]
              ["classificationType_id"],
      "sortby": "all",
    });
    Api().certain_forum_topiclist({
      "page": (data["list"].length / pageSize + 1).toInt() + 1,
      "pageSize": pageSize,
      "boardId": widget.columnID,
      "filterType": "typeid",
      "filterId": data == null || select == 0
          ? ""
          : data["classificationType_list"][select - 1]
              ["classificationType_id"],
      "sortby": "all",
    });
    if (tmp != null && tmp["list"] != null) data["list"].addAll(tmp["list"]);
    load_done = data["list"].length < pageSize;
    loading_more = false;
    setState(() {});
  }

  _getData() async {
    setState(() {
      if (!manualPull) loading = true;
      fold = true;
    });
    var tmp = await Api().certain_forum_topiclist({
      "page": 1,
      "pageSize": pageSize,
      "boardId": widget.columnID,
      "filterType": "typeid",
      "filterId": data == null || select == 0
          ? ""
          : data["classificationType_list"][select - 1]
              ["classificationType_id"],
      "sortby": "all",
      "topOrder": 1,
    });
    Api().certain_forum_topiclist({
      "page": 2,
      "pageSize": pageSize,
      "boardId": widget.columnID,
      "filterType": "typeid",
      "filterId": data == null || select == 0
          ? ""
          : data["classificationType_list"][select - 1]
              ["classificationType_id"],
      "sortby": "all",
      "topOrder": 1,
    });
    if (tmp["rs"] != 0) {
      topData = tmp["topTopicList"];
      data = tmp;
      var list = tmp["classificationType_list"];
      theme = ["全部分栏"];
      if (list != null && list.length != 0) {
        for (var i = 0; i < list.length; i++) {
          theme.add(list[i]["classificationType_name"]);
        }
      }
      loading = false;
      load_done = (data["list"] ?? []).length < pageSize;
    } else {
      String tmp_txt = jsonEncode(tmp);
      if (tmp_txt.contains("您需要支付 50 滴水滴才能进入此版块")) {
        print("您需要支付 50 滴水滴才能进入此版块");
        setState(() {
          need_50_water = true;
        });
      }
      loading = false;
      load_done = true;
    }
    setState(() {});
    return;
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
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_white
                    : os_black,
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
                        color: Provider.of<ColorProvider>(context).isDark
                            ? os_dark_white
                            : os_black,
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
    tmp.add(TopSection(data: topData));
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
    speedUp(_controller);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    nowMode(context);
    return Scaffold(
        backgroundColor:
            Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.chevron_left_rounded),
            color: Provider.of<ColorProvider>(context).isDark
                ? os_dark_dark_white
                : os_black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/search");
                },
                icon: Icon(
                  Icons.search,
                  color: os_deep_grey,
                )),
            Container(width: 5),
          ],
          title: Text(
            showTopTitle ? data["forumInfo"]["title"] : "",
            style: TextStyle(
              color: Provider.of<ColorProvider>(context).isDark
                  ? os_dark_dark_white
                  : os_black,
              fontSize: 16,
            ),
          ),
          backgroundColor: Provider.of<ColorProvider>(context).isDark
              ? (!loading ? os_dark_back : os_light_dark_card)
              : os_back,
          elevation: 0,
        ),
        body: data == null || data["list"] == null
            ? Loading(
                showError: load_done,
                msg: need_50_water
                    ? "您需要支付50滴水滴且升级至2级才能进入此版块，支付一次，永久有效。客户端可能有延时，需要等候后才能查看"
                    : "帖子专栏走丢了，或许网页端可以连接该星球",
                backgroundColor: os_back,
                tapTxt1: need_50_water ? "重新刷新一次 >" : "前往网页版 >",
                tapTxt: need_50_water ? "去网页版河畔支付 >" : "重新刷新一次 >",
                loadingWidget: Opacity(
                  opacity: 0.8,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 500,
                      maxHeight: 500,
                    ),
                    child: Lottie.asset("lib/lottie/book.json"),
                  ),
                ),
                tap: () {
                  if (need_50_water) {
                    launchUrlString(
                      base_url + "forum.php?mod=forumdisplay&fid=371&mobile=no",
                    );
                  } else {
                    setState(() {
                      load_done = false;
                      loading = false;
                      _getData();
                    });
                  }
                },
                tap1: need_50_water
                    ? () {
                        setState(() {
                          load_done = false;
                          loading = false;
                          _getData();
                        });
                      }
                    : () {
                        launchUrlString(
                          base_url +
                              "forum.php?mod=forumdisplay&fid=${widget.columnID}",
                        );
                      },
              )
            : BackToTop(
                animation: false,
                show: showBackToTop,
                bottom: 100,
                controller: _controller,
                attachBtn: true,
                tap: () {
                  Navigator.pushNamed(
                    context,
                    "/new",
                    arguments: widget.columnID,
                  );
                },
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

class TopSection extends StatefulWidget {
  List data;
  TopSection({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  State<TopSection> createState() => _TopSectionState();
}

class _TopSectionState extends State<TopSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: os_edge),
      margin: EdgeInsets.only(top: 10),
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: Swiper(
          physics: BouncingScrollPhysics(),
          loop: false,
          autoplay: true,
          autoplayDelay: 3000,
          itemCount: widget.data.length,
          itemBuilder: (context, index) {
            return myInkWell(
              color: Provider.of<ColorProvider>(context).isDark
                  ? os_light_dark_card
                  : os_white,
              tap: () {
                Navigator.pushNamed(context, "/topic_detail",
                    arguments: widget.data[widget.data.length - 1 - index]
                        ["id"]);
              },
              radius: 0,
              widget: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Icon(
                      Icons.vertical_align_top_rounded,
                      size: 18,
                      color: Provider.of<ColorProvider>(context).isDark
                          ? os_dark_white
                          : os_black,
                    ),
                    Container(width: 7.5),
                    Container(
                      width: MediaQuery.of(context).size.width - 80,
                      child: Text(
                        widget.data[widget.data.length - 1 - index]["title"]
                            .toString()
                            .split("")
                            .join("\u{200B}"),
                        style: TextStyle(
                            color: Provider.of<ColorProvider>(context).isDark
                                ? os_dark_white
                                : os_black),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
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
        color: Provider.of<ColorProvider>(context).isDark
            ? os_light_dark_card
            : os_white,
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
                    color: Provider.of<ColorProvider>(context).isDark
                        ? os_dark_white
                        : os_black,
                  ),
                ),
              ),
              Container(
                width: 60,
                height: 60,
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_dark_dark_white
                      : Color(0xFF004FFF),
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
