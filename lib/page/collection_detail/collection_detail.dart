import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/to_user.dart';
import 'package:offer_show/components/collection.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/components/totop.dart';
import 'package:offer_show/outer/cached_network_image/cached_image_widget.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/util/mid_request.dart';

class CollectionDetail extends StatefulWidget {
  Map data;
  CollectionDetail({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  State<CollectionDetail> createState() => _CollectionDetailState();
}

class _CollectionDetailState extends State<CollectionDetail> {
  List data = [];
  ScrollController _scrollController = new ScrollController();
  bool showBackToTop = false;
  bool loading = false;
  bool load_done = false;
  bool load_card = false;
  bool is_subscribed = false;
  String action_url = "";

  List<Widget> _buildCont() {
    List<Widget> tmp = [];
    data.forEach((element) {
      tmp.add(ListCard(data: element));
    });
    if (!load_done) {
      tmp.add(BottomLoading());
    }
    return tmp;
  }

  _setShadow() async {
    setState(() {
      widget.data["isShadow"] = true;
    });
  }

  _getCardData() async {
    String d_tmp = (await XHttp().pureHttpWithCookie(
      url: base_url +
          "forum.php?mod=collection&action=view&ctid=${widget.data["list_id"]}",
    ))
        .data
        .toString();
    var document = parse(d_tmp);
    try {
      widget.data["desc"] = document
          .getElementsByClassName("mn")
          .first
          .getElementsByClassName("bm_c")
          .first
          .getElementsByTagName("div")
          .last
          .innerHtml;
      is_subscribed = document
          .getElementsByClassName("clct_flw")
          .first
          .innerHtml
          .contains("取消订阅");
      setState(() {
        load_card = true;
      });
    } catch (e) {
      print("${e}");
    }
  }

  _getData({
    bool isInit = false, //是否强制请求第一页数据
  }) async {
    if (load_done && !isInit) return;
    if (loading) return;
    loading = true;
    String d_tmp = (await XHttp().pureHttpWithCookie(
      url: base_url +
          "forum.php?mod=collection&action=view&ctid=${widget.data["list_id"]}&page=${isInit ? 1 : ((data.length / 120).ceil() + 1)}",
      hadCookie: true,
    ))
        .data
        .toString();
    if (d_tmp.contains("暂时没有内容")) {
      setState(() {
        load_done = true;
      });
      return;
    } else {
      var document = parse(d_tmp);
      try {
        var element = document.getElementsByTagName("table")[1];
        var trs = element.getElementsByTagName("tr");
        List tmp = [];
        for (var i = 0; i < trs.length; i++) {
          var tr = trs[i];
          tmp.add({
            "name": tr
                .getElementsByTagName("th")
                .first
                .getElementsByTagName("a")
                .first
                .innerHtml,
            "topic_id": int.parse(tr
                .getElementsByTagName("th")
                .first
                .getElementsByTagName("a")
                .first
                .attributes["href"]
                .toString()
                .split("&tid=")[1]
                .split("&ctid")[0]),
            "user_name":
                tr.getElementsByTagName("cite").first.innerHtml.contains("匿名")
                    ? "匿名"
                    : tr
                        .getElementsByTagName("cite")
                        .first
                        .getElementsByTagName("a")
                        .first
                        .innerHtml,
            "uid":
                tr.getElementsByTagName("cite").first.innerHtml.contains("匿名")
                    ? 0
                    : int.parse(tr
                        .getElementsByTagName("cite")
                        .first
                        .getElementsByTagName("a")
                        .first
                        .attributes["href"]
                        .toString()
                        .split("&uid=")[1]),
            "reply": int.parse(tr
                .getElementsByClassName("num")
                .first
                .getElementsByTagName("a")
                .first
                .innerHtml),
            "view": int.parse(tr
                .getElementsByClassName("num")
                .first
                .getElementsByTagName("em")
                .first
                .innerHtml),
            "time": tr
                    .getElementsByClassName("by")
                    .first
                    .getElementsByTagName("em")
                    .first
                    .innerHtml
                    .contains("span") //简短时间信息
                ? tr
                    .getElementsByClassName("by")
                    .first
                    .getElementsByTagName("em")
                    .first
                    .getElementsByTagName("span")
                    .first
                    .innerHtml
                    .replaceAll("&nbsp;", " ")
                : tr
                    .getElementsByClassName("by")
                    .first
                    .getElementsByTagName("em")
                    .first
                    .innerHtml,
            "essence": tr
                .getElementsByTagName("img")
                .last
                .attributes["title"]
                .toString()
                .contains("精华"),
          });
        }
        if (isInit) {
          data = tmp;
        } else {
          data.addAll(tmp);
        }
        setState(() {
          load_done = data.length % 120 != 0;
        });
      } catch (e) {
        setState(() {
          load_done = true;
        });
      }
    }
    loading = false;
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
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
    _setShadow();
    _getData(isInit: true);
    _getCardData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF1F4F8),
        foregroundColor: os_black,
        elevation: 0,
        actions: load_card
            ? [
                TextButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(os_dark_back),
                    overlayColor: MaterialStateProperty.all(os_black_opa),
                  ),
                  child: Text(is_subscribed ? "取消订阅" : "订阅"),
                )
              ]
            : [],
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Color(0xFFF1F4F8),
      body: RefreshIndicator(
        color: [
          Color(0xFF282d38),
          Color(0xFFd64b39),
          Color(0xFF282d38),
        ][widget.data["type"]],
        onRefresh: () async {
          return await Future.delayed(Duration(milliseconds: 500));
        },
        child: BackToTop(
          color: [
            Color(0xFF282d38),
            Color(0xFFe9775d),
            Color(0xFF282d38),
          ][widget.data["type"]],
          controller: _scrollController,
          show: showBackToTop,
          bottom: 100,
          child: ListView(
            controller: _scrollController,
            children: [
              Collection(data: widget.data),
              Container(height: 40),
              data.length == 0 && !load_done
                  ? Container()
                  : Center(
                      child: Text(
                        "- 本专辑收录的帖子 -",
                        style: TextStyle(
                          color: Color(0xFFA3A3A3),
                        ),
                      ),
                    ),
              data.length == 0 && !load_done
                  ? Container()
                  : Container(height: 15),
              ..._buildCont(),
            ],
          ),
        ),
      ),
    );
  }
}

class ListCard extends StatefulWidget {
  Map data;
  /**
   * name 淘贴名称       String
   * topic_id 帖子ID    int
   * uid 用户ID         int
   * user_name 用户名   String
   * reply 回复数       int
   * view 查看数        int
   * time 时间          String
   * essence 精华       bool
   */
  ListCard({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  State<ListCard> createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: os_edge, vertical: 5),
      child: myInkWell(
        tap: () {
          Navigator.pushNamed(
            context,
            "/topic_detail",
            arguments: widget.data["topic_id"],
          );
        },
        color: os_white,
        radius: 10,
        widget: Container(
          padding: EdgeInsets.only(top: 15, bottom: 16, left: 19, right: 5),
          decoration: BoxDecoration(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  if (widget.data["uid"] != "" && widget.data["uid"] != 0)
                    toUserSpace(context, widget.data["uid"]);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  child: CachedNetworkImage(
                    width: 50,
                    height: 50,
                    placeholder: (context, url) => Container(
                      color: os_grey,
                    ),
                    fit: BoxFit.cover,
                    imageUrl: base_url +
                        "uc_server/avatar.php?uid=${widget.data["uid"]}&size=middle",
                  ),
                ),
              ),
              Container(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${widget.data["user_name"]}",
                          style: TextStyle(
                            color: Color(0xFF444444),
                          ),
                        ),
                        myInkWell(
                          color: Colors.transparent,
                          widget: Icon(
                            Icons.more_horiz_outlined,
                            size: 20,
                            color: Color(0xFF888888),
                          ),
                          radius: 5,
                          tap: () {},
                        )
                      ],
                    ),
                  ),
                  Container(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 170,
                        child: Text(
                          widget.data["name"] ?? "淘贴名称",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(height: widget.data["essence"] ? 7.5 : 0),
                  widget.data["essence"]
                      ? Container(
                          decoration: BoxDecoration(
                            color: os_color_opa,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 7.5, vertical: 2.5),
                          child: Row(
                            children: [
                              Icon(
                                Icons.verified_user,
                                color: os_color,
                                size: 15,
                              ),
                              Container(width: 2.5),
                              Text(
                                "精华",
                                style: TextStyle(
                                  color: os_color,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  Container(height: 7.5),
                  Row(
                    children: [
                      Text(
                        "${widget.data["reply"]}回复 · ${widget.data["view"]}查看",
                        style: TextStyle(
                          color: Color(0xFF9C9C9C),
                        ),
                      ),
                      Container(width: 5),
                      Text(
                        "/",
                        style: TextStyle(
                          color: Color(0xFFDCDCDC),
                        ),
                      ),
                      Container(width: 5),
                      Text(
                        widget.data["time"].toString(),
                        style: TextStyle(
                          color: Color(0xFF9C9C9C),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
