import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offer_show/asset/bigScreen.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/outer/showActionSheet/action_item.dart';
import 'package:offer_show/outer/showActionSheet/bottom_action_item.dart';
import 'package:offer_show/outer/showActionSheet/bottom_action_sheet.dart';
import 'package:offer_show/outer/showActionSheet/top_action_item.dart';
import 'package:offer_show/page/photo_view/photo_view.dart';
import 'package:offer_show/page/topic/At_someone.dart';
import 'package:offer_show/page/topic/Your_emoji.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
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
    var data = await Api().forum_forumlist({});
    if (data != null && data["list"] != null && data["list"].length != 0) {
      List<Map> tmp = [];
      for (var board in data["list"]) {
        for (var board_tip in board["board_list"]) {
          if (board_tip["board_id"] == select_section_id) {
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
          "isAnonymous": 0,
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
        setState(() {});
      }
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
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(
            child.length == 0 && child_load_done ? "你不可以在此板块发布信息" : "可以选择子板块:",
            style: TextStyle(color: os_deep_grey)),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
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
        color:
            Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
        child: sendSuccess
            ? SuccessDisplay()
            : Stack(
                children: [
                  Positioned(
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      controller: listview_controller,
                      children: [
                        TitleInput(
                          title_controller: title_controller,
                          title_focus: title_focus,
                        ),
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
                              YourEmoji(
                                backgroundColor:
                                    Provider.of<ColorProvider>(context).isDark
                                        ? os_dark_back
                                        : os_grey,
                                tap: (emoji) {
                                  int tmp_offset = tip_controller_offset;
                                  tip_controller.text = tip_controller.text
                                          .substring(0, tip_controller_offset) +
                                      emoji +
                                      tip_controller.text.substring(
                                          tip_controller_offset,
                                          tip_controller.text.length);
                                  tip_controller_offset =
                                      tmp_offset + emoji.toString().length;
                                },
                              ),
                              AtSomeone(
                                  hide: () {
                                    setState(() {
                                      pop_section = false;
                                    });
                                  },
                                  backgroundColor:
                                      Provider.of<ColorProvider>(context).isDark
                                          ? os_dark_back
                                          : os_grey,
                                  tap: (uid, name) {
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
                        color: Provider.of<ColorProvider>(context).isDark
                            ? os_light_dark_card
                            : os_white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(7),
                          topRight: Radius.circular(7),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: tip_focus.hasFocus ? 110 : 150,
                      padding: EdgeInsets.only(
                        left: 15,
                        right: 15,
                        top: 10,
                        bottom: 20,
                      ),
                      child: Column(
                        children: [
                          tip_focus.hasFocus
                              ? Container()
                              : Container(
                                  height: 40,
                                  child: Center(
                                    child: ListView(
                                      physics: BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      children: _buildChildList(),
                                    ),
                                  ),
                                ),
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
                                    70,
                                height: 30,
                                child: ListView(
                                  physics: BouncingScrollPhysics(),
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
                          ColumnSpace(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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

class LeftRowBtn extends StatefulWidget {
  FocusNode title_focus;
  FocusNode tip_focus;
  int pop_section_index;
  bool pop_section;
  bool uploading;
  Function setPopSection;
  Function setPopSectionIndex;
  Function setUploading;
  Function setImgUrls;
  List img_urls;
  LeftRowBtn({
    Key key,
    @required this.title_focus,
    @required this.tip_focus,
    @required this.pop_section_index,
    @required this.pop_section,
    @required this.uploading,
    @required this.setPopSection,
    @required this.setPopSectionIndex,
    @required this.setUploading,
    @required this.setImgUrls,
    @required this.img_urls,
  }) : super(key: key);

  @override
  State<LeftRowBtn> createState() => _LeftRowBtnState();
}

class _LeftRowBtnState extends State<LeftRowBtn> {
  @override
  Widget build(BuildContext context) {
    return Row(
      //左边按键区
      children: [
        myInkWell(
          color: Provider.of<ColorProvider>(context).isDark
              ? os_light_dark_card
              : os_white,
          tap: () {
            widget.title_focus.unfocus();
            widget.tip_focus.unfocus();
            if (widget.pop_section_index == 0 && widget.pop_section) {
              widget.setPopSection(false);
            } else {
              widget.setPopSection(true);
            }
            widget.setPopSectionIndex(0);
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
          color: Provider.of<ColorProvider>(context).isDark
              ? os_light_dark_card
              : os_white,
          tap: () {
            widget.title_focus.unfocus();
            widget.tip_focus.unfocus();
            if (widget.pop_section_index == 1 && widget.pop_section) {
              widget.setPopSection(false);
            } else {
              widget.setPopSection(true);
            }
            widget.setPopSectionIndex(1);
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
          color: Provider.of<ColorProvider>(context).isDark
              ? os_light_dark_card
              : os_white,
          tap: () async {
            showActionSheet(
              context: context,
              actions: [
                ActionItem(
                  title: "选择图片（建议5张以内）",
                  onPressed: () async {
                    widget.setImgUrls([]);
                    Navigator.pop(context);
                    widget.title_focus.unfocus();
                    widget.tip_focus.unfocus();
                    final ImagePicker _picker = ImagePicker();
                    var image = await _picker.pickMultiImage(
                      imageQuality: 50,
                    );
                    if (image == null || image.length == 0) {
                      return;
                    }
                    widget.setUploading(true);
                    widget.setImgUrls(await Api().uploadImage(imgs: image));
                    widget.setUploading(false);
                    setState(() {});
                  },
                ),
                ...(widget.img_urls.length == 0
                    ? []
                    : [
                        ActionItem(
                          title: "查看图片",
                          onPressed: () async {
                            Navigator.pop(context);
                            if (widget.img_urls.length != 0) {
                              print("${widget.img_urls}");
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => PhotoPreview(
                                    galleryItems: widget.img_urls
                                        .map((e) => e["urlName"])
                                        .toList(),
                                    defaultImage: 0,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        ActionItem(
                          title: "清空已上传图片",
                          onPressed: () {
                            widget.setImgUrls([]);
                            Navigator.pop(context);
                          },
                        ),
                      ]),
              ],
              bottomActionItem: BottomActionItem(title: "取消"),
            );
          },
          widget: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(2.5),
                child: widget.uploading
                    ? Container(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: os_deep_grey,
                        ),
                      )
                    : os_svg(
                        path: "lib/img/topic_line_image.svg",
                        width: 20,
                        height: 20,
                      ),
              ),
              widget.img_urls.length == 0
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
                            Radius.circular(
                              10,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            widget.img_urls.length.toString(),
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
        Container(width: 15),
        myInkWell(
          color: Provider.of<ColorProvider>(context).isDark
              ? os_light_dark_card
              : os_white,
          tap: () {
            widget.title_focus.unfocus();
            widget.tip_focus.unfocus();
            showModal(
              context: context,
              title: "提示",
              cont: "由于河畔后台限制，请在发帖后于评论区上传附件",
              confirmTxt: "我知道了",
              cancelTxt: "",
            );
          },
          widget: Container(
            padding: EdgeInsets.all(2.5),
            child: os_svg(
              path: "lib/img/topic_attach_black.svg",
              width: 22,
              height: 22,
            ),
          ),
          radius: 10,
          width: 30,
          height: 29,
        ),
      ],
    );
  }
}

class RightRowBtn extends StatefulWidget {
  bool show_vote;
  Function changeVoteStatus;
  Function changePopStatus;
  Function changeSecretSee;
  String select_section;
  int secret_see;
  FocusNode tip_focus;
  RightRowBtn({
    Key key,
    @required this.show_vote,
    @required this.changeVoteStatus,
    @required this.changePopStatus,
    @required this.select_section,
    @required this.changeSecretSee,
    @required this.secret_see,
    @required this.tip_focus,
  }) : super(key: key);

  @override
  State<RightRowBtn> createState() => _RightRowBtnState();
}

class _RightRowBtnState extends State<RightRowBtn> {
  @override
  Widget build(BuildContext context) {
    return Row(
      //右边功能区
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            height: 25,
            padding: EdgeInsets.symmetric(horizontal: 7),
            margin: EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(
                Radius.circular(100),
              ),
              border: Border.all(
                color: widget.show_vote ? Colors.red : Color(0xFF9D9D9D),
              ),
            ),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  widget.changePopStatus(false);
                  if (widget.show_vote) {
                    showModal(
                      context: context,
                      title: "请确认",
                      cont: "是否要删除此投票，请谨慎操作",
                      confirm: () {
                        widget.changeVoteStatus(false);
                      },
                    );
                  } else {
                    widget.changeVoteStatus(true);
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      widget.show_vote ? Icons.no_sim_outlined : Icons.add,
                      size: 12,
                      color: widget.show_vote ? Colors.red : Color(0xFF9D9D9D),
                    ),
                    widget.show_vote
                        ? Text(
                            "删除投票",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          )
                        : Text(
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
          ),
        ),
        widget.select_section != "密语"
            ? Container()
            : GestureDetector(
                onTap: () {
                  showActionSheet(
                    context: context,
                    topActionItem: TopActionItem(
                      title: "评论有哪些人可以👀",
                      titleTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    actions: [
                      ActionItem(
                        title: "评论所有人可见",
                        onPressed: () {
                          Navigator.pop(context);
                          widget.changeSecretSee(0);
                        },
                      ),
                      ActionItem(
                        title: "评论仅作者可见",
                        onPressed: () {
                          Navigator.pop(context);
                          widget.changeSecretSee(1);
                        },
                      ),
                    ],
                    bottomActionItem: BottomActionItem(title: "取消"),
                  );
                },
                child: Container(
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
                        Text(
                          widget.secret_see == 0 ? "所有人可见" : "仅作者可见",
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
              ),
        !widget.tip_focus.hasFocus
            ? Container()
            : GestureDetector(
                onTap: () {
                  widget.tip_focus.unfocus();
                },
                child: Container(
                  height: 25,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  margin: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    color: os_color,
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Text(
                          "完成",
                          style: TextStyle(
                            fontSize: 12,
                            color: os_white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}

class ColumnSpace extends StatelessWidget {
  const ColumnSpace({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      height: 1,
      margin: EdgeInsets.symmetric(vertical: 10),
      color: Provider.of<ColorProvider>(context).isDark
          ? Color.fromRGBO(255, 255, 255, 0.1)
          : Color(0xFFEFEFEF),
    );
  }
}

class SelectColumn extends StatelessWidget {
  const SelectColumn({
    Key key,
    @required this.select_section,
  }) : super(key: key);

  final String select_section;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class SuccessDisplay extends StatelessWidget {
  const SuccessDisplay({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.done,
            size: 50,
            color: Provider.of<ColorProvider>(context).isDark
                ? os_dark_white
                : os_deep_blue,
          ),
          Container(height: 10),
          Text(
            "发表成功",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Provider.of<ColorProvider>(context).isDark
                  ? os_dark_white
                  : os_black,
            ),
          ),
          Container(height: 10),
          Container(
            width: 300,
            child: Text(
              "你已成功发送该帖子，帖子显示在首页会有延时，你可以点击下方按钮查看",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_dark_white
                    : os_black,
              ),
            ),
          ),
          Container(height: 300),
          GestureDetector(
            onTap: () async {
              String myinfo_txt = await getStorage(key: "myinfo", initData: "");
              Map myinfo = jsonDecode(myinfo_txt);
              Navigator.pushNamed(
                context,
                "/me_func",
                arguments: {"type": 2, "uid": myinfo["uid"]},
              );
            },
            child: Container(
              width: 150,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_light_dark_card
                    : Color.fromRGBO(0, 77, 255, 1),
              ),
              child: Center(
                child: Text(
                  "查看帖子",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Provider.of<ColorProvider>(context).isDark
                        ? os_dark_white
                        : os_white,
                  ),
                ),
              ),
            ),
          ),
          Container(height: 100),
        ],
      ),
    );
  }
}

class SaveDraftBtn extends StatelessWidget {
  const SaveDraftBtn({
    Key key,
    @required this.tip_controller,
    @required this.tip_focus,
  }) : super(key: key);

  final TextEditingController tip_controller;
  final FocusNode tip_focus;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (tip_controller.text == "") return;
        String tmp = await getStorage(key: "draft", initData: "[]");
        List tmp_arr = jsonDecode(tmp);
        List tmp_tmp_arr = [tip_controller.text];
        tmp_tmp_arr.addAll(tmp_arr);
        await setStorage(key: "draft", value: jsonEncode(tmp_tmp_arr));
        showToast(context: context, type: XSToast.success, txt: "保存成功！");
        tip_focus.unfocus();
      },
      child: SaveDraft(),
    );
  }
}

class SaveDraft extends StatelessWidget {
  const SaveDraft({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Provider.of<ColorProvider>(context).isDark
              ? Color.fromRGBO(0, 146, 255, 0.2)
              : os_color_opa,
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
        child: Center(
          child: Container(
            child: Text(
              "保存草稿",
              style: TextStyle(color: os_color),
            ),
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
    return Container(
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
    return Container(
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
        cursorColor: Provider.of<ColorProvider>(context).isDark
            ? os_dark_back
            : os_white,
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
          hintText: isMacOS() ? "请输入帖子的标题，按住control键+空格键以切换中英文输入法" : "请输入帖子的标题",
        ),
      ),
    );
  }
}

class VoteMachine extends StatefulWidget {
  Function confirm; //返回投票选项的List<String>数组即可
  Function tap;
  Function focus;
  Function editVote;
  VoteMachine({
    Key key,
    this.confirm,
    this.tap,
    this.focus,
    this.editVote,
  }) : super(key: key);

  @override
  State<VoteMachine> createState() => _VoteMachineState();
}

class _VoteMachineState extends State<VoteMachine> {
  List<Map> options = [
    {"index": 0, "txt": ""},
    {"index": 1, "txt": ""},
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 115),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Provider.of<ColorProvider>(context).isDark
            ? os_dark_card
            : os_white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          Container(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  os_svg(path: "lib/img/vote.svg", width: 22, height: 22),
                  Container(width: 2),
                  Text(
                    "投票",
                    style: TextStyle(
                      fontSize: 15,
                      color: Provider.of<ColorProvider>(context).isDark
                          ? os_dark_white
                          : os_black,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  if (widget.tap != null) widget.tap();
                  options.add({
                    "index": options.length - 1,
                    "txt": "",
                  });
                  for (var i = 0; i < options.length; i++) {
                    options[i]["index"] = i;
                  }
                  setState(() {});
                },
                child: Text(
                  "+新增选项",
                  style: TextStyle(fontSize: 15, color: Color(0xFFB9B9B9)),
                ),
              ),
            ],
          ),
          Container(height: 10),
          Column(
            children: options.map((e) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_light_dark_card
                      : Color(0xFFF1F4F8),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 105,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 45,
                      child: TextField(
                        onTap: () {
                          widget.focus();
                        },
                        style: TextStyle(
                          color: Provider.of<ColorProvider>(context).isDark
                              ? os_dark_white
                              : os_black,
                        ),
                        onChanged: (value) {
                          options[e["index"]]["txt"] = value;
                          print("${options}");
                          widget.editVote(options);
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "请输入选项",
                          hintStyle: TextStyle(
                            color: Provider.of<ColorProvider>(context).isDark
                                ? os_dark_dark_white
                                : os_black,
                          ),
                        ),
                      ),
                    ),
                    e["index"] != options.length - 1
                        ? Container()
                        : GestureDetector(
                            onTap: () {
                              options.removeAt(e["index"]);
                              for (var i = 0; i < options.length; i++) {
                                options[i]["index"] = i;
                              }
                              setState(() {});
                            },
                            child: Text(
                              "删除",
                              style: TextStyle(
                                color: os_color,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
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
          color: widget.selected ?? false
              ? (Provider.of<ColorProvider>(context).isDark
                  ? Color.fromRGBO(0, 146, 255, 0.2)
                  : os_color_opa)
              : (Provider.of<ColorProvider>(context).isDark
                  ? os_light_dark_card
                  : Color(0xFFF6F6F6)),
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
        padding: EdgeInsets.only(left: 5, right: 10, top: 14, bottom: 14),
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
