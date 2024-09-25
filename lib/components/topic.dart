import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offer_show/asset/bigScreen.dart';
import 'package:offer_show/asset/black.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/home_desktop_mode.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/showActionSheet.dart';
import 'package:offer_show/asset/showPop.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/asset/time.dart';
import 'package:offer_show/asset/toWebUrl.dart';
import 'package:offer_show/asset/to_user.dart';
import 'package:offer_show/asset/vibrate.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/page/photo_view/photo_view.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/mid_request.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
import 'package:provider/provider.dart';
import 'package:route_transitions/route_transitions.dart';

class Topic extends StatefulWidget {
  Map? data;
  double? top;
  double? bottom;
  bool? blackOccu;
  bool? hideColumn;
  bool? isLeftNaviUI;
  bool? removeMargin;
  bool? hidePicture;
  Color? backgroundColor;

  Topic({
    Key? key,
    this.data,
    this.top,
    this.bottom,
    this.blackOccu,
    this.hideColumn,
    this.isLeftNaviUI,
    this.removeMargin,
    this.hidePicture,
    this.backgroundColor,
  }) : super(key: key);

  @override
  _TopicState createState() => _TopicState();
}

class _TopicState extends State<Topic> {
  var _isRated = false;
  bool isBlack = false;
  String? blackKeyWord = "";

  bool _isBlack() {
    bool flag = false;
    Provider.of<BlackProvider>(context, listen: false)
        .black!
        .forEach((element) {
      if (widget.data!["title"].toString().contains(element) ||
          widget.data!["subject"].toString().contains(element) ||
          widget.data!["user_nick_name"].toString().contains(element)) {
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
    if (ids.indexOf((widget.data!["source_id"] ?? widget.data!["topic_id"])
            .toString()) >
        -1) {
      setState(() {
        _isRated = true;
      });
    }
  }

  @override
  void initState() {
    _getLikeStatus();
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
          color: Provider.of<ColorProvider>(context, listen: false).isDark
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
            keyboardAppearance:
                Provider.of<ColorProvider>(context, listen: false).isDark
                    ? Brightness.dark
                    : Brightness.light,
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
                width: (MediaQuery.of(context).size.width -
                            MinusSpace(context) -
                            60) /
                        2 -
                    5,
                height: 40,
                child: Center(
                  child: Text(
                    "取消",
                    style: TextStyle(
                      color: Provider.of<ColorProvider>(context, listen: false)
                              .isDark
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
                  "id": widget.data!["topic_id"]
                });
                Navigator.pop(context);
                _feedbackSuccess();
              },
              color: os_deep_blue,
              widget: Container(
                width: (MediaQuery.of(context).size.width -
                            MinusSpace(context) -
                            60) /
                        2 -
                    5,
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
    showAction(
      context: context,
      options: ["屏蔽此贴", "屏蔽此人", "收藏", "复制帖子链接", "举报反馈"],
      icons: [
        Icons.block,
        Icons.person_off_outlined,
        Icons.collections_bookmark_outlined,
        Icons.copy,
        Icons.feedback_outlined
      ],
      tap: (res) async {
        if (res == "屏蔽此贴") {
          await setBlackWord(widget.data!["title"], context);
          Navigator.pop(context);
          showToast(context: context, type: XSToast.success, txt: "屏蔽成功");
          setState(() {
            isBlack = true;
          });
        }
        if (res == "屏蔽此人") {
          await setBlackWord(widget.data!["user_nick_name"], context);
          Navigator.pop(context);
          showToast(context: context, type: XSToast.success, txt: "屏蔽成功");
          setState(() {
            isBlack = true;
          });
        }
        if (res == "收藏") {
          Navigator.pop(context);
          showToast(context: context, type: XSToast.loading);
          await Api().user_userfavorite({
            "idType": "tid",
            "action": "favorite",
            "id": widget.data!["topic_id"],
          });
          hideToast();
          showToast(context: context, type: XSToast.success, txt: "收藏成功");
        }
        if (res == "复制帖子链接") {
          Clipboard.setData(
            ClipboardData(
                text: base_url +
                    "forum.php?mod=viewthread&tid=" +
                    widget.data!["topic_id"].toString()),
          );
          Navigator.pop(context);
          showToast(context: context, type: XSToast.success, txt: "复制成功");
        }
        if (res == "举报反馈") {
          Navigator.pop(context);
          _feedback();
        }
      },
    );
  }

  _setHistory() async {
    var history_data = await getStorage(key: "history", initData: "[]");
    List history_arr = jsonDecode(history_data);
    bool flag = false;
    for (int i = 0; i < history_arr.length; i++) {
      var ele = history_arr[i];
      if (ele["userAvatar"] == widget.data!["userAvatar"] &&
          ele["title"] == widget.data!["title"] &&
          ele["subject"] ==
              ((widget.data!["summary"] ?? widget.data!["subject"]) ?? "")) {
        history_arr.removeAt(i);
      }
    }
    List tmp_list_history = [
      {
        "userAvatar": widget.data!["userAvatar"],
        "title": widget.data!["title"],
        "subject": (widget.data!["summary"] ?? widget.data!["subject"]) ?? "",
        "time": widget.data!["last_reply_date"],
        "topic_id": (widget.data!["source_id"] ?? widget.data!["topic_id"]),
      }
    ];
    tmp_list_history.addAll(history_arr);
    setStorage(key: "history", value: jsonEncode(tmp_list_history));
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
                    "此贴已被你屏蔽，屏蔽关键词为:" + blackKeyWord!,
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

  //卡片图案
  Widget _getTopicCardImg() {
    double img_size = (MediaQuery.of(context).size.width - 55) / 3 - 3.3;
    img_size = img_size > 150 ? 150 : img_size;
    // print(widget.data["imageList"]);
    if (widget.data != null &&
        widget.data!["imageList"] != null &&
        widget.data!["imageList"].length != 0) {
      int splitCount = isDesktop() ? 2 : 3;
      if (widget.data!["imageList"].length > splitCount)
        widget.data!["imageList"] =
            widget.data!["imageList"].sublist(0, splitCount);
      List<Widget> _getImg(List? a) {
        List<Widget> t = [];
        for (int i = 0; i < widget.data!["imageList"].length; i++) {
          var url = widget.data!["imageList"][i];
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
                    galleryItems: widget.data!["imageList"],
                    defaultImage: i,
                  ),
                  context: context,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2.5),
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
                  errorWidget: (context, url, error) => Container(
                    child: Icon(
                      Icons.image,
                      size: 40,
                      color: Provider.of<ColorProvider>(context).isDark
                          ? Color(0x22ffffff)
                          : os_middle_grey,
                    ),
                    color: Provider.of<ColorProvider>(context).isDark
                        ? os_white_opa
                        : os_grey,
                  ),
                  placeholder: (context, url) => Container(
                    child: Icon(
                      Icons.image,
                      size: 40,
                      color: Provider.of<ColorProvider>(context).isDark
                          ? Color(0x22ffffff)
                          : os_middle_grey,
                    ),
                    color: Provider.of<ColorProvider>(context).isDark
                        ? os_white_opa
                        : os_grey,
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

      return Container(
        height: img_size,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: _getImg(widget.data!["imageList"]),
        ),
      );
    } else {
      return Container();
    }
  }

  String removeTitleSubColumn(String txt) {
    if (!(txt.contains("[") && txt.contains("]"))) {
      return txt;
    }

    String strStack = ""; // 使用栈对专栏英文括号进行去重
    if (txt.startsWith("[")) {
      strStack += "[";
    }
    int index = 1;
    while (strStack.isNotEmpty) {
      if (txt[index] == "]") {
        strStack = strStack.substring(0, strStack.length - 1);
      }
      if (txt[index] == "[") {
        strStack += "[";
      }
      index++;
    }
    return txt.substring(index);
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
        padding: EdgeInsets.fromLTRB(16, 16, 0, 9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //顶部区域：左边：头像、昵称、时间 右边：更多按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (widget.data!["user_nick_name"] != "匿名")
                          toUserSpace(context, widget.data!["user_id"]);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                          imageUrl: widget.data!["userAvatar"],
                          placeholder: (context, url) => Container(
                              color: Provider.of<ColorProvider>(context).isDark
                                  ? os_dark_white
                                  : os_grey),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(4)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.data!["user_nick_name"],
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
                          RelativeDateFormat.format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(widget.data!["last_reply_date"]))),
                          style: TextStyle(
                            color: Color(0xFFAAAAAA),
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    myInkWell(
                      tap: () {
                        XSVibrate().impact();
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
              // width: MediaQuery.of(context).size.width -
              //     ((widget.isLeftNaviUI ?? false) ? LeftNaviWidth : 0) -
              //     ((widget.hideColumn ?? false) ? MinusSpace(context) : 0) -
              //     54,
              margin: EdgeInsets.only(right: 10),
              child: Text(
                removeTitleSubColumn(widget.data!["title"].toString()),
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
            (widget.data!["summary"] ?? widget.data!["subject"])
                        .toString()
                        .trim() ==
                    ""
                ? Container()
                : Padding(padding: EdgeInsets.all(3)),
            ((widget.data!["summary"] ?? widget.data!["subject"]) ?? "") == ""
                ? Container()
                : Container(
                    // width: MediaQuery.of(context).size.width -
                    //     ((widget.isLeftNaviUI ?? false) ? LeftNaviWidth : 0) -
                    //     ((widget.hideColumn ?? false)
                    //         ? MinusSpace(context)
                    //         : 0) -
                    //     54,
                    margin: EdgeInsets.only(right: 10),
                    child: Text(
                      (widget.data!["summary"] ?? widget.data!["subject"]) ??
                          "",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ),
            Container(width: 16),
            widget.hidePicture ?? false
                ? Container()
                : Padding(padding: EdgeInsets.all(1.5)),
            widget.hidePicture ?? false
                ? Container()
                : Container(
                    height: widget.data != null &&
                            widget.data!["imageList"] != null &&
                            widget.data!["imageList"].length != 0
                        ? ((MediaQuery.of(context).size.width - 55) / 3 - 3.3 >
                                150
                            ? 150
                            : (MediaQuery.of(context).size.width - 55) / 3 -
                                3.3)
                        : 0,
                    child: _getTopicCardImg(),
                  ),
            widget.hidePicture ?? false
                ? Container()
                : Padding(padding: EdgeInsets.all(1.5)),
            // 投票贴的Tag
            (widget.data!["vote"] ?? 0) == 0
                ? Container()
                : Container(
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
                                color:
                                    Provider.of<ColorProvider>(context).isDark
                                        ? os_dark_dark_white
                                        : os_color,
                                size: 18,
                              ),
                              Text(
                                "投票帖",
                                style: TextStyle(
                                  color:
                                      Provider.of<ColorProvider>(context).isDark
                                          ? os_dark_dark_white
                                          : os_color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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
                      "${widget.data!['hits']}",
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
                      "${widget.data!['replies']}",
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
                      (widget.data!["recommendAdd"] ?? 0).toString(),
                      style: TextStyle(
                        color: Color(0xFF6B6B6B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                myInkWell(
                  color: Colors.transparent,
                  tap: () {
                    if (!(widget.hideColumn ?? false)) {
                      Navigator.pushNamed(
                        context,
                        "/column",
                        arguments: widget.data!["board_id"],
                      );
                    }
                  },
                  radius: 10,
                  widget: Container(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 12,
                      top: 8,
                      bottom: 8,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      children: [
                        // Icon(
                        //   Icons.extension_outlined,
                        //   size: 16,
                        //   color: os_color,
                        // ),
                        // Container(width: 2),
                        Text(
                          (widget.hideColumn ?? false)
                              ? " "
                              : widget.data!["board_name"],
                          style: TextStyle(
                            color: os_color,
                            fontSize: 14,
                          ),
                        ),
                        // Container(width: 2),
                        if (!(widget.hideColumn ?? false))
                          Icon(
                            Icons.chevron_right,
                            size: 16,
                            color: os_color,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _tapWidget() async {
    int tid = (widget.data!["source_id"] ?? widget.data!["topic_id"]);
    // if (Platform.isWindows &&
    //     (widget.data["board_name"] == "视觉艺术" ||
    //         widget.data["board_name"] == "镜头下的成电")) {
    //   showModal(
    //       context: context,
    //       title: "请确认",
    //       cont: "即将在浏览器中打开此帖子",
    //       confirmTxt: "确认",
    //       cancelTxt: "取消",
    //       confirm: () {
    //         xsLanuch(
    //           url: "https://bbs.uestc.edu.cn/forum.php?mod=viewthread&tid=$tid",
    //         );
    //       });
    //   return;
    // }
    String info_txt = await getStorage(key: "myinfo", initData: "");
    _setHistory();
    if (info_txt == "") {
      Navigator.pushNamed(context, "/login", arguments: 0);
    } else {
      Navigator.pushNamed(
        context,
        "/topic_detail",
        arguments: (widget.data!["source_id"] ?? widget.data!["topic_id"]),
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
              widget.removeMargin ?? false ? 0 : os_edge,
              widget.top ?? 10,
              widget.removeMargin ?? false ? 0 : os_edge,
              widget.bottom ?? 0,
            ),
            child: myInkWell(
              color: _widgetBackgroundColor(),
              tap: () => _tapWidget(),
              widget: _topicCont(),
              radius: 15,
            ),
          );
  }
}
