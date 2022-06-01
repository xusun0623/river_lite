import 'dart:convert';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:offer_show/asset/black.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/to_user.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/outer/cached_network_image/cached_image_widget.dart';
import 'package:offer_show/outer/card_swiper/flutter_page_indicator/flutter_page_indicator.dart';
import 'package:offer_show/outer/card_swiper/swiper.dart';
import 'package:offer_show/outer/card_swiper/swiper_control.dart';
import 'package:offer_show/outer/card_swiper/swiper_controller.dart';
import 'package:offer_show/outer/card_swiper/swiper_pagination.dart';
import 'package:offer_show/outer/showActionSheet/action_item.dart';
import 'package:offer_show/outer/showActionSheet/bottom_action_item.dart';
import 'package:offer_show/outer/showActionSheet/bottom_action_sheet.dart';
import 'package:offer_show/page/photo_view/photo_view.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
import 'package:provider/provider.dart';

class PicSquare extends StatefulWidget {
  PicSquare({Key key}) : super(key: key);

  @override
  State<PicSquare> createState() => _PicSquareState();
}

class _PicSquareState extends State<PicSquare> with TickerProviderStateMixin {
  TabController _tabController;
  SwiperController _swiperController;
  List<Map> photo = [];

  int column_id = 307;
  int classify_id = 0;
  bool loading_more = false;
  bool load_done = false;
  int pageSize = 10;
  int swiper_index = 0;

  _getMore() async {
    if (loading_more || load_done) return;
    loading_more = true;
    var tmp = await Api().certain_forum_topiclist({
      "page": (photo.length / pageSize + 1).toInt(),
      "pageSize": pageSize,
      "boardId": column_id,
      "filterType": "typeid",
      "filterId": classify_id == 0 ? "" : classify_id,
      "sortby": "all",
    });
    Api().certain_forum_topiclist({
      "page": (photo.length / pageSize + 1).toInt() + 1,
      "pageSize": pageSize,
      "boardId": column_id,
      "filterType": "typeid",
      "filterId": classify_id == 0 ? "" : classify_id,
      "sortby": "all",
    });
    if (tmp != null && tmp["list"] != null) photo.addAll(tmp["list"]);
    load_done = tmp.length < pageSize;
    loading_more = false;
    setState(() {});
  }

  _getData() async {
    var tmp = await Api().certain_forum_topiclist({
      "page": 1,
      "pageSize": pageSize,
      "boardId": column_id,
      "filterType": "typeid",
      "filterId": classify_id == 0 ? "" : classify_id,
      "sortby": "all",
      "topOrder": 1,
    });
    if (tmp["rs"] != 0) {
      List<Map> tmp_photo = [];
      for (var i = 0; i < tmp["list"].length; i++) {
        var ele = tmp["list"][i];
        tmp_photo.add({
          "topic_id": ele["topic_id"], //帖子ID
          "uid": ele["user_id"], //用户ID
          "photo": [],
          "head_img": ele["userAvatar"],
          "name": ele["user_nick_name"],
          "like": ele["recommendAdd"],
          "title": ele["title"],
          "cont": ele["subject"],
        });
      }
      setState(() {
        photo = [];
      });
      await Future.delayed(Duration(milliseconds: 5));
      setState(() {
        photo = tmp_photo;
        swiper_index = 0;
      });
      _swiperController.move(0);
    }
  }

  @override
  void initState() {
    _tabController = TabController(
      length: 7,
      vsync: this,
    );
    _swiperController = new SwiperController();
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        leadingWidth: 0,
        elevation: 0,
        backgroundColor: os_dark_back,
        foregroundColor: os_white,
        title: TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: os_white,
          indicator: BubbleTabIndicator(
            indicatorHeight: 25.0,
            indicatorColor: Color.fromRGBO(255, 255, 255, 0.2),
            tabBarIndicatorSize: TabBarIndicatorSize.tab,
          ),
          isScrollable: true,
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          tabs: [
            Tab(text: "镜头下的成电"),
            Tab(text: "风光"),
            Tab(text: "人像"),
            Tab(text: "人文"),
            Tab(text: "小品"),
            Tab(text: "技术"),
            Tab(text: "杂片"),
          ],
        ),
      ),
      backgroundColor: os_dark_back,
      floatingActionButton: swiper_index == 0
          ? null
          : FloatingActionButton(
              backgroundColor: Color(0x22FFFFFF),
              child: Icon(Icons.refresh),
              onPressed: () {
                _getData();
              },
            ),
      body: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: MediaQuery.of(context).size.height,
        ),
        child: RefreshIndicator(
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.2),
          color: os_white,
          onRefresh: () async {
            return await _getData();
          },
          child: Swiper(
            fade: 0.1,
            scrollDirection: Axis.vertical,
            loop: false,
            itemCount: photo.length,
            scale: 0.8,
            physics: DefineSwiperPhySics(),
            controller: _swiperController,
            onIndexChanged: (idx) {
              setState(() {
                swiper_index = idx;
              });
            },
            itemBuilder: (context, index) {
              return PhotoCard(
                data: photo[index],
              );
            },
          ),
        ),
      ),
    );
  }
}

class PhotoCard extends StatefulWidget {
  Map data;
  PhotoCard({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  State<PhotoCard> createState() => _PhotoCardState();
}

class _PhotoCardState extends State<PhotoCard> {
  bool isLiked = false;
  bool isBlack = false;
  String blackKeyWord = ""; //拉黑关键字

  void _getLikeStatus() async {
    //获取点赞状态
    String tmp = await getStorage(key: "topic_like", initData: "");
    List<String> ids = tmp.split(",");
    if (ids.indexOf(widget.data["topic_id"].toString()) > -1) {
      setState(() {
        isLiked = true;
      });
    }
  }

  _tapLike() async {
    Vibrate.feedback(FeedbackType.impact);
    if (!isLiked) {
      setState(() {
        isLiked = true;
      });
      await Api().forum_support({
        "tid": widget.data["topic_id"],
        "type": "thread",
        "action": "support",
      });
      String tmp = await getStorage(
        key: "topic_like",
      );
      tmp += ",${widget.data['topic_id']}";
      setStorage(key: "topic_like", value: tmp);
    } else {
      print("在此点赞但是点过赞了");
    }
  }

  _feedbackSuccess() async {
    showToast(
      context: context,
      type: XSToast.success,
      txt: "已举报",
    );
  }

  bool _isBlack() {
    bool flag = false;
    Provider.of<BlackProvider>(context, listen: false).black.forEach((element) {
      if (widget.data["title"].toString().contains(element) ||
          widget.data["cont"].toString().contains(element) ||
          widget.data["name"].toString().contains(element)) {
        flag = true;
        blackKeyWord = element;
      }
    });
    return flag;
  }

  _feedback() async {
    String txt = "";
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      backgroundColor: Provider.of<ColorProvider>(context, listen: false).isDark
          ? os_light_dark_card
          : os_white,
      context: context,
      builder: (context) {
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: 30,
          ),
          height: MediaQuery.of(context).size.height - 100,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 30),
              Text(
                "请输入举报内容",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_dark_white
                      : os_black,
                ),
              ),
              Container(height: 10),
              Container(
                height: 60,
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color:
                      Provider.of<ColorProvider>(context, listen: false).isDark
                          ? os_white_opa
                          : os_grey,
                ),
                child: Center(
                  child: TextField(
                    onChanged: (e) {
                      txt = e;
                    },
                    style: TextStyle(
                      color: Provider.of<ColorProvider>(context, listen: false)
                              .isDark
                          ? os_dark_white
                          : os_black,
                    ),
                    cursorColor: os_deep_blue,
                    decoration: InputDecoration(
                        hintText: "请输入",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color:
                              Provider.of<ColorProvider>(context, listen: false)
                                      .isDark
                                  ? os_dark_dark_white
                                  : os_deep_grey,
                        )),
                  ),
                ),
              ),
              Container(height: 10),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: myInkWell(
                      tap: () {
                        Navigator.pop(context);
                      },
                      color: Provider.of<ColorProvider>(context, listen: false)
                              .isDark
                          ? os_white_opa
                          : Color(0x16004DFF),
                      widget: Container(
                        width: (MediaQuery.of(context).size.width - 60) / 2 - 5,
                        height: 40,
                        child: Center(
                          child: Text(
                            "取消",
                            style: TextStyle(
                              color: Provider.of<ColorProvider>(context).isDark
                                  ? os_dark_dark_white
                                  : os_deep_blue,
                            ),
                          ),
                        ),
                      ),
                      radius: 12.5,
                    ),
                  ),
                  Container(
                    child: myInkWell(
                      tap: () async {
                        await Api().user_report({
                          "idType": "thread",
                          "message": txt,
                          "id": widget.data["topic_id"]
                        });
                        Navigator.pop(context);
                        _feedbackSuccess();
                      },
                      color: os_deep_blue,
                      widget: Container(
                        width: (MediaQuery.of(context).size.width - 60) / 2 - 5,
                        height: 40,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.done, color: os_white, size: 18),
                              Container(width: 5),
                              Text(
                                "完成",
                                style: TextStyle(
                                  color: os_white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      radius: 12.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  _tapMore() async {
    Vibrate.feedback(FeedbackType.impact);
    showActionSheet(
      context: context,
      actions: [
        ActionItem(
            title: "【不感兴趣】屏蔽此贴",
            onPressed: () async {
              await setBlackWord(widget.data["title"], context);
              Navigator.pop(context);
              showToast(context: context, type: XSToast.success, txt: "屏蔽成功");
              setState(() {
                isBlack = true;
              });
            }),
        ActionItem(
            title: "【不感兴趣】屏蔽此人",
            onPressed: () async {
              await setBlackWord(widget.data["name"], context);
              Navigator.pop(context);
              showToast(context: context, type: XSToast.success, txt: "屏蔽成功");
              setState(() {
                isBlack = true;
              });
            }),
        ActionItem(
            title: "收藏",
            onPressed: () async {
              Navigator.pop(context);
              showToast(context: context, type: XSToast.loading);
              await Api().user_userfavorite({
                "idType": "tid",
                "action": "favorite",
                "id": widget.data["topic_id"],
              });
              hideToast();
              showToast(context: context, type: XSToast.success, txt: "收藏成功");
            }),
        ActionItem(
            title: "复制帖子链接",
            onPressed: () async {
              Clipboard.setData(
                ClipboardData(
                    text:
                        "https://bbs.uestc.edu.cn/forum.php?mod=viewthread&tid=" +
                            widget.data["topic_id"].toString()),
              );
              Navigator.pop(context);
              showToast(context: context, type: XSToast.success, txt: "复制成功");
            }),
        ActionItem(
            title: "举报反馈",
            onPressed: () async {
              Navigator.pop(context);
              _feedback();
            }),
      ],
      bottomActionItem: BottomActionItem(title: "取消"),
    );
  }

  String _removeGif(String s) {
    //移除文本中的表情包
    String tmp_s = "";
    if (s.contains("mobcent_phiz")) {
      List<String> tmp = s.split("[mobcent_phiz=");
      tmp_s += tmp[0];
      for (var i = 1; i < tmp.length; i++) {
        tmp_s += " " + tmp[i].split("]")[1];
      }
    } else {
      tmp_s += s;
    }
    tmp_s = tmp_s.replaceAll("\n", " ");
    tmp_s = tmp_s.replaceAll("\r", "");
    return tmp_s;
  }

  _getData() async {
    String photo_txt = await getStorage(
        key: "photo_" + widget.data["topic_id"].toString(), initData: "");
    String photo_desc_txt = await getStorage(
      key: "photo_desc_" + widget.data["topic_id"].toString(),
      initData: "",
    );
    if (photo_txt != "") {
      //从缓存中拿数据
      widget.data["photo"] = jsonDecode(photo_txt);
      widget.data["cont"] = photo_desc_txt;
    } else {
      var tmp = await Api().forum_postlist({
        "topicId": widget.data["topic_id"],
        "authorId": 0,
        "order": 0,
        "page": 1,
        "pageSize": 0,
      });
      if (tmp["rs"] != 0) {
        var content_tmp = tmp["topic"]["content"];
        String photo_desc_tmp = "";
        List<String> photo_tmp = [];
        for (var i = 0; i < content_tmp.length; i++) {
          var cont_tmp = content_tmp[i];
          if (cont_tmp["type"] == 1) {
            photo_tmp.add(cont_tmp["originalInfo"]);
          }
          if (cont_tmp["type"] == 0) {
            print("${cont_tmp}");
            if (cont_tmp["infor"].toString().contains("编辑 \r\n\r\n")) {
              photo_desc_tmp += " " +
                  _removeGif(
                    cont_tmp["infor"].toString().split("编辑 \r\n\r\n")[1],
                  );
            } else {
              photo_desc_tmp += " " + _removeGif(cont_tmp["infor"].toString());
            }
          }
          print("描述数据 ${photo_desc_tmp}");
        }
        widget.data["photo"] = photo_tmp;
        widget.data["cont"] = photo_desc_tmp;
        setStorage(
          key: "photo_desc_" + widget.data["topic_id"].toString(),
          value: photo_desc_tmp,
        );
        setStorage(
          key: "photo_" + widget.data["topic_id"].toString(),
          value: jsonEncode(photo_tmp),
        );
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    _getLikeStatus();
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isBlack || _isBlack()
        ? Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  178,
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: Center(
              child: Container(
                width: 300,
                child: Text(
                  "已拉黑的内容，拉黑关键字为：" + blackKeyWord,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: os_dark_dark_white,
                  ),
                ),
              ),
            ),
          )
        : Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  178,
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: Stack(
              children: [
                widget.data["photo"].length == 0
                    ? Center(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 100),
                          child: Text(
                            "请求中…",
                            style: TextStyle(color: os_dark_dark_white),
                          ),
                        ),
                      )
                    : Swiper(
                        itemCount: widget.data["photo"].length,
                        loop: false,
                        duration: 100,
                        pagination: new SwiperPagination(
                          builder: DotSwiperPaginationBuilder(
                            color: Colors.white54,
                            activeColor: Colors.white,
                            size: 7.5,
                            activeSize: 10,
                            space: 10,
                          ),
                        ),
                        indicatorLayout: PageIndicatorLayout.WARM,
                        itemBuilder: (context, index) {
                          return Center(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 100),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PhotoPreview(
                                        galleryItems: widget.data["photo"],
                                        defaultImage: index,
                                      ),
                                    ),
                                  );
                                },
                                onDoubleTap: () {
                                  _tapLike();
                                },
                                onLongPress: () {
                                  _tapMore();
                                },
                                child: Container(
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    child: Hero(
                                      tag: widget.data["photo"][index],
                                      child: CachedNetworkImage(
                                        placeholder: (context, url) => Center(
                                          child: Opacity(
                                            opacity: 0.3,
                                            child: BottomLoading(
                                              color: Colors.transparent,
                                              txt: "",
                                            ),
                                          ),
                                        ),
                                        imageUrl: widget.data["photo"][index],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                PicBottom(
                  isLiked: isLiked,
                  tapLike: () {
                    _tapLike();
                  },
                  tapMore: () {
                    _tapMore();
                  },
                  data: widget.data,
                ),
              ],
            ),
          );
  }
}

class PicBottom extends StatefulWidget {
  var data;
  bool isLiked;
  Function tapLike;
  Function tapMore;
  PicBottom({
    Key key,
    this.data,
    this.isLiked,
    this.tapLike,
    this.tapMore,
  }) : super(key: key);

  @override
  State<PicBottom> createState() => _PicBottomState();
}

class _PicBottomState extends State<PicBottom> {
  _toDetail() {
    Navigator.pushNamed(
      context,
      "/topic_detail",
      arguments: widget.data["topic_id"],
    );
  }

  //底部按钮
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0, 0.5, 1],
            colors: [Colors.transparent, Colors.black38, Colors.black54],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  width: MediaQuery.of(context).size.width - 140,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        child: GestureDetector(
                          onTap: () {
                            toUserSpace(context, widget.data["uid"]);
                          },
                          child: CachedNetworkImage(
                            width: 25,
                            height: 25,
                            fit: BoxFit.cover,
                            imageUrl: widget.data["head_img"],
                          ),
                        ),
                      ),
                      Container(width: 7.5),
                      GestureDetector(
                        onTap: () {
                          _toDetail();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width - 180,
                          // color: os_grey,
                          child: Text(
                            widget.data["title"],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: os_white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 90,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (widget.tapLike != null) {
                            widget.tapLike();
                          }
                        },
                        child: Container(
                          color: Color.fromRGBO(0, 0, 0, 0.001),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  (widget.data["like"] +
                                          (widget.isLiked ?? false ? 1 : 0))
                                      .toString(),
                                  style: TextStyle(
                                    color: widget.isLiked ?? false
                                        ? os_color
                                        : os_white,
                                    fontSize: 14,
                                  ),
                                ),
                                Container(width: 5),
                                Icon(
                                  Icons.thumb_up_alt_sharp,
                                  color: widget.isLiked ?? false
                                      ? os_color
                                      : os_white,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (widget.tapMore != null) {
                            widget.tapMore();
                          }
                        },
                        child: Container(
                          color: Color.fromRGBO(0, 0, 0, 0.001),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.more_horiz,
                                  color: os_white,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(height: 5),
            GestureDetector(
              onTap: () {
                _toDetail();
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                width: MediaQuery.of(context).size.width - 30,
                child: Text(
                  widget.data["cont"].toString().trim() == ""
                      ? widget.data["title"]
                      : widget.data["cont"].toString().trim(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xDDFFFFFF),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Container(height: 10),
            GestureDetector(
              onTap: () {
                _toDetail();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Color.fromRGBO(255, 255, 255, 0.001),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      padding: EdgeInsets.only(
                        left: 8.5,
                        right: 3.5,
                        top: 2.5,
                        bottom: 3.5,
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.1),
                        borderRadius: BorderRadius.all(Radius.circular(2.5)),
                      ),
                      // width: MediaQuery.of(context).size.width - 30,
                      child: Row(
                        children: [
                          Text(
                            "查看评论",
                            style: TextStyle(
                              color: Color(0xDDFFFFFF),
                              fontSize: 13,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: Color(0xDDFFFFFF),
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(height: 27.5),
          ],
        ),
      ),
    );
  }
}

class DefineSwiperPhySics extends ScrollPhysics {
  const DefineSwiperPhySics({ScrollPhysics parent}) : super(parent: parent);

  @override
  DefineSwiperPhySics applyTo(ScrollPhysics ancestor) {
    return DefineSwiperPhySics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 50, //质量
        stiffness: 100, //硬度
        damping: 0.8, //阻尼系数
      );
}
