import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:html/parser.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/components/collection.dart';
import 'package:offer_show/components/totop.dart';
import 'package:offer_show/page/login/login_helper.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/util/mid_request.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class CollectionTab extends StatefulWidget {
  @override
  _CollectionTabState createState() => _CollectionTabState();
}

class _CollectionTabState extends State<CollectionTab>
    with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController = new ScrollController();
  List mydata = [];
  List data = [];
  var loading = false;
  var load_done = false;
  bool showBackToTop = false;
  bool vibrate = false;
  int pageSize = 25;

  @override
  void initState() {
    _getMydata(); //获取我的收藏
    _scrollController.addListener(() {
      if (_scrollController.position.pixels < -100) {
        if (!vibrate) {
          vibrate = true; //不允许再震动
          Vibrate.feedback(FeedbackType.impact);
        }
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
      if (_scrollController.position.pixels >= 0) {
        vibrate = false; //允许震动
      }
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getData();
      }
    });
    super.initState();
  }

  _getMydata() async {
    await _getData(isInit: true, isMine: true);
    await _getData(isInit: true);
  }

  _getData({bool isInit = false, bool isMine = false}) async {
    if (loading) return;
    loading = true;
    String d_tmp;
    try {
      d_tmp = (await XHttp().pureHttpWithCookie(
        url: isMine
            ? base_url + "forum.php?mod=collection&op=my"
            : base_url +
                "forum.php?mod=collection&op=all&order=follownum&page=${isInit ? 1 : (data.length / 20).ceil() + 1}",
        hadCookie: isInit ? false : true, //第二次请求时使用原有Cookie
      ))
          .data
          .toString();
    } catch (e) {
      d_tmp = "还没有淘专辑";
    }
    if (d_tmp.contains("还没有淘专辑")) {
      setState(() {
        load_done = true;
      });
      return;
    } else {
      var document = parse(d_tmp);
      try {
        var element = document.getElementsByClassName("clct_list").first;
        var dls = element.getElementsByTagName("dl");
        List tmp = [];
        for (var i = 0; i < dls.length; i++) {
          var dl = dls[i];
          tmp.add({
            "name": dl
                .getElementsByClassName("xw1")
                .first
                .getElementsByTagName("a")
                .first
                .innerHtml, //专辑的名称
            "desc": dl
                .getElementsByTagName("dd")[1]
                .getElementsByTagName("p")
                .first
                .innerHtml, //专辑的描述
            "user": dl
                .getElementsByTagName("dd")[1]
                .getElementsByClassName("xg1")
                .first
                .getElementsByTagName("a")
                .first
                .innerHtml, //专辑的创建者姓名
            "head": base_url +
                "uc_server/avatar.php?uid=${int.parse(dl.getElementsByClassName("xg1").first.getElementsByTagName("a").first.attributes["href"].toString().split("&uid=")[1])}&size=middle", //专辑的创建者头像
            "user_id": int.parse(dl
                .getElementsByTagName("dd")[1]
                .getElementsByClassName("xg1")
                .first
                .getElementsByTagName("a")
                .first
                .attributes["href"]
                .split("&uid=")[1]), //专辑的创建者ID
            "list_id": int.parse(dl
                .getElementsByClassName("xi2")[1]
                .attributes["href"]
                .split("&ctid=")[1]
                .split("&fromop")[0]), //专辑ID
            "subs_num":
                int.parse(dl.getElementsByClassName("xi2").first.innerHtml),
            "tags": _getTag(dl), //专辑的标签
            "type": isMine
                ? 1
                : (int.parse(dl.getElementsByClassName("xi2")[0].innerHtml) > 30
                    ? 0
                    : 2), //0-黑 1-红 2-白
            "isShadow": false, //true-阴影 false-无阴影
          });
        }
        if (isInit) {
          if (isMine) {
            mydata = tmp;
          } else {
            data = tmp;
          }
        } else {
          data.addAll(tmp);
        }
        setState(() {
          load_done = data.length % 20 != 0;
        });
      } catch (e) {
        print("${e}");
        setState(() {
          load_done = true;
        });
      }
    }
    loading = false;
  }

  List<String> _getTag(t) {
    List<String> tmp = [];
    if (t.innerHtml.toString().contains("ctag_keyword")) {
      t
          .getElementsByClassName("ctag_keyword")
          .first
          .getElementsByTagName("a")
          .forEach((ele) {
        tmp.add(ele.innerHtml);
      });
    }
    return tmp;
  }

  List<Widget> _buildComponents() {
    List<Widget> t = [];
    if (mydata.length != 0) {
      t.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            "- 我订阅的专辑 -",
            style: TextStyle(color: os_deep_grey),
          ),
        ),
      ));
      mydata.forEach((element) {
        t.add(GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              "/list",
              arguments: element,
            );
          },
          child: Collection(data: element),
        ));
      });
      t.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            "- 热门专辑 -",
            style: TextStyle(color: os_deep_grey),
          ),
        ),
      ));
    }
    data.forEach((element) {
      t.add(GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            "/list",
            arguments: element,
          );
        },
        child: Collection(data: element),
      ));
    });
    if (!load_done) {
      t.add(BottomLoading());
    }
    t.add(Container(height: 15));
    return t;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: RefreshIndicator(
        color: os_color,
        onRefresh: () async {
          return await _getData(isInit: true);
        },
        child: BackToTop(
          show: showBackToTop,
          animation: true,
          bottom: 50,
          child: ListView(
            physics: BouncingScrollPhysics(),
            controller: _scrollController,
            children: _buildComponents(),
          ),
          controller: _scrollController,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
