import 'dart:convert';
import 'dart:io';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:offer_show/asset/bigScreen.dart';
import 'package:offer_show/asset/black.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/showActionSheet.dart';
import 'package:offer_show/asset/to_user.dart';
import 'package:offer_show/asset/vibrate.dart';
import 'package:offer_show/components/leftNavi.dart';
import 'package:offer_show/emoji/emoji.dart';
import 'package:offer_show/outer/cached_network_image/cached_image_widget.dart';
import 'package:offer_show/outer/card_swiper/swiper.dart';
import 'package:offer_show/outer/card_swiper/swiper_controller.dart';
import 'package:offer_show/outer/card_swiper/swiper_pagination.dart';
import 'package:offer_show/page/photo_view/photo_view.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/util/cache_manager.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/mid_request.dart';
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
  var data;

  int column_index = 1; //Tab的index 0/1 专栏 2~10 分栏
  int column_id = 307; //成电镜头
  int column_id_all = 55; //全部
  //风光 人像 人文 小品 技术 杂片 天文 微距 纪实
  List<int> class_id = [348, 349, 350, 351, 352, 353, 357, 358, 359];
  bool loading_more = false;
  bool load_done = false;
  int pageSize = 10;
  int swiper_index = 0;

  bool loading = false;

  _getMore() async {
    if (loading) return;
    loading = true;
    var tmp = await Api().certain_forum_topiclist({
      "page": (data["list"].length / pageSize) + 1,
      "pageSize": pageSize,
      "boardId": column_index == 0 ? column_id : column_id_all,
      "filterType": "typeid",
      "filterId": (column_index == 0 || column_index == 1)
          ? ""
          : class_id[column_index - 2],
      "sortby": "all",
      "topOrder": 1,
    });
    if (tmp != null && tmp["list"] != null) {
      data["list"].addAll(tmp["list"]);
      List<Map> tmp_list = [];
      if (!(data == null || data["list"] == null)) {
        for (var i = 0; i < data["list"].length; i++) {
          var ele = data["list"][i];
          tmp_list.add({
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
        int tmp_length = photo.length;
        var tmp_change = photo.last;
        setState(() {
          photo = tmp_list;
        });
        setState(() {
          photo[tmp_length - 1] = tmp_change;
        });
      }
    }
    loading = false;
  }

  _getData() async {
    loading = true;
    var tmp = await Api().certain_forum_topiclist({
      "page": 1,
      "pageSize": pageSize,
      "boardId": column_index == 0 ? column_id : column_id_all,
      "filterType": "typeid",
      "filterId": (column_index == 0 || column_index == 1)
          ? ""
          : class_id[column_index - 2],
      "sortby": "all",
      "topOrder": 1,
    });
    if (tmp["rs"] != 0 && tmp["list"] != null) {
      data = tmp;
    }
    loading = false;
    _getPhoto();
  }

  _getPhoto() async {
    List<Map> tmp_list = [];
    if (!(data == null || data["list"] == null)) {
      for (var i = 0; i < data["list"].length; i++) {
        var ele = data["list"][i];
        tmp_list.add({
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
        photo = tmp_list;
        swiper_index = 0;
      });
      _swiperController.move(0);
    }
  }

  bool hasToken = false;
  _getValid() async {
    String tmp_txt = await getStorage(key: "myinfo", initData: "");
    // print("${tmp_txt}");
    if (tmp_txt == "") {
      hasToken = false;
    } else {
      hasToken = true;
    }
    setState(() {});
  }

  @override
  void initState() {
    _getValid();
    _tabController = TabController(
      length: 11,
      vsync: this,
    );
    _tabController.index = 1;
    _swiperController = new SwiperController();
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !hasToken
        ? Scaffold(
            body: GestureDetector(
              onTap: () {
                XSVibrate();
                _getValid();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: os_dark_back,
                child: Center(
                  child: Text(
                    "登录后请点此刷新",
                    style: TextStyle(color: os_dark_dark_white),
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              leading: Container(),
              leadingWidth: 0,
              elevation: 0,
              backgroundColor: os_dark_back,
              foregroundColor: os_white,
              title: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                onTap: ((value) async {
                  showToast(context: context, type: XSToast.loading);
                  setState(() {
                    column_index = value;
                  });
                  await _getData();
                  hideToast();
                }),
                indicator: BubbleTabIndicator(
                  indicatorHeight: 25.0,
                  indicatorColor: Color.fromRGBO(255, 255, 255, 0.2),
                  tabBarIndicatorSize: TabBarIndicatorSize.tab,
                ),
                isScrollable: true,
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                // dividerColor: Colors.transparent,
                labelColor: os_white,
                unselectedLabelColor: Color(0x88ffffff),
                tabs: [
                  Tab(text: "镜头下的成电"),
                  Tab(text: "全部"),
                  Tab(text: "风光"),
                  Tab(text: "人像"),
                  Tab(text: "人文"),
                  Tab(text: "小品"),
                  Tab(text: "技术"),
                  Tab(text: "杂片"),
                  Tab(text: "天文"),
                  Tab(text: "微距"),
                  Tab(text: "纪实"),
                ],
              ),
            ),
            backgroundColor: os_dark_back,
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
                  fade: 0.5,
                  scrollDirection: Axis.vertical,
                  loop: false,
                  itemCount: photo.length,
                  // scale: 0.8,
                  physics: DefineSwiperPhySics(),
                  controller: _swiperController,
                  onIndexChanged: (idx) {
                    setState(() {
                      swiper_index = idx;
                    });
                    if (idx == photo.length - 1) {
                      _getMore();
                    }
                  },
                  itemBuilder: (context, index) {
                    return PhotoCard(
                      refresh: () {
                        _getData();
                      },
                      top: () {
                        print("上一个");
                        if (swiper_index != 0) {
                          _swiperController.previous();
                        }
                      },
                      down: () {
                        if (swiper_index != photo.length) {
                          _swiperController.next();
                        }
                      },
                      data: photo[index],
                      index: index + 1,
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
  int index;
  Function refresh;
  Function top;
  Function down;
  PhotoCard({
    Key key,
    this.data,
    this.index,
    this.refresh,
    this.top,
    this.down,
  }) : super(key: key);

  @override
  State<PhotoCard> createState() => _PhotoCardState();
}

class _PhotoCardState extends State<PhotoCard> {
  bool isLiked = false;
  bool isBlack = false;
  bool load_done = false;
  String blackKeyWord = ""; //拉黑关键字
  int index = 0;
  SwiperController _swiperController = new SwiperController();

  _last() {
    _swiperController.previous();
  }

  _next() {
    _swiperController.next();
  }

  _top() {
    if (widget.top != null) {
      widget.top();
    }
  }

  _down() {
    if (widget.down != null) {
      widget.down();
    }
  }

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
    XSVibrate();
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

  _look_comment() async {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      backgroundColor: Color(0xFF2D2D2D),
      context: context,
      builder: (context) {
        return PopComment(topic_id: widget.data["topic_id"]);
      },
    );
  }

  _tapMore() async {
    XSVibrate();
    showAction(
      context: context,
      options: ["屏蔽此贴", "屏蔽此人", "收藏", "复制帖子链接"],
      icons: [
        Icons.block,
        Icons.person_off_outlined,
        Icons.collections_bookmark_outlined,
        Icons.copy,
      ],
      tap: (res) async {
        if (res == 0) {
          await setBlackWord(widget.data["title"], context);
          Navigator.pop(context);
          showToast(context: context, type: XSToast.success, txt: "屏蔽成功");
          setState(() {
            isBlack = true;
          });
        }
        if (res == 1) {
          await setBlackWord(widget.data["name"], context);
          Navigator.pop(context);
          showToast(context: context, type: XSToast.success, txt: "屏蔽成功");
          setState(() {
            isBlack = true;
          });
        }
        if (res == 2) {
          Navigator.pop(context);
          showToast(context: context, type: XSToast.loading);
          await Api().user_userfavorite({
            "idType": "tid",
            "action": "favorite",
            "id": widget.data["topic_id"],
          });
          hideToast();
          showToast(context: context, type: XSToast.success, txt: "收藏成功");
        }
        if (res == 3) {
          Clipboard.setData(
            ClipboardData(
                text: base_url +
                    "forum.php?mod=viewthread&tid=" +
                    widget.data["topic_id"].toString()),
          );
          Navigator.pop(context);
          showToast(context: context, type: XSToast.success, txt: "复制成功");
        }
      },
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
      // if (widget.data["photo"].length == 0) {
      _getForceData();
      // }
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
            // print("${cont_tmp}");
            if (cont_tmp["infor"].toString().contains("编辑 \r\n\r\n")) {
              photo_desc_tmp += " " +
                  _removeGif(
                    cont_tmp["infor"].toString().split("编辑 \r\n\r\n")[1],
                  );
            } else {
              photo_desc_tmp += " " + _removeGif(cont_tmp["infor"].toString());
            }
          }
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
    setState(() {
      load_done = true;
    });
  }

  _getForceData() async {
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
          // print("${cont_tmp}");
          if (cont_tmp["infor"].toString().contains("编辑 \r\n\r\n")) {
            photo_desc_tmp += " " +
                _removeGif(
                  cont_tmp["infor"].toString().split("编辑 \r\n\r\n")[1],
                );
          } else {
            photo_desc_tmp += " " + _removeGif(cont_tmp["infor"].toString());
          }
        }
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
    setState(() {});
  }

  _toBigThrough() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PhotoPreview(
          galleryItems: widget.data["photo"],
          defaultImage: index,
        ),
      ),
    );
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
                    ? GestureDetector(
                        onTap: () {
                          _getForceData();
                        },
                        child: Container(
                          color: Color(0x01010101),
                          child: Center(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 100),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  load_done
                                      ? Icon(
                                          Icons.crop_original,
                                          color: os_dark_dark_white,
                                          size: 30,
                                        )
                                      : Container(),
                                  Container(height: 10),
                                  Text(
                                    load_done ? "此贴未包含图片" : "请求中…",
                                    style: TextStyle(color: os_dark_dark_white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : Swiper(
                        viewportFraction: 0.9,
                        // scale: 0.9,
                        // indicatorLayout: PageIndicatorLayout.WARM,
                        itemCount: widget.data["photo"].length,
                        loop: false,
                        onTap: (idx) {
                          _toBigThrough();
                        },
                        controller: _swiperController,
                        onIndexChanged: (idx) async {
                          setState(() {
                            index = idx;
                          });
                        },
                        pagination: widget.data["photo"].length == 1
                            ? null
                            : SwiperPagination(
                                // alignment: Alignment.center,
                                builder: DotSwiperPaginationBuilder(
                                  color: Colors.white54,
                                  activeColor: Colors.white,
                                  size: 7.5,
                                  activeSize: 7.5,
                                  space: 2.5,
                                ),
                              ),
                        itemBuilder: (context, index) {
                          return Center(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 100),
                              child: GestureDetector(
                                onTap: () {
                                  _toBigThrough();
                                },
                                // onDoubleTap: () {
                                //   _tapLike();
                                // },
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
                                        progressIndicatorBuilder:
                                            (context, url, progress) => Center(
                                          child: Opacity(
                                            opacity: 0.3,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              color: os_middle_grey,
                                              value: progress.progress,
                                            ),
                                          ),
                                        ),
                                        cacheManager:
                                            RiverListCacheManager.instance,
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
                  index: widget.index,
                  isLiked: isLiked,
                  last: () {
                    this._last();
                  },
                  next: () {
                    this._next();
                  },
                  top: () {
                    this._top();
                  },
                  down: () {
                    this._down();
                  },
                  refresh: () {
                    if (widget.refresh != null) {
                      widget.refresh();
                    }
                  },
                  tapDetail: () {
                    _look_comment();
                  },
                  tapLike: () {
                    _tapLike();
                  },
                  tapMore: () {
                    _tapMore();
                  },
                  data: widget.data,
                ),
                Positioned(
                  right: 10,
                  bottom: 180,
                  child: FloatingActionButton(
                    backgroundColor: Color(0x33FFFFFF),
                    onPressed: () {
                      _look_comment();
                    },
                    child: Icon(Icons.chat_bubble_outline),
                  ),
                ),
              ],
            ),
          );
  }
}

class PopComment extends StatefulWidget {
  int topic_id;
  PopComment({
    Key key,
    this.topic_id,
  }) : super(key: key);

  @override
  State<PopComment> createState() => _PopCommentState();
}

class _PopCommentState extends State<PopComment> {
  bool flag = false;
  ScrollController _scrollController = new ScrollController();
  var comment = [];
  var load_done = false;
  var total_num = 0;
  var data;
  int pageSize = 20;

  _getData() async {
    var tmp = await Api().forum_postlist({
      "topicId": widget.topic_id,
      "authorId": 0,
      "order": 0,
      "page": 1,
      "pageSize": pageSize,
    });
    if (tmp["rs"] != 0) {
      data = tmp;
      comment = tmp["list"];
      load_done = ((tmp["list"] ?? []).length < 20);
      if (total_num == 0) {
        setState(() {
          total_num = data["total_num"];
        });
      }
    } else {
      load_done = true;
      data = null;
    }
    setState(() {});
  }

  _getMore() async {
    if (load_done) return;
    var tmp = await Api().forum_postlist({
      "topicId": widget.topic_id,
      "authorId": 0,
      "order": 0,
      "page": (comment.length / pageSize + 1).floor(),
      "pageSize": pageSize,
    });
    if (tmp["rs"] != 0) {
      comment.addAll(tmp["list"]);
      load_done = ((tmp["list"] ?? []).length < 20);
    } else {
      load_done = true;
    }
    setState(() {});
  }

  List<Widget> _buildCont() {
    List<Widget> tmp = [];
    // tmp.add(Container(height: 5));
    if (comment.length != 0) {
      comment.forEach((element) {
        tmp.add(PopCommentCont(data: element));
      });
    }
    if (!load_done)
      tmp.add(BottomLoading(
        color: Colors.transparent,
      ));
    if (load_done && comment.length == 0) {
      tmp.add(Container(
        child: Column(
          children: [
            Container(height: 100),
            Icon(
              Icons.filter_drama,
              color: os_dark_dark_white,
              size: 50,
            ),
            Container(height: 10),
            Text(
              "这里是一颗空的星球",
              style: TextStyle(
                color: os_dark_dark_white,
              ),
            ),
          ],
        ),
      ));
    }
    return tmp;
  }

  @override
  void initState() {
    _getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMore();
      }
    });
    super.initState();
  }

  //弹出的窗口
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 250,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(height: 15),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  total_num == 0 ? "评论" : "评论(${total_num})",
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        XSVibrate();
                        Navigator.pushNamed(
                          context,
                          "/topic_detail",
                          arguments: widget.topic_id,
                        );
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        color: Color.fromRGBO(255, 255, 255, 0.001),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 0.15),
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                          ),
                          child: Text(
                            "前往详情页",
                            style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 0.7),
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 5,
                          right: 20,
                          top: 10,
                          bottom: 10,
                        ),
                        color: Color.fromRGBO(255, 255, 255, 0.001),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 0.15),
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                          ),
                          child: Icon(
                            Icons.close,
                            size: 22,
                            color: Color.fromRGBO(255, 255, 255, 0.7),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 317,
            child: ListView(
              //physics: BouncingScrollPhysics(),
              controller: _scrollController,
              children: _buildCont(),
            ),
          ),
        ],
      ),
    );
  }
}

class PopCommentCont extends StatefulWidget {
  var data;
  PopCommentCont({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  State<PopCommentCont> createState() => _PopCommentContState();
}

class _PopCommentContState extends State<PopCommentCont> {
  List<Widget> _buildComment() {
    List<Widget> tmp = [];
    for (var i = 0; i < widget.data["reply_content"].length; i++) {
      var tmp_cont = widget.data["reply_content"][i];
      if (tmp_cont["type"] == 0) {
        tmp.add(DetailCont(
          data: tmp_cont,
          imgLists: [],
        ));
      }
    }
    return tmp;
  }

  Widget _buildReply() {
    if (widget.data["quote_content"] == "") return Container();
    return Container(
      child: Container(
        width: MediaQuery.of(context).size.width - 30,
        padding: EdgeInsets.fromLTRB(16, 13, 16, 13),
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Color(0x11FFFFFF),
          borderRadius: BorderRadius.all(Radius.circular(13)),
        ),
        child: RichText(
          text: TextSpan(style: TextStyle(fontSize: 14), children: [
            TextSpan(
              text:
                  "回复@" + widget.data["quote_content"].split(" 发表于")[0] + ": ",
              style: TextStyle(
                color: Color(0xFF64BDFF),
              ),
            ),
            TextSpan(
              text: widget.data["quote_content"].split("发表于")[1].split("\n")[1],
              style: TextStyle(color: os_dark_white),
            ),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 25),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: os_white_opa,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                child: CachedNetworkImage(
                  placeholder: ((context, url) => Container(
                        color: os_white_opa,
                      )),
                  imageUrl: widget.data["icon"],
                  width: 35,
                  height: 35,
                  fit: BoxFit.cover,
                ),
              ),
              Container(width: 10),
              Text(
                widget.data["reply_name"],
                style: TextStyle(
                  color: os_white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Container(height: 7.5),
          ..._buildComment(),
          _buildReply(),
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
  Function tapDetail;
  Function refresh;
  Function last;
  Function next;
  Function top;
  Function down;
  int index;
  PicBottom({
    Key key,
    this.data,
    this.isLiked,
    this.tapLike,
    this.tapMore,
    this.tapDetail,
    this.refresh,
    this.index,
    this.last,
    this.next,
    this.top,
    this.down,
  }) : super(key: key);

  @override
  State<PicBottom> createState() => _PicBottomState();
}

class _PicBottomState extends State<PicBottom> {
  _toDetail() {
    if (widget.tapDetail != null) {
      widget.tapDetail();
    }
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
                  width: MediaQuery.of(context).size.width -
                      (isDesktop() ? LeftNaviWidth + 210 : 0) -
                      140,
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
                          width: MediaQuery.of(context).size.width -
                              (isDesktop() ? LeftNaviWidth + 210 : 0) -
                              180,
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
                  width: isDesktop() ? 300 : 90,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      !isDesktop()
                          ? Container()
                          : GestureDetector(
                              onTap: () {
                                if (widget.top != null) {
                                  widget.top();
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
                                        "上一镜",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Icon(
                                        Icons.arrow_upward,
                                        size: 18,
                                        color: os_white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      !isDesktop()
                          ? Container()
                          : GestureDetector(
                              onTap: () {
                                if (widget.down != null) {
                                  widget.down();
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
                                        "下一镜",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Icon(
                                        Icons.arrow_downward,
                                        size: 18,
                                        color: os_white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      !isDesktop()
                          ? Container()
                          : GestureDetector(
                              onTap: () {
                                if (widget.last != null) {
                                  widget.last();
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
                                        Icons.chevron_left_rounded,
                                        color: os_white,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      !isDesktop()
                          ? Container()
                          : GestureDetector(
                              onTap: () {
                                if (widget.next != null) {
                                  widget.next();
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
                                        Icons.chevron_right_rounded,
                                        color: os_white,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
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
                XSVibrate();
                Navigator.pushNamed(
                  context,
                  "/topic_detail",
                  arguments: widget.data["topic_id"],
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                width: MediaQuery.of(context).size.width -
                    (isDesktop() ? LeftNaviWidth : 0) -
                    30,
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
            Container(
              width: MediaQuery.of(context).size.width -
                  (isDesktop() ? LeftNaviWidth : 0) -
                  15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    color: Color.fromRGBO(255, 255, 255, 0.001),
                    child: Row(
                      children: [
                        Container(width: 15),
                        Text(
                          "第${widget.index.toString()}镜 / 摄影者 ${widget.data["name"]}",
                          style: TextStyle(
                            letterSpacing: 1,
                            color: Color(0x88FFFFFF),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      XSVibrate();
                      if (widget.refresh != null) {
                        widget.refresh();
                      }
                    },
                    child: Container(
                      color: Color.fromRGBO(255, 255, 255, 0.001),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(width: 15),
                          Text(
                            "返回顶部",
                            style: TextStyle(
                              letterSpacing: 1,
                              color: Color(0x88FFFFFF),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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

class DetailCont extends StatefulWidget {
  var data;
  var imgLists;
  String desc; //在图片上的描述
  String title; //在图片上的描述标题
  bool isComment;
  DetailCont({
    Key key,
    this.data,
    this.imgLists,
    this.isComment,
    this.desc,
    this.title,
  }) : super(key: key);

  @override
  _DetailContState createState() => _DetailContState();
}

class _DetailContState extends State<DetailCont> {
  @override
  void initState() {
    super.initState();
  }

  List<InlineSpan> _getRichText(String t) {
    List<InlineSpan> ret = [];
    t = t.replaceAll("&nbsp;", " ");
    List<String> tmp = t.split("[mobcent_phiz=");
    ret.add(TextSpan(text: tmp[0]));
    for (var i = 1; i < tmp.length; i++) {
      var first_idx = tmp[i].indexOf(']');
      ret.add(WidgetSpan(
        child: SizedBox(
          width: 30,
          height: 30,
          child: Opacity(
            opacity: Provider.of<ColorProvider>(context).isDark ? 0.8 : 1,
            child: CachedNetworkImage(
              placeholder: (context, url) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: os_grey,
                ),
              ),
              imageUrl: tmp[i].substring(0, first_idx),
            ),
          ),
        ),
      ));
      ret.add(TextSpan(text: tmp[i].substring(first_idx + 1)));
    }
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.data["type"]) {
      case 0: //纯文字
        return widget.data["infor"].toString().trim() == ""
            ? Container()
            : (widget.data["infor"].toString().characters.length == 1 &&
                    emoji
                        .toString()
                        .characters
                        .contains(widget.data["infor"].toString().trim())
                ? Container(
                    width: MediaQuery.of(context).size.width - 30,
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 60,
                          height: 1.6,
                          color: os_dark_white,
                        ),
                        text: widget.data["infor"].toString().trim(),
                      ),
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width - 30,
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: os_dark_white,
                        ),
                        children: _getRichText(
                          widget.data["infor"].indexOf("本帖最后由") > -1
                              ? widget.data["infor"].substring(
                                  (widget.data["infor"].indexOf("编辑") + 7) >=
                                          widget.data["infor"].length
                                      ? widget.data["infor"].length - 1
                                      : widget.data["infor"].indexOf("编辑") + 7)
                              : widget.data["infor"],
                        ),
                      ),
                    ),
                  ));
        break;
    }
  }
}
