import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offer_show/asset/bigScreen.dart';
import 'package:offer_show/asset/black.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/home_desktop_mode.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/showPop.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/asset/time.dart';
import 'package:offer_show/asset/toWebUrl.dart';
import 'package:offer_show/asset/to_user.dart';
import 'package:offer_show/asset/vibrate.dart';
import 'package:offer_show/components/leftNavi.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/outer/showActionSheet/action_item.dart';
import 'package:offer_show/outer/showActionSheet/bottom_action_item.dart';
import 'package:offer_show/outer/showActionSheet/bottom_action_sheet.dart';
import 'package:offer_show/page/photo_view/photo_view.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/mid_request.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
import 'package:provider/provider.dart';
import 'package:route_transitions/route_transitions.dart';

import '../outer/cached_network_image/cached_image_widget.dart';

class Topic extends StatefulWidget {
  Map data;
  double top;
  double bottom;
  bool blackOccu;
  bool hideColumn;
  bool isLeftNaviUI;
  Color backgroundColor;

  Topic({
    Key key,
    this.data,
    this.top,
    this.bottom,
    this.blackOccu,
    this.hideColumn,
    this.isLeftNaviUI,
    this.backgroundColor,
  }) : super(key: key);

  @override
  _TopicState createState() => _TopicState();
}

class _TopicState extends State<Topic> {
  var _isRated = false;
  bool isBlack = false;
  bool isWifi = false;
  String blackKeyWord = "";

  bool _isBlack() {
    bool flag = false;
    Provider.of<BlackProvider>(context, listen: false).black.forEach((element) {
      if (widget.data["title"].toString().contains(element) ||
          widget.data["subject"].toString().contains(element) ||
          widget.data["user_nick_name"].toString().contains(element)) {
        flag = true;
        blackKeyWord = element;
      }
    });
    return flag;
  }

  void _getLikeStatus() async {
    String tmp = await getStorage(key: "topic_like", initData: "");
    String tmp1 = await getStorage(key: "topic_dis_like", initData: "");
    List<String> ids = tmp.split(",");
    if (ids.indexOf(
            (widget.data["source_id"] ?? widget.data["topic_id"]).toString()) >
        -1) {
      setState(() {
        _isRated = true;
      });
    }
  }

  _getIsWifi() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        isWifi = false;
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        isWifi = true;
      });
    }
  }

  @override
  void initState() {
    _getLikeStatus();
    _getIsWifi();
    print(widget.data["imageList"]);
    super.initState();
  }

  _feedbackSuccess() async {
    showToast(
      context: context,
      type: XSToast.success,
      txt: "已举报",
    );
  }

  _feedback() async {
    String txt = "";
    showPop(context, [
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
          color: Provider.of<ColorProvider>(context, listen: false).isDark
              ? os_white_opa
              : os_grey,
        ),
        child: Center(
          child: TextField(
            onChanged: (e) {
              txt = e;
            },
            style: TextStyle(
              color: Provider.of<ColorProvider>(context, listen: false).isDark
                  ? os_dark_white
                  : os_black,
            ),
            cursorColor: os_deep_blue,
            decoration: InputDecoration(
                hintText: "请输入",
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color:
                      Provider.of<ColorProvider>(context, listen: false).isDark
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
              color: Provider.of<ColorProvider>(context, listen: false).isDark
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
    ]);
  }

  _moreAction() async {
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
              await setBlackWord(widget.data["user_nick_name"], context);
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
                    text: base_url +
                        "forum.php?mod=viewthread&tid=" +
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

  _setHistory() async {
    var history_data = await getStorage(key: "history", initData: "[]");
    List history_arr = jsonDecode(history_data);
    bool flag = false;
    for (int i = 0; i < history_arr.length; i++) {
      var ele = history_arr[i];
      if (ele["userAvatar"] == widget.data["userAvatar"] &&
          ele["title"] == widget.data["title"] &&
          ele["subject"] ==
              ((widget.data["summary"] ?? widget.data["subject"]) ?? "")) {
        history_arr.removeAt(i);
      }
    }
    List tmp_list_history = [
      {
        "userAvatar": widget.data["userAvatar"],
        "title": widget.data["title"],
        "subject": (widget.data["summary"] ?? widget.data["subject"]) ?? "",
        "time": widget.data["last_reply_date"],
        "topic_id": (widget.data["source_id"] ?? widget.data["topic_id"]),
      }
    ];
    tmp_list_history.addAll(history_arr);
    setStorage(key: "history", value: jsonEncode(tmp_list_history));
  }

  //卡片图案
  Widget _getTopicCardImg() {
    if (!isWifi) return Container();
    // var connectivityResult = await (Connectivity().checkConnectivity());
    double img_size = (MediaQuery.of(context).size.width - 55) / 3 - 3.3;
    // print(widget.data["imageList"]);
    if (widget.data != null &&
        widget.data["imageList"] != null &&
        widget.data["imageList"].length != 0 &&
        !isDesktop()) {
      if (widget.data["imageList"].length > 3)
        widget.data["imageList"] = widget.data["imageList"].sublist(0, 3);
      List<Widget> _getImg(List a) {
        List<Widget> t = [];
        for (int i = 0; i < widget.data["imageList"].length; i++) {
          var url = widget.data["imageList"][i];
          t.add(ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: img_size,
              maxWidth: img_size,
            ),
            child: GestureDetector(
              onTap: () {
                fadeWidget(
                  newPage: PhotoPreview(
                    isSmallPic: true,
                    galleryItems: widget.data["imageList"],
                    defaultImage: i,
                  ),
                  context: context,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2.5),
                child: Hero(
                  tag: url,
                  child: CachedNetworkImage(
                    imageUrl: url,
                    maxHeightDiskCache: 800,
                    maxWidthDiskCache: 800,
                    memCacheWidth: 800,
                    memCacheHeight: 800,
                    width: img_size,
                    height: img_size,
                    filterQuality: FilterQuality.low,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ));
          if (i != 2) {
            t.add(Container(width: 5));
          }
        }
        return t;
      }

      return Row(
        children: _getImg(widget.data["imageList"]),
      );
    } else {
      return Container();
    }
  }

  Widget _blackCont() {
    //拉黑的状态
    return Container(
      child: (widget.blackOccu ?? false)
          ? Padding(
              padding: EdgeInsets.fromLTRB(
                os_edge,
                widget.top ?? 10,
                os_edge,
                widget.bottom ?? 0,
              ),
              child: myInkWell(
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_light_dark_card
                    : os_white,
                radius: 10,
                widget: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    "此贴已被你屏蔽，屏蔽关键词为:" + blackKeyWord,
                    style: TextStyle(
                      color: os_deep_grey,
                    ),
                  ),
                ),
              ),
            )
          : Container(),
    );
  }

  Widget _topicCont() {
    //帖子卡片正文内容
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: Provider.of<ColorProvider>(context).isDark
              ? Color(0x08FFFFFF)
              : Colors.transparent,
        ),
      ),
      child: Padding(
        // padding: EdgeInsets.fromLTRB(16, 18, 16, 18),
        padding: EdgeInsets.fromLTRB(16, 18, 0, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //顶部区域：左边：头像、昵称、时间 右边：更多按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TopicTopSection(widget: widget),
                Row(
                  children: [
                    myInkWell(
                      tap: () {
                        XSVibrate();
                        _moreAction();
                      },
                      color: Colors.transparent,
                      widget: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.more_horiz_sharp,
                              size: 18,
                              color: Provider.of<ColorProvider>(context).isDark
                                  ? os_deep_grey
                                  : Color(0xFF585858),
                            ),
                          ],
                        ),
                      ),
                      radius: 100,
                    ),
                    Container(width: 16),
                  ],
                ),
              ],
            ),
            Padding(padding: EdgeInsets.all(4)),
            //中部区域：标题
            Container(
              width: MediaQuery.of(context).size.width -
                  ((widget.isLeftNaviUI ?? false) ? LeftNaviWidth : 0) -
                  ((widget.hideColumn ?? false) ? MinusSpace(context) : 0) -
                  54,
              child: Text(
                widget.data["title"],
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 17,
                    letterSpacing: 0.5,
                    color: Provider.of<ColorProvider>(context).isDark
                        ? os_dark_white
                        : os_black),
              ),
            ),
            //中部区域：正文
            (widget.data["summary"] ?? widget.data["subject"])
                        .toString()
                        .trim() ==
                    ""
                ? Container()
                : Padding(padding: EdgeInsets.all(3)),
            ((widget.data["summary"] ?? widget.data["subject"]) ?? "") == ""
                ? Container()
                : Container(
                    width: MediaQuery.of(context).size.width -
                        ((widget.isLeftNaviUI ?? false) ? LeftNaviWidth : 0) -
                        ((widget.hideColumn ?? false)
                            ? MinusSpace(context)
                            : 0) -
                        54,
                    child: Text(
                      (widget.data["summary"] ?? widget.data["subject"]) ?? "",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ),
            Container(width: 16),
            Padding(padding: EdgeInsets.all(1.5)),
            _getTopicCardImg(),
            Padding(padding: EdgeInsets.all(1.5)),
            // 投票贴的Tag
            (widget.data["vote"] ?? 0) == 0 ? Container() : VoteTag(),
            //浏览量 评论数 点赞数 - 专栏按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    os_svg(
                      path: "lib/img/topic_component_view.svg",
                      width: 20,
                      height: 20,
                    ),
                    Container(width: 5),
                    Text(
                      "${widget.data['hits']}",
                      style: TextStyle(
                        color: Color(0xFF6B6B6B),
                        fontSize: 12,
                      ),
                    ),
                    Container(width: 20),
                    os_svg(
                      path: "lib/img/topic_component_comment.svg",
                      width: 20,
                      height: 20,
                    ),
                    Container(width: 5),
                    Text(
                      "${widget.data['replies']}",
                      style: TextStyle(
                        color: Color(0xFF6B6B6B),
                        fontSize: 12,
                      ),
                    ),
                    Container(width: 20),
                    os_svg(
                      path: "lib/img/topic_component_like.svg",
                      width: 20,
                      height: 20,
                    ),
                    Container(width: 5),
                    Text(
                      (widget.data["recommendAdd"] ?? 0).toString(),
                      style: TextStyle(
                        color: Color(0xFF6B6B6B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                TopicColumn(
                  context: context,
                  widget: widget,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _tapWidget() async {
    int tid = (widget.data["source_id"] ?? widget.data["topic_id"]);
    if (Platform.isWindows &&
        (widget.data["board_name"] == "视觉艺术" ||
            widget.data["board_name"] == "镜头下的成电")) {
      showModal(
          context: context,
          title: "请确认",
          cont: "即将在浏览器中打开此帖子",
          confirmTxt: "确认",
          cancelTxt: "取消",
          confirm: () {
            xsLanuch(
              url: "https://bbs.uestc.edu.cn/forum.php?mod=viewthread&tid=$tid",
            );
          });
      return;
    }
    String info_txt = await getStorage(key: "myinfo", initData: "");
    _setHistory();
    if (info_txt == "") {
      Navigator.pushNamed(context, "/login", arguments: 0);
    } else {
      Navigator.pushNamed(
        context,
        "/topic_detail",
        arguments: (widget.data["source_id"] ?? widget.data["topic_id"]),
      );
    }
  }

  _widgetBackgroundColor() {
    return Provider.of<ColorProvider>(context).isDark
        ? os_light_dark_card
        : (widget.backgroundColor ?? os_white);
  }

  @override
  Widget build(BuildContext context) {
    return _isBlack() || isBlack
        ? _blackCont()
        : Padding(
            padding: EdgeInsets.fromLTRB(
              os_edge,
              widget.top ?? 10,
              os_edge,
              widget.bottom ?? 0,
            ),
            child: isDesktop()
                ? GestureDetector(
                    onTap: () => _tapWidget(),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: _widgetBackgroundColor(),
                      ),
                      child: _topicCont(),
                    ),
                  )
                : myInkWell(
                    color: _widgetBackgroundColor(),
                    tap: () => _tapWidget(),
                    widget: _topicCont(),
                    radius: 10,
                  ),
          );
  }
}

class VoteTag extends StatelessWidget {
  const VoteTag({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Provider.of<ColorProvider>(context).isDark
                  ? Color(0x11FFFFFF)
                  : os_color_opa,
              borderRadius: BorderRadius.all(
                Radius.circular(100),
              ),
            ),
            padding: EdgeInsets.only(
              left: 10,
              right: 12,
              top: 3.5,
              bottom: 3.8,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.download_done,
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_dark_dark_white
                      : os_color,
                  size: 18,
                ),
                Text(
                  "投票帖",
                  style: TextStyle(
                    color: Provider.of<ColorProvider>(context).isDark
                        ? os_dark_dark_white
                        : os_color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TopicTopSection extends StatelessWidget {
  const TopicTopSection({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final Topic widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () async {
            if (widget.data["user_nick_name"] != "匿名")
              toUserSpace(context, widget.data["user_id"]);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              width: 30,
              height: 30,
              fit: BoxFit.cover,
              imageUrl: widget.data["userAvatar"],
              placeholder: (context, url) => Container(
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_dark_white
                      : os_grey),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
        Padding(padding: EdgeInsets.all(4)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.data["user_nick_name"],
              style: TextStyle(
                color: Provider.of<ColorProvider>(context).isDark
                    ? Color(0xffF1f1f1)
                    : os_black,
                fontSize: 14,
                // fontWeight: FontWeight.bold,
              ),
            ),
            Container(height: 1),
            Text(
              RelativeDateFormat.format(DateTime.fromMillisecondsSinceEpoch(
                  int.parse(widget.data["last_reply_date"]))),
              style: TextStyle(
                color: Color(0xFFAAAAAA),
                fontSize: 12.5,
              ),
            ),
          ],
        )
      ],
    );
  }
}

class TopicColumn extends StatelessWidget {
  const TopicColumn({
    Key key,
    @required this.context,
    @required this.widget,
  }) : super(key: key);

  final BuildContext context;
  final Topic widget;

  @override
  Widget build(BuildContext context) {
    return myInkWell(
      color: Colors.transparent,
      tap: () {
        Navigator.pushNamed(
          context,
          "/column",
          arguments: widget.data["board_id"],
        );
      },
      radius: 10,
      widget: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Text(
          (widget.hideColumn ?? false) ? " " : widget.data["board_name"],
          style: TextStyle(
            color: os_color,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
