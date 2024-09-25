import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offer_show/asset/black.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/home_desktop_mode.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/showActionSheet.dart';
import 'package:offer_show/asset/showPop.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/asset/time.dart';
import 'package:offer_show/asset/vibrate.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/mid_request.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
import 'package:provider/provider.dart';

class TopicReply extends StatefulWidget {
  Map? data;
  double? top;
  double? bottom;
  bool? blackOccu;
  Color? backgroundColor;

  TopicReply({
    Key? key,
    this.data,
    this.top,
    this.bottom,
    this.blackOccu,
    this.backgroundColor,
  }) : super(key: key);

  @override
  _TopicReplyState createState() => _TopicReplyState();
}

class _TopicReplyState extends State<TopicReply> {
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
    String tmp = await getStorage(
      key: "topic_like",
    );
    List<String> ids = tmp.split(",");
    if (ids.indexOf((widget.data!["source_id"] ?? widget.data!["topic_id"])
            .toString()) >
        -1) {
      setState(() {
        _isRated = true;
      });
    }
  }

  void _tapLike() async {
    if (_isRated == true) return;
    _isRated = true;
    await Api().forum_support({
      "tid": (widget.data!["source_id"] ?? widget.data!["topic_id"]),
      "type": "thread",
      "action": "support",
    });
    String tmp = await getStorage(
      key: "topic_like",
    );
    tmp += ",${widget.data!['source_id'] ?? widget.data!['topic_id']}";
    setStorage(key: "topic_like", value: tmp);
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
      options: [
        "屏蔽此贴",
        "屏蔽此人",
        "收藏",
        "复制帖子链接",
        "举报反馈",
      ],
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

  @override
  Widget build(BuildContext context) {
    return _isBlack() || isBlack
        ? Container(
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
          )
        : Padding(
            padding: EdgeInsets.fromLTRB(
              os_edge,
              widget.top ?? 10,
              os_edge,
              widget.bottom ?? 0,
            ),
            child: myInkWell(
              color: Provider.of<ColorProvider>(context).isDark
                  ? os_light_dark_card
                  : (widget.backgroundColor ?? os_white),
              longPress: () {
                XSVibrate().impact();
                _moreAction();
              },
              tap: () async {
                String info_txt = await getStorage(key: "myinfo", initData: "");
                print("${info_txt}");
                _setHistory();
                if (info_txt == "") {
                  Navigator.pushNamed(context, "/login", arguments: 0);
                } else {
                  Navigator.pushNamed(
                    context,
                    "/topic_detail",
                    arguments:
                        (widget.data!["source_id"] ?? widget.data!["topic_id"]),
                    // arguments: 1903247,
                  );
                }
              },
              widget: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    color: Provider.of<ColorProvider>(context).isDark
                        ? Color(0x08FFFFFF)
                        : Colors.transparent,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 18, 16, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Row(
                      //       children: [
                      //         GestureDetector(
                      //           onTap: () async {
                      //             if (widget.data["user_nick_name"] != "匿名")
                      //               toUserSpace(
                      //                   context, widget.data["user_id"]);
                      //           },
                      //           child: ClipRRect(
                      //             borderRadius: BorderRadius.circular(20),
                      //             child: CachedNetworkImage(
                      //               width: 27,
                      //               height: 27,
                      //               fit: BoxFit.cover,
                      //               imageUrl: widget.data["userAvatar"],
                      //               placeholder: (context, url) => Container(
                      //                   color:
                      //                       Provider.of<ColorProvider>(context)
                      //                               .isDark
                      //                           ? os_dark_white
                      //                           : os_grey),
                      //               errorWidget: (context, url, error) =>
                      //                   Icon(Icons.error),
                      //             ),
                      //           ),
                      //         ),
                      //         Padding(padding: EdgeInsets.all(5)),
                      //         Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             Text(
                      //               widget.data["user_nick_name"],
                      //               style: TextStyle(
                      //                 color: Provider.of<ColorProvider>(context)
                      //                         .isDark
                      //                     ? Color(0xffF1f1f1)
                      //                     : os_black,
                      //                 fontSize: 14,
                      //                 // fontWeight: FontWeight.bold,
                      //               ),
                      //             ),
                      //           ],
                      //         )
                      //       ],
                      //     ),
                      //     Row(
                      //       children: [
                      //         myInkWell(
                      //           tap: () {
                      //             Vibrate.feedback(FeedbackType.impact);
                      //             _moreAction();
                      //           },
                      //           color: Colors.transparent,
                      //           widget: Padding(
                      //             padding: const EdgeInsets.symmetric(
                      //               vertical: 10,
                      //               horizontal: 5,
                      //             ),
                      //             child: Row(
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               children: [
                      //                 Icon(
                      //                   Icons.more_horiz_sharp,
                      //                   size: 18,
                      //                   color:
                      //                       Provider.of<ColorProvider>(context)
                      //                               .isDark
                      //                           ? os_deep_grey
                      //                           : Color(0xFF585858),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //           radius: 100,
                      //         ),
                      //       ],
                      //     )
                      //   ],
                      // ),
                      // Padding(padding: EdgeInsets.all(3)),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              width: 27,
                              height: 27,
                              fit: BoxFit.cover,
                              imageUrl: widget.data!["userAvatar"],
                              placeholder: (context, url) => Container(
                                  color:
                                      Provider.of<ColorProvider>(context).isDark
                                          ? os_dark_white
                                          : os_grey),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                          Container(width: 7.5),
                          Container(
                            width: MediaQuery.of(context).size.width - 100,
                            child: Text(
                              widget.data!["title"],
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 17,
                                  letterSpacing: 0.5,
                                  color:
                                      Provider.of<ColorProvider>(context).isDark
                                          ? os_dark_white
                                          : os_black),
                            ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.all(3)),
                      ((widget.data!["summary"] ?? widget.data!["subject"]) ??
                                  "") ==
                              ""
                          ? Container()
                          : Container(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                (widget.data!["summary"] ??
                                        widget.data!["subject"]) ??
                                    "",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                  color: Color(0xFF999999),
                                ),
                              ),
                            ),
                      Padding(padding: EdgeInsets.all(5)),
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
                              // Container(width: 20),
                              // os_svg(
                              //   path: "lib/img/topic_component_like.svg",
                              //   width: 20,
                              //   height: 20,
                              // ),
                              // Container(width: 5),
                              // Text(
                              //   (widget.data["recommendAdd"] ?? 0).toString(),
                              //   style: TextStyle(
                              //     color: Color(0xFF6B6B6B),
                              //     fontSize: 12,
                              //   ),
                              // ),
                            ],
                          ),
                          Text(
                            RelativeDateFormat.format(
                                DateTime.fromMillisecondsSinceEpoch(int.parse(
                                    widget.data!["last_reply_date"]))),
                            style: TextStyle(
                              color: Color(0xFF9C9C9C),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // width: width,
              // height: height,
              radius: 10,
            ),
          );
  }
}
