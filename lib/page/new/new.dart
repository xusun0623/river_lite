import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/outer/showActionSheet/action_item.dart';
import 'package:offer_show/outer/showActionSheet/bottom_action_item.dart';
import 'package:offer_show/outer/showActionSheet/bottom_action_sheet.dart';
import 'package:offer_show/outer/showActionSheet/top_action_item.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/util/interface.dart';

class PostNew extends StatefulWidget {
  var board;
  PostNew({
    Key key,
    this.board,
  }) : super(key: key);

  @override
  _PostNewState createState() => _PostNewState();
}

class _PostNewState extends State<PostNew> {
  String select_section = "水手之家";
  int select_section_id = 25;
  TextEditingController title_controller = new TextEditingController();
  FocusNode title_focus = new FocusNode();
  TextEditingController tip_controller = new TextEditingController();
  FocusNode tip_focus = new FocusNode();
  bool pop_section = false;
  int pop_section_index = -1;
  List<Map> total = [
    // {"board_id": 45, "board_name": "情感专区"},
  ];
  List img_urls = [];
  List<Map> quick = [
    {"board_id": 45, "board_name": "情感专区"},
    {"board_id": 61, "board_name": "二手专区"},
    {"board_id": 236, "board_name": "校园热点"},
    {"board_id": 174, "board_name": "就业创业"},
    {"board_id": 199, "board_name": "保研考研"},
    {"board_id": 370, "board_name": "吃喝玩乐"},
    {"board_id": 309, "board_name": "成电锐评"},
    {"board_id": 25, "board_name": "水手之家"},
  ];

  _getTotalColumn() async {
    var data = await Api().forum_forumlist({});
    if (data != null && data["list"] != null && data["list"].length != 0) {
      List<Map> tmp = [];
      for (var board in data["list"]) {
        for (var board_tip in board["board_list"]) {
          tmp.add({
            "board_id": board_tip["board_id"],
            "board_name": board_tip["board_name"],
          });
        }
      }
      total = tmp;
      total.add({
        "board_id": 371,
        "board_name": "密语",
      });
      setState(() {});
    }
  }

  @override
  void initState() {
    _getTotalColumn();
    tip_focus.addListener(() {
      if (tip_focus.hasFocus) {
        pop_section = false;
        setState(() {});
      }
    });
    title_focus.addListener(() {
      if (title_focus.hasFocus) {
        pop_section = false;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: os_back,
        elevation: 0,
        title: Text(
          "发帖",
          style: TextStyle(fontSize: 16, color: Color(0xFF2E2E2E)),
        ),
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded, color: Color(0xFF2E2E2E)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          RightTopSend(
            tap: () async {
              var contents = [
                {
                  "type": 0, // 0：文本（解析链接）；1：图片；3：音频;4:链接;5：附件
                  "infor": tip_controller.text,
                },
              ];
              for (var i = 0; i < img_urls.length; i++) {
                contents.add({
                  "type": 1, // 0：文本（解析链接）；1：图片；3：音频;4:链接;5：附件
                  "infor": img_urls[i]["urlName"],
                });
              }
              Map json = {
                "body": {
                  "json": {
                    "isAnonymous": 0,
                    "isOnlyAuthor": 0,
                    "typeId": "",
                    "aid": "",
                    "fid": select_section_id,
                    "isQuote": 0, //"是否引用之前回复的内容
                    // "replyId": 123456, //回复 ID（pid）
                    // "aid": "1,2,3", // 附件 ID，逗号隔开
                    "title": title_controller.text,
                    "content": jsonEncode(contents),
                  }
                }
              };
              showToast(
                context: context,
                type: XSToast.loading,
                txt: "发表中…",
              );
              print("${json}");
              return;
              await Api().forum_topicadmin(
                {
                  "act": "new",
                  "json": jsonEncode(json),
                },
              );
              hideToast();
              setState(() {});
              await Future.delayed(Duration(milliseconds: 30));
              showToast(
                context: context,
                type: XSToast.success,
                duration: 200,
                txt: "发布成功!",
              );
            },
          )
        ],
      ),
      body: Container(
        color: os_back,
        child: Stack(
          children: [
            Positioned(
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: title_controller,
                      focusNode: title_focus,
                      style: TextStyle(fontSize: 17),
                      cursorColor: os_color,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: os_color,
                            style: BorderStyle.solid,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Color(0xFFE0E0E0),
                            style: BorderStyle.solid,
                          ),
                        ),
                        hintStyle: TextStyle(
                          fontSize: 17,
                          color: Color(0xFFA3A3A3),
                        ),
                        hintText: "请输入帖子的标题",
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 0),
                    child: TextField(
                      controller: tip_controller,
                      focusNode: tip_focus,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      cursorColor: os_color,
                      style: TextStyle(
                        height: 1.8,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 200, top: 10),
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          height: 1.8,
                          color: Color(0xFFA3A3A3),
                        ),
                        hintText: "说点什么吧…",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              child: pop_section
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                      color: os_white,
                      child: [
                        YourEmoji(tap: (emoji) {
                          tip_controller.text += emoji;
                        }),
                        AtSomeone(tap: (uid, name) {
                          tip_controller.text =
                              tip_controller.text + " @${name} ";
                        }),
                      ][pop_section_index],
                    )
                  : Container(),
              bottom: 0,
            ),
            Positioned(
              bottom: pop_section ? 250 : 0,
              child: Container(
                decoration: BoxDecoration(
                  color: os_white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(7),
                    topRight: Radius.circular(7),
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                height: 100,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            title_focus.unfocus();
                            tip_focus.unfocus();
                            showActionSheet(
                              context: context,
                              isScrollControlled: true,
                              actions: total.map((e) {
                                return ActionItem(
                                  title: e["board_name"],
                                  onPressed: () {
                                    select_section = e["board_name"];
                                    select_section_id = e["board_id"];
                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                                );
                              }).toList(),
                              topActionItem: TopActionItem(
                                title: "已选择:${select_section}✅",
                                titleTextStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              bottomActionItem: BottomActionItem(title: "取消"),
                            );
                          },
                          child: Container(
                            height: 27,
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),
                              ),
                              border: Border.all(
                                color: os_color,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(width: 7.5),
                                Text(
                                  select_section,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: os_color,
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  size: 18,
                                  color: os_color,
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width -
                              select_section.length * 14 -
                              70,
                          height: 30,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: quick.map((e) {
                              return SelectTag(
                                selected: e["board_name"] == select_section,
                                tap: (tap_board) {
                                  title_focus.unfocus();
                                  tip_focus.unfocus();
                                  setState(() {
                                    select_section = tap_board["board_name"];
                                    select_section_id = tap_board["board_id"];
                                  });
                                },
                                quick: e,
                              );
                            }).toList(),
                          ),
                        )
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 30,
                      height: 1,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      color: Color(0xFFEFEFEF),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          //左边按键区
                          children: [
                            myInkWell(
                              tap: () {
                                title_focus.unfocus();
                                tip_focus.unfocus();
                                if (pop_section_index == 0 && pop_section) {
                                  pop_section = false;
                                } else {
                                  pop_section = true;
                                }
                                pop_section_index = 0;
                                setState(() {});
                              },
                              widget: Container(
                                padding: EdgeInsets.all(2.5),
                                child: os_svg(
                                  path: "lib/img/topic_emoji_black.svg",
                                  width: 22,
                                  height: 22,
                                ),
                              ),
                              radius: 10,
                              width: 30,
                              height: 29,
                            ),
                            Container(width: 15),
                            myInkWell(
                              tap: () {
                                title_focus.unfocus();
                                tip_focus.unfocus();
                                if (pop_section_index == 1 && pop_section) {
                                  pop_section = false;
                                } else {
                                  pop_section = true;
                                }
                                pop_section_index = 1;
                                setState(() {});
                              },
                              widget: Container(
                                padding: EdgeInsets.all(2.5),
                                child: os_svg(
                                  path: "lib/img/topic_@_black.svg",
                                  width: 22,
                                  height: 22,
                                ),
                              ),
                              radius: 10,
                              width: 30,
                              height: 29,
                            ),
                            Container(width: 15),
                            myInkWell(
                              tap: () async {
                                title_focus.unfocus();
                                tip_focus.unfocus();
                                final ImagePicker _picker = ImagePicker();
                                //选好了图片
                                var image = await _picker.pickMultiImage(
                                      imageQuality: 50,
                                    ) ??
                                    [];
                                img_urls = await Api().uploadImage(image) ?? [];
                                print("${img_urls}");
                                setState(() {});
                              },
                              widget: Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(2.5),
                                    child: os_svg(
                                      path: "lib/img/topic_line_image.svg",
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                  img_urls.length == 0
                                      ? Container()
                                      : Positioned(
                                          right: 0,
                                          top: 0,
                                          child: Container(
                                            width: 14,
                                            height: 14,
                                            decoration: BoxDecoration(
                                              color: os_color,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            ),
                                            child: Center(
                                              child: Text(
                                                img_urls.length.toString(),
                                                style: TextStyle(
                                                  color: os_white,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                ],
                              ),
                              radius: 10,
                              width: 30,
                              height: 29,
                            ),
                          ],
                        ),
                        Row(
                          //右边功能区
                          children: [
                            Container(
                              height: 25,
                              padding: EdgeInsets.symmetric(horizontal: 7),
                              margin: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                color: os_white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                                border: Border.all(
                                  color: Color(0xFF9D9D9D),
                                ),
                              ),
                              child: Center(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      size: 12,
                                      color: Color(0xFF9D9D9D),
                                    ),
                                    Text(
                                      "插入投票",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF9D9D9D),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            select_section != "密语"
                                ? Container()
                                : Container(
                                    height: 25,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 7),
                                    margin: EdgeInsets.only(left: 5),
                                    decoration: BoxDecoration(
                                      color: os_white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(100),
                                      ),
                                      border: Border.all(
                                        color: Color(0xFF9D9D9D),
                                      ),
                                    ),
                                    child: Center(
                                      child: Row(
                                        children: [
                                          Text(
                                            "所有人可见",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF9D9D9D),
                                            ),
                                          ),
                                          Icon(
                                            Icons.keyboard_arrow_up_rounded,
                                            size: 12,
                                            color: Color(0xFF9D9D9D),
                                          ),
                                        ],
                                      ),
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
          ],
        ),
      ),
    );
  }
}

class SelectTag extends StatefulWidget {
  Map quick;
  Function tap;
  bool selected;
  SelectTag({
    Key key,
    @required this.quick,
    this.selected,
    this.tap,
  }) : super(key: key);

  @override
  State<SelectTag> createState() => _SelectTagState();
}

class _SelectTagState extends State<SelectTag> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.tap(widget.quick);
      },
      child: Container(
        height: 27,
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.only(left: 5),
        decoration: BoxDecoration(
          color: widget.selected ?? false ? os_color_opa : Color(0xFFF6F6F6),
          borderRadius: BorderRadius.all(
            Radius.circular(100),
          ),
          border: Border.all(
            color: Colors.transparent,
          ),
        ),
        child: Center(
          child: Text(
            "#" + (widget.quick["board_name"] ?? "测试Tag"),
            style: TextStyle(
              color: widget.selected ?? false ? os_color : Color(0xFF9D9D9D),
            ),
          ),
        ),
      ),
    );
  }
}

class RightTopSend extends StatefulWidget {
  Function tap;
  RightTopSend({
    Key key,
    @required this.tap,
  }) : super(key: key);

  @override
  State<RightTopSend> createState() => _RightTopSendState();
}

class _RightTopSendState extends State<RightTopSend> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.tap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        child: Container(
          width: 60,
          height: 25,
          decoration: BoxDecoration(
            color: os_color,
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          child: Center(
            child: Container(
              child: Text("发布"),
            ),
          ),
        ),
      ),
    );
  }
}
