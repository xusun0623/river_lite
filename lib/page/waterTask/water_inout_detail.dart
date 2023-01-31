import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:html/parser.dart';
import 'package:offer_show/asset/bigScreen.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/home_desktop_mode.dart';
import 'package:offer_show/asset/refreshIndicator.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/components/newNaviBar.dart';
import 'package:offer_show/components/totop.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/util/mid_request.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
import 'package:provider/provider.dart';

class WaterInoutDetail extends StatefulWidget {
  WaterInoutDetail({Key key}) : super(key: key);

  @override
  State<WaterInoutDetail> createState() => _WaterInoutDetailState();
}

class _WaterInoutDetailState extends State<WaterInoutDetail> {
  var data = [];
  bool loading = false;
  bool load_done = false;
  bool showBackToTop = false;
  ScrollController _scrollController = new ScrollController();
  /* { "type": "", "change": "", "detail": "", "time": "" } */

  List<Widget> _buildCont() {
    List<Widget> tmp = [];
    if (data != null && data.length != 0) {
      data.forEach((element) {
        tmp.add(ResponsiveWidget(child: ListCard(data: element)));
      });
    }
    return tmp;
  }

  _getData(bool isInit) async {
    if (loading) return;
    loading = true;
    if (isInit) {
      String score_txt = await getStorage(key: "score", initData: "");
      if (score_txt != "") {
        setState(() {
          data = jsonDecode(score_txt);
        });
      }
    }
    if (data.length % 20 != 0 && !isInit) return;
    List<Map> tmp_ret = [];
    var document = parse((await XHttp().pureHttpWithCookie(
      url: base_url +
          "home.php?mod=spacecp&op=log&ac=credit&page=" +
          (isInit ? 1 : (data.length / 20 + 1).floor()).toString(),
    ))
        .data
        .toString());
    try {
      var element = document.getElementsByTagName("table").last;
      var tr = element.getElementsByTagName("tr");
      for (int i = 1; i < tr.length; i++) {
        var tr_tmp = tr[i];
        tmp_ret.add({
          "add": tr_tmp.getElementsByTagName("span").first.innerHtml[0] == "-"
              ? 0
              : 1, //是否是加水 1-是 0-否
          "type": tr_tmp.getElementsByTagName("a").first.innerHtml,
          "change": "水滴 " + tr_tmp.getElementsByTagName("span").first.innerHtml,
          "detail": tr_tmp
              .getElementsByTagName("a")
              .last
              .innerHtml
              .replaceAll("<strong>", "")
              .replaceAll("</strong>", ""),
          "time": tr_tmp.getElementsByTagName("td").last.innerHtml,
        });
      }
    } catch (e) {}
    if (!isInit) {
      data.addAll(tmp_ret);
    } else {
      setStorage(key: "score", value: jsonEncode(tmp_ret));
      data = tmp_ret;
    }
    if (tmp_ret.length < 20) load_done = true;
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          _getData(false);
        }
        if (_scrollController.position.pixels > 200 && !showBackToTop) {
          setState(() {
            showBackToTop = true;
          });
        }
        if (_scrollController.position.pixels < 200 && showBackToTop) {
          setState(() {
            showBackToTop = false;
          });
        }
      });
    });
    _getData(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Baaaar(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Provider.of<ColorProvider>(context).isDark
              ? os_dark_back
              : os_white,
          elevation: 0,
          title: Text("积分记录", style: TextStyle(fontSize: 16)),
          foregroundColor: Provider.of<ColorProvider>(context).isDark
              ? os_dark_white
              : os_black,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.chevron_left_rounded),
          ),
        ),
        backgroundColor: Provider.of<ColorProvider>(context).isDark
            ? os_dark_back
            : os_white,
        body: getMyRrefreshIndicator(
          context: context,
          onRefresh: () async {
            data = [];
            return await _getData(true);
          },
          child: BackToTop(
            show: showBackToTop,
            bottom: 100,
            color: isDesktop() ? os_black : Color(0x88FFFFFF),
            widget: Icon(
              Icons.arrow_drop_up,
              size: 25,
              color: os_white,
            ),
            controller: _scrollController,
            child: ListView(
              controller: _scrollController,
              children: [
                ..._buildCont(),
                load_done ? Container() : BottomLoading(),
              ],
              //physics: BouncingScrollPhysics(),
            ),
          ),
        ),
      ),
    );
  }
}

class ListCard extends StatefulWidget {
  int type; //0-加水 1-扣水
  Map data;
  ListCard({
    Key key,
    this.type,
    this.data,
  }) : super(key: key);

  @override
  State<ListCard> createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  @override
  Widget build(BuildContext context) {
    return Bounce(
      duration: Duration(milliseconds: 100),
      onPressed: () {},
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 7.5, vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0, 1],
            colors: (widget.data["add"] ?? 1) == 1
                ? [Color(0xFF252B36), Color(0xFF47505B)]
                : [Color(0xFFE83C2D), Color(0xFFFA6E54)],
          ),
        ),
        child: Stack(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data["type"] ?? "帖子评分",
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.8),
                      fontSize: 14,
                    ),
                  ),
                  Container(height: 5),
                  Text(
                    widget.data["change"] ?? "水滴+6",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: os_white,
                    ),
                  ),
                  Container(height: 5),
                  Text(
                    widget.data["detail"] ??
                        "给 4月22日天府绿道100km环骑经验分享 的帖子评分扣除的积分",
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.8),
                      fontSize: 15,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Container(height: 7.5),
                  Text(
                    widget.data["time"] ?? "2022-05-02 18:07",
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.4),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: os_svg(
                width: 110,
                height: 110,
                path: "lib/img/water.svg",
              ),
            )
          ],
        ),
      ),
    );
  }
}
