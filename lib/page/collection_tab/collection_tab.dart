import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:html/parser.dart';
import 'package:offer_show/asset/bigScreen.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/mouse_speed.dart';
import 'package:offer_show/asset/refreshIndicator.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/vibrate.dart';
import 'package:offer_show/asset/xs_textstyle.dart';
import 'package:offer_show/components/collection.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/components/totop.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/util/mid_request.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
import 'package:provider/provider.dart';

class CollectionTab extends StatefulWidget {
  @override
  _CollectionTabState createState() => _CollectionTabState();
}

class _CollectionTabState extends State<CollectionTab>
    with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController = new ScrollController();
  List? mydata = [];
  List? data = [];
  var loading = false;
  var load_done = false;
  bool showBackToTop = false;
  bool vibrate = false;
  int pageSize = 25;
  int filter_type = 0; //0-按主题数排序 1-按评论数排序 2-按订阅数排序
  bool switchLoading = false;
  GlobalKey<RefreshIndicatorState> _indicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    _getMydata(); //获取我的收藏
    speedUp(_scrollController);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels < -100) {
        if (!vibrate) {
          vibrate = true; //不允许再震动
          XSVibrate().impact();
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
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50) {
        _getData();
      }
    });
    super.initState();
  }

  _getMydata() async {
    String mylist = await getStorage(key: "mylist", initData: "");
    String list = await getStorage(key: "list", initData: "");
    //缓存模块
    if (mylist != "") {
      setState(() {
        mydata = jsonDecode(mylist);
      });
    }
    if (list != "") {
      setState(() {
        data = jsonDecode(list);
      });
    }
    await _getData(isInit: true, isMine: true);
    await setStorage(key: "mylist", value: jsonEncode(mydata));
    await _getData(isInit: true);
    await setStorage(key: "list", value: jsonEncode(data));
    setState(() {
      switchLoading = false;
    });
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
                "forum.php?mod=collection&op=all&order=${[
                  "follownum",
                  "commentnum",
                  "threadnum",
                ][filter_type]}&page=${isInit ? 1 : (data!.length / 20).ceil() + 1}",
        hadCookie: isInit ? false : true, //第二次请求时使用原有Cookie
      ))
          .data
          .toString();
    } catch (e) {
      d_tmp = "还没有淘专辑";
    }
    if (d_tmp.contains("还没有淘专辑")) {
      setState(() {
        if (!isMine) load_done = true;
        loading = false;
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
                .attributes["href"]!
                .split("&uid=")[1]), //专辑的创建者ID
            "list_id": int.parse(dl
                .getElementsByClassName("xi2")[1]
                .attributes["href"]!
                .split("&ctid=")[1]
                .split("&fromop")[0]), //专辑ID
            "subs_num":
                int.parse(dl.getElementsByClassName("xi2").first.innerHtml),
            "subs_txt": isMine ? "主题数" : ["订阅数", "评论数", "主题数"][filter_type],
            "tags": _getTag(dl), //专辑的标签
            "type": isMine ? 0 : 2, //0-黑 1-红 2-白
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
          data!.addAll(tmp);
        }
        setState(() {
          load_done = data!.length % 20 != 0;
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

  List<String?> _getTag(t) {
    List<String?> tmp = [];
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
    if ((data!.length != 0 || loading) && isDesktop()) {
      // t.add(Container(height: 5));
      t.add(ListTab(
          loading: switchLoading,
          index: filter_type,
          tap: (idx) {
            setState(() {
              switchLoading = true;
              filter_type = idx;
              data = [];
            });
            _getMydata();
          }));
      // t.add(Container(height: 5));
    }
    if (mydata!.length != 0) {
      mydata!.forEach((element) {
        t.add(GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              "/list",
              arguments: element,
            );
          },
          child: Collection(
            data: element,
            removeMargin: true,
          ),
        ));
      });
      // t.add(Container(height: 10));
    }
    if ((data!.length != 0 || loading) && !isDesktop()) {
      // t.add(Container(height: 5));
      t.add(ListTab(
          loading: switchLoading,
          index: filter_type,
          tap: (idx) {
            setState(() {
              switchLoading = true;
              filter_type = idx;
              data = [];
            });
            _getMydata();
          }));
      // t.add(Container(height: 5));
    }
    data!.forEach((element) {
      t.add(GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            "/list",
            arguments: element,
          );
        },
        child: Collection(
          data: element,
          removeMargin: true,
        ),
      ));
    });
    if (!load_done) {
      t.add(BottomLoading());
      if (data!.length == 0)
        t.add(Container(height: MediaQuery.of(context).size.height));
    }
    t.add(Container(height: 15));
    if (load_done && data!.length == 0 && mydata!.length == 0) {
      t.add(Container(height: MediaQuery.of(context).size.height));
    }
    return t;
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:
          Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: getMyRrefreshIndicator(
        context: context,
        key: _indicatorKey,
        color: os_color,
        onRefresh: () async {
          return await _getMydata();
        },
        child: BackToTop(
          show: showBackToTop,
          refresh: () {
            _indicatorKey.currentState!.show();
          },
          animation: true,
          bottom: 50,
          child: MasonryGridView.count(
            physics: AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            itemCount: _buildComponents().length,
            padding: EdgeInsets.all(os_edge),
            crossAxisCount: w > 1200 ? 3 : (w > 800 ? 2 : 1),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            itemBuilder: (BuildContext context, int index) {
              return _buildComponents()[index];
            },
          ),
          controller: _scrollController,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ListTab extends StatefulWidget {
  int? index;
  Function? tap;
  bool? loading;
  ListTab({
    Key? key,
    this.index,
    this.tap,
    this.loading,
  }) : super(key: key);

  @override
  State<ListTab> createState() => _ListTabState();
}

class _ListTabState extends State<ListTab> {
  List<Widget> _buildCont() {
    List<Widget> tmp = [];
    for (var i = 0; i < 3; i++) {
      tmp.add(Container(
        child: myInkWell(
          tap: () {
            widget.tap!(i);
          },
          radius: 10,
          color: widget.index == i
              ? (Provider.of<ColorProvider>(context).isDark
                  ? os_white_opa
                  : os_black_opa)
              : Colors.transparent,
          widget: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.5, vertical: 7.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Text(
              ["订阅数", "评论数", "主题数"][i],
              style: XSTextStyle(
                context: context,
                fontWeight:
                    widget.index == i ? FontWeight.bold : FontWeight.normal,
                color: (Provider.of<ColorProvider>(context).isDark
                    ? os_dark_dark_white
                    : os_dark_card),
              ),
            ),
          ),
        ),
      ));
    }
    return tmp;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(width: 10),
          ..._buildCont(),
          Container(width: (widget.loading ?? false) ? 5 : 0),
          (widget.loading ?? false)
              ? Container(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Provider.of<ColorProvider>(context).isDark
                        ? os_dark_white
                        : os_black,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
