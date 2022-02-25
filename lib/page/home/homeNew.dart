import 'package:flutter/material.dart';
import 'package:noripple_overscroll/noripple_overscroll.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/components/topic.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/util/interface.dart';

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

  @override
  void initState() {
    super.initState();
    _getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("触底");
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

  _getData() async {
    if (loading || load_done) return;
    loading = true;
    int pageSize = 20;
    var tmp = await Api().forum_topiclist({
      "page": (data.length / pageSize + 1).toInt(),
      "pageSize": pageSize,
      "sortby": "all"
    });
    if (tmp["list"] != null && tmp["list"].length != 0) {
      data.addAll(tmp["list"]);
    }
    load_done = (tmp["list"] == null || tmp["list"].length < pageSize);
    loading = false;
    setState(() {});
  }

  Widget _buildComponents() {
    List<Widget> t = [];
    if (data != null && data.length != 0) {
      for (var i in data) {
        t.add(Topic(data: i));
      }
    }
    t.add(
      load_done || data.length == 0
          ? Container()
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
      child: ListView(
        controller: _scrollController,
        children: t,
      ),
      controller: _scrollController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: os_back,
      body: RefreshIndicator(
        color: os_color,
        onRefresh: () async {
          data = [];
          return await _getData();
        },
        child: NoRippleOverScroll(
          child: _buildComponents(),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class BackToTop extends StatefulWidget {
  ScrollController controller;
  Widget child;
  bool show;
  BackToTop({
    Key key,
    this.child,
    this.show,
    this.controller,
  }) : super(key: key);

  @override
  _BackToTopState createState() => _BackToTopState();
}

class _BackToTopState extends State<BackToTop> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: widget.child,
        ),
        Positioned(
            right: widget.show ? 20 : -200,
            bottom: 20,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 10,
                    offset: Offset(3, 3),
                  ),
                ],
              ),
              child: myInkWell(
                tap: () {
                  widget.controller.animateTo(
                    0,
                    duration: Duration(milliseconds: 1),
                    curve: Curves.ease,
                  );
                },
                color: os_color,
                widget: Container(
                  width: 50,
                  height: 50,
                  child: Icon(
                    Icons.arrow_upward_sharp,
                    color: os_white,
                  ),
                ),
                radius: 100,
              ),
            ))
      ],
    );
  }
}
