import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:offer_show/asset/bigScreen.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/home_desktop_mode.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/components/newNaviBar.dart';
import 'package:offer_show/outer/showActionSheet/action_item.dart';
import 'package:offer_show/outer/showActionSheet/bottom_action_item.dart';
import 'package:offer_show/outer/showActionSheet/bottom_action_sheet.dart';
import 'package:offer_show/outer/showActionSheet/top_action_item.dart';
import 'package:offer_show/page/new/draft.dart';
import 'package:offer_show/page/new/format.dart';
import 'package:offer_show/page/new/left_row_btn.dart';
import 'package:offer_show/page/new/right_row_btn.dart';
import 'package:offer_show/page/new/select_tag.dart';
import 'package:offer_show/page/new/success_display.dart';
import 'package:offer_show/page/new/vote_machine.dart';
import 'package:offer_show/page/topic/At_someone.dart';
import 'package:offer_show/page/topic/Your_emoji.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class PostNew extends StatefulWidget {
  int board_id;

  PostNew({
    Key key,
    this.board_id,
  }) : super(key: key);

  @override
  _PostNewState createState() => _PostNewState();
}

class _PostNewState extends State<PostNew> {
  bool sendSuccess = false; //是否发布成功

  String select_section = "水手之家"; //选择的专栏的名称
  int select_section_id = 25; //选择的专栏的ID
  int select_section_child_id = 0; //选择的专栏的子专栏ID
  TextEditingController title_controller =
      new TextEditingController(); //输入的标题控制器
  FocusNode title_focus = new FocusNode(); //标题输入框的focus控制器
  TextEditingController tip_controller = new TextEditingController(); //输入的正文控制器
  FocusNode tip_focus = new FocusNode(); //正文输入框的focus控制器
  bool pop_section = false;
  bool show_vote = false;
  bool uploading = false;
  int pop_section_index = -1;
  int tip_controller_offset = 0;
  List<String> vote_options = [];
  ScrollController listview_controller = new ScrollController();
  int secret_see = 0;
  bool child_load_done = false;
  List<Map> total = []; //全部帖子专栏
  List<Map> child = []; //子帖子专栏
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

  _getChildColumnTip() async {
    setState(() {
      select_section_child_id = 0;
    });
    var data = await Api().certain_forum_topiclist({
      "page": 1,
      "pageSize": 0,
      "boardId": select_section_id,
      "filterType": "typeid",
      "filterId": "",
      "sortby": "new",
    });
    if (data != null &&
        data["classificationType_list"] != null &&
        data["classificationType_list"].length != 0) {
      List<Map> tmp = [];
      for (var board in data["classificationType_list"]) {
        tmp.add({
          "board_id": board["classificationType_id"],
          "board_name": board["classificationType_name"],
        });
      }
      child = tmp;
    } else {
      child = [];
    }
    child_load_done = true;
    setState(() {});
  }

  _getTotalColumn() async {
    if (widget.board_id == 371) {
      setState(() {
        select_section = "密语";
      });
    }
    var data = await Api().forum_forumlist({});
    if (data != null && data["list"] != null && data["list"].length != 0) {
      List<Map> tmp = [];
      for (var board in data["list"]) {
        for (var board_tip in board["board_list"]) {
          if (board_tip["board_id"] == select_section_id) {
            if (board_tip["board_name"] == "鹊桥" &&
                tip_controller.text.length == 0) {
              tip_controller.text = bridgeFormatTxt;
            }
            setState(() {
              select_section = board_tip["board_name"];
            });
          }
          tmp.add({
            "board_id": board_tip["board_id"],
            "board_name": board_tip["board_name"],
          });
        }
      }
      total = tmp;
      setState(() {});
    }
  }

  _send() async {
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
    Map poll = {
      "expiration": 3,
      "options": vote_options,
      "maxChoices": 1,
      "visibleAfterVote": false,
      "showVoters": false,
    };
    Map json = {
      "body": {
        "json": {
          "isAnonymous": select_section_id == 371 ? 1 : 0,
          "isOnlyAuthor": 0,
          "typeId": select_section_child_id == 0 ? "" : select_section_child_id,
          "aid": img_urls.map((attachment) => attachment["id"]).join(","),
          "fid": select_section_id,
          "isQuote": 0, //"是否引用之前回复的内容
          "title": title_controller.text,
          "content": jsonEncode(contents),
          "poll": show_vote ? poll : "",
        }
      }
    };
    showToast(
      context: context,
      type: XSToast.loading,
      txt: "发表中…",
    );
    var ret_tip = await Api().forum_topicadmin(
      {
        "act": "new",
        "json": jsonEncode(json),
      },
    );
    hideToast();
    if (ret_tip["rs"] == 1) {
      setState(() {
        sendSuccess = true;
      });
    } else {
      showToast(context: context, type: XSToast.none, txt: ret_tip["errcode"]);
    }
  }

  @override
  void initState() {
    select_section_id = widget.board_id;
    _getTotalColumn();
    _getChildColumnTip();
    tip_controller.addListener(() {
      setState(() {
        tip_controller_offset = tip_controller.selection.base.offset;
      });
    });
    tip_focus.addListener(() {
      if (tip_focus.hasFocus) {
        pop_section = false;
        title_focus.unfocus();
      }
      setState(() {});
    });
    title_focus.addListener(() {
      if (title_focus.hasFocus) {
        pop_section = false;
        tip_focus.unfocus();
        setState(() {});
      }
    });
    super.initState();
  }

  List<Widget> _buildChildList() {
    List<Widget> tmp = [];
    tmp.add(GestureDetector(
      onTap: () {
        setState(() {
          select_section_child_id = 0;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 20, top: 5, bottom: 5),
        child: Text(
          child.length == 0 && child_load_done ? "你不可以在此板块发布信息" : "选择子板块:",
          style: TextStyle(
            color: Provider.of<ColorProvider>(context).isDark
                ? os_dark_dark_white
                : os_dark_back,
            // fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ));
    if (child.length == 0 && !child_load_done) {
      tmp.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(
          "加载中…",
          style: TextStyle(
            color: os_deep_grey,
          ),
        ),
      ));
    }
    child.forEach((element) {
      tmp.add(ChildColumnTip(
        select: element["board_id"] == select_section_child_id,
        child_id: element["board_id"],
        name: element["board_name"],
        tap: (child_id) {
          setState(() {
            select_section_child_id = child_id;
          });
        },
      ));
    });
    return tmp;
  }

  @override
  Widget build(BuildContext context) {
    return Baaaar(
      color:
          Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Provider.of<ColorProvider>(context).isDark
              ? os_dark_back
              : os_back,
          elevation: 0,
          title: Text(
            sendSuccess ? "" : "发帖",
            style: TextStyle(
                fontSize: 16,
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_dark_white
                    : Color(0xFF2E2E2E)),
          ),
          leading: IconButton(
            icon: Icon(Icons.chevron_left_rounded,
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_dark_white
                    : Color(0xFF2E2E2E)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: sendSuccess
              ? []
              : [
                  SaveDraftBtn(
                    tip_controller: tip_controller,
                    tip_focus: tip_focus,
                  ),
                  uploading
                      ? Container(width: 10)
                      : RightTopSend(
                          tap: () async {
                            _send();
                          },
                        )
                ],
        ),
        body: Container(
          color: Provider.of<ColorProvider>(context).isDark
              ? os_dark_back
              : os_back,
          child: sendSuccess
              ? SuccessDisplay()
              : Stack(
                  children: [
                    Positioned(
                      child: ListView(
                        //physics: BouncingScrollPhysics(),
                        controller: listview_controller,
                        children: [
                          ColumnRule(select_section: select_section),
                          TitleInput(
                            title_controller: title_controller,
                            title_focus: title_focus,
                          ),
                          select_section_id == 371 ? SecretTip() : Container(),
                          ContInput(
                            tip_controller: tip_controller,
                            tip_focus: tip_focus,
                          ),
                          show_vote
                              ? VoteMachine(
                                  editVote: (options) {
                                    List<String> tmp = [];
                                    for (var item in options) {
                                      tmp.add(item["txt"]);
                                    }
                                    vote_options = tmp;
                                  },
                                  focus: () async {
                                    if (isDesktop()) return;
                                    await Future.delayed(
                                        Duration(milliseconds: 800));
                                    listview_controller.animateTo(
                                      listview_controller
                                          .position.maxScrollExtent,
                                      duration: Duration(milliseconds: 200),
                                      curve: Curves.ease,
                                    );
                                  },
                                  tap: () {
                                    if (isDesktop()) return;
                                    listview_controller.animateTo(
                                        listview_controller
                                                .position.maxScrollExtent +
                                            50,
                                        duration: Duration(milliseconds: 200),
                                        curve: Curves.ease);
                                  },
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    Positioned(
                      child: pop_section
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              height: 250,
                              color: Provider.of<ColorProvider>(context).isDark
                                  ? os_light_dark_card
                                  : os_white,
                              child: [
                                ResponsiveWidget(
                                  child: YourEmoji(
                                    backgroundColor:
                                        Provider.of<ColorProvider>(context)
                                                .isDark
                                            ? os_dark_back
                                            : os_grey,
                                    tap: (emoji) {
                                      int tmp_offset = tip_controller_offset;
                                      tip_controller.text = tip_controller.text
                                              .substring(
                                                  0, tip_controller_offset) +
                                          emoji +
                                          tip_controller.text.substring(
                                              tip_controller_offset,
                                              tip_controller.text.length);
                                      tip_controller_offset =
                                          tmp_offset + emoji.toString().length;
                                    },
                                  ),
                                ),
                                ResponsiveWidget(
                                  child: AtSomeone(
                                      hide: () {
                                        setState(() {
                                          pop_section = false;
                                        });
                                      },
                                      backgroundColor:
                                          Provider.of<ColorProvider>(context)
                                                  .isDark
                                              ? os_dark_back
                                              : os_grey,
                                      tap: (uid, name) {
                                        tip_controller.text =
                                            tip_controller.text + " @${name} ";
                                      }),
                                ),
                              ][pop_section_index],
                            )
                          : Container(),
                      bottom: 0,
                    ),
                    Positioned(
                      bottom: pop_section ? 250 : 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Provider.of<ColorProvider>(context).isDark
                              ? os_light_dark_card
                              : os_white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(7),
                            topRight: Radius.circular(7),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width,
                        // height: tip_focus.hasFocus ? 110 : 150,
                        padding: EdgeInsets.only(
                          left: 15,
                          right: 15,
                          top: 10,
                          bottom: 20,
                        ),
                        child: Column(
                          children: [
                            (tip_focus.hasFocus && !isDesktop()) ||
                                    select_section_id == 371
                                ? Container()
                                : ResponsiveWidget(
                                    child: isDesktop()
                                        ? ConstrainedBox(
                                            constraints: BoxConstraints(
                                              minHeight: 40,
                                            ),
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 10),
                                              child: Wrap(
                                                children: [
                                                  ..._buildChildList(),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height: 40,
                                            child: Center(
                                              child: ListView(
                                                physics:
                                                    BouncingScrollPhysics(),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                children: _buildChildList(),
                                              ),
                                            ),
                                          ),
                                  ),
                            ResponsiveWidget(
                              child: Row(
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
                                              if (e["board_name"] == "鹊桥" &&
                                                  tip_controller.text == "") {
                                                setState(() {
                                                  tip_controller.text =
                                                      bridgeFormatTxt;
                                                });
                                              }
                                              select_section = e["board_name"];
                                              select_section_id = e["board_id"];
                                              _getChildColumnTip();
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
                                        bottomActionItem:
                                            BottomActionItem(title: "取消"),
                                      );
                                    },
                                    child: SelectColumn(
                                        select_section: select_section),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width -
                                        select_section.length * 14 -
                                        MinusSpace(context) -
                                        70,
                                    height: 30,
                                    child: ListView(
                                      //physics: BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      children: quick.map((e) {
                                        return SelectTag(
                                          selected:
                                              e["board_name"] == select_section,
                                          tap: (tap_board) {
                                            title_focus.unfocus();
                                            tip_focus.unfocus();
                                            setState(() {
                                              select_section =
                                                  tap_board["board_name"];
                                              select_section_id =
                                                  tap_board["board_id"];
                                              _getChildColumnTip();
                                            });
                                          },
                                          quick: e,
                                        );
                                      }).toList(),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            ColumnSpace(),
                            ResponsiveWidget(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  LeftRowBtn(
                                    title_focus: title_focus,
                                    tip_focus: tip_focus,
                                    pop_section_index: pop_section_index,
                                    pop_section: pop_section,
                                    uploading: uploading,
                                    setPopSection: (setPopSection) {
                                      setState(() {
                                        pop_section = setPopSection;
                                      });
                                    },
                                    setPopSectionIndex: (setPopSectionIndex) {
                                      setState(() {
                                        pop_section_index = setPopSectionIndex;
                                      });
                                    },
                                    setUploading: (setUploading) {
                                      setState(() {
                                        uploading = setUploading;
                                      });
                                    },
                                    setImgUrls: (setImgUrls) {
                                      setState(() {
                                        img_urls = setImgUrls;
                                      });
                                    },
                                    img_urls: img_urls,
                                  ),
                                  RightRowBtn(
                                    show_vote: show_vote,
                                    changeVoteStatus: (changeVoteStatus) {
                                      setState(() {
                                        show_vote = changeVoteStatus;
                                      });
                                    },
                                    changePopStatus: (changePopStatus) {
                                      setState(() {
                                        pop_section = changePopStatus;
                                      });
                                    },
                                    select_section: select_section,
                                    changeSecretSee: (changeSecretSee) {
                                      setState(() {
                                        secret_see = changeSecretSee;
                                      });
                                    },
                                    secret_see: secret_see,
                                    tip_focus: tip_focus,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class SecretTip extends StatelessWidget {
  const SecretTip({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15, left: 20, right: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, "/column", arguments: 371);
        },
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              color: os_deep_grey,
              fontSize: 14,
            ),
            children: [
              TextSpan(text: "密语区需要扣除您的10水滴，且需要您有密语区的访问权限，请确保你此前"),
              TextSpan(
                text: "访问过密语区>",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: os_deep_grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ColumnRule extends StatefulWidget {
  String select_section;
  ColumnRule({
    Key key,
    this.select_section,
  }) : super(key: key);

  @override
  State<ColumnRule> createState() => _ColumnRuleState();
}

class _ColumnRuleState extends State<ColumnRule> {
  @override
  Widget build(BuildContext context) {
    return true
        ? Container()
        : GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/rule",
                  arguments: widget.select_section);
            },
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 7.5),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: Provider.of<ColorProvider>(context).isDark
                        ? os_dark_dark_white
                        : os_deep_grey,
                  ),
                  Container(width: 2),
                  Text(
                    "查看${widget.select_section}版规",
                    style: TextStyle(
                      color: Provider.of<ColorProvider>(context).isDark
                          ? os_dark_dark_white
                          : os_deep_grey,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

class ChildColumnTip extends StatefulWidget {
  bool select;
  String name;
  int child_id;
  Function tap;
  ChildColumnTip({
    Key key,
    this.select,
    this.name,
    this.child_id,
    this.tap,
  }) : super(key: key);

  @override
  State<ChildColumnTip> createState() => _ChildColumnTipState();
}

class _ChildColumnTipState extends State<ChildColumnTip> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.tap(widget.child_id);
      },
      child: Container(
        padding: EdgeInsets.only(left: 0, right: 20, top: 5, bottom: 5),
        color: Provider.of<ColorProvider>(context).isDark
            ? os_light_dark_card
            : os_white,
        child: Text(
          widget.name,
          style: TextStyle(
            color: widget.select ? os_color : os_deep_grey,
          ),
        ),
      ),
    );
  }
}

class ContInput extends StatefulWidget {
  final TextEditingController tip_controller;
  final FocusNode tip_focus;
  ContInput({
    Key key,
    @required this.tip_controller,
    @required this.tip_focus,
  }) : super(key: key);

  @override
  State<ContInput> createState() => _ContInputState();
}

class _ContInputState extends State<ContInput> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 0),
        child: TextField(
          controller: widget.tip_controller,
          focusNode: widget.tip_focus,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          cursorColor: os_color,
          style: TextStyle(
            height: 1.8,
            color: Provider.of<ColorProvider>(context).isDark
                ? os_dark_dark_white
                : os_black,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 200, top: 10),
            border: InputBorder.none,
            hintStyle: TextStyle(
              height: 1.8,
              color: Provider.of<ColorProvider>(context).isDark
                  ? os_deep_grey
                  : Color(0xFFA3A3A3),
            ),
            hintText: "说点什么吧…",
          ),
        ),
      ),
    );
  }
}

class TitleInput extends StatelessWidget {
  const TitleInput({
    Key key,
    @required this.title_controller,
    @required this.title_focus,
  }) : super(key: key);

  final TextEditingController title_controller;
  final FocusNode title_focus;

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Provider.of<ColorProvider>(context).isDark
              ? os_light_dark_card
              : os_white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: TextField(
          controller: title_controller,
          focusNode: title_focus,
          style: TextStyle(
            fontSize: 17,
            color: Provider.of<ColorProvider>(context).isDark
                ? os_dark_white
                : os_black,
          ),
          // cursorColor: Provider.of<ColorProvider>(context).isDark
          //     ? os_dark_back
          //     : os_white,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(
                width: 2,
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_dark_white
                    : os_color,
                style: BorderStyle.solid,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(
                width: 2,
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_light_dark_card
                    : os_white,
                style: BorderStyle.solid,
              ),
            ),
            hintStyle: TextStyle(
              fontSize: 17,
              color: Color(0xFFA3A3A3),
            ),
            hintText:
                isMacOS() ? "请输入帖子的标题，按住control键+空格键以切换中英文输入法" : "请输入帖子的标题",
          ),
        ),
      ),
    );
  }
}
