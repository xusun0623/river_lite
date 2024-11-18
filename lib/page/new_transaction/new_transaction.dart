import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:offer_show/asset/bigScreen.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/home_desktop_mode.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/xs_textstyle.dart';
import 'package:offer_show/components/newNaviBar.dart';
import 'package:offer_show/page/topic/At_someone.dart';
import 'package:offer_show/page/topic/Your_emoji.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

import 'draft.dart';
import 'left_row_btn.dart';
import 'right_row_btn.dart';
import 'select_tag.dart';
import 'success_display.dart';

class PostNewTransaction extends StatefulWidget {
  PostNewTransaction({
    Key? key,
  }) : super(key: key);

  @override
  _PostNewTransactionState createState() => _PostNewTransactionState();
}

class _PostNewTransactionState extends State<PostNewTransaction> {
  bool sendSuccess = false; //是否发布成功

  String select_section = "二手专区"; //选择的专栏的名称
  int select_section_id = 61; //选择的专栏的ID
  int select_section_child_id = 286; //选择的专栏的子专栏ID
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
  List img_urls = [];

  // 想问下 M1 MacBook air 16+512 多少钱收比较合适
  // rt，最近想换一台设备，但是感觉全新的有点贵

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

  @override
  Widget build(BuildContext context) {
    return Baaaar(
      color:
          Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
      child: WillPopScope(
        onWillPop: () async {
          if (sendSuccess) {
            Navigator.pop(context);
          } else {
            showModal(
                context: context,
                cont: "如果现在退出，草稿内容将不会保存",
                confirm: () {
                  Navigator.pop(context);
                });
          }
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Provider.of<ColorProvider>(context).isDark
                ? os_dark_back
                : os_back,
            elevation: 0,
            title: Text(
              sendSuccess ? "" : "发闲置二手",
              style: XSTextStyle(
                context: context,
                fontSize: 16,
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_dark_white
                    : Color(0xFF2E2E2E),
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.chevron_left_rounded,
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_dark_dark_white
                      : Color(0xFF2E2E2E)),
              onPressed: () {
                if (sendSuccess) {
                  Navigator.pop(context);
                } else {
                  showModal(
                      context: context,
                      cont: "如果现在退出，草稿内容将不会保存",
                      confirm: () {
                        Navigator.pop(context);
                      });
                }
              },
            ),
            actions: sendSuccess
                ? []
                : [
                    SaveDraftBtn(
                      tip_controller: tip_controller,
                      tip_focus: tip_focus,
                    ),
                    uploading ? Container(width: 10) : RightTopSend(tap: _send)
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
                          ],
                        ),
                      ),
                      Positioned(
                        child: pop_section
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                height: 250,
                                color:
                                    Provider.of<ColorProvider>(context).isDark
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
                                        tip_controller.text =
                                            tip_controller.text.substring(
                                                    0, tip_controller_offset) +
                                                emoji +
                                                tip_controller.text.substring(
                                                    tip_controller_offset,
                                                    tip_controller.text.length);
                                        tip_controller_offset = tmp_offset +
                                            emoji.toString().length;
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
                                      },
                                    ),
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
                              SectionSelect(
                                hideSection: !tip_focus.hasFocus,
                                tap: (column_id) {
                                  setState(() {
                                    select_section_child_id = column_id;
                                  });
                                },
                              ),
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
                                          pop_section_index =
                                              setPopSectionIndex;
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
      ),
    );
  }
}

class SectionSelect extends StatefulWidget {
  Function? tap;
  bool? hideSection;
  SectionSelect({
    Key? key,
    this.tap,
    this.hideSection,
  }) : super(key: key);

  @override
  State<SectionSelect> createState() => _SectionSelectState();
}

class _SectionSelectState extends State<SectionSelect> {
  int section_idx = 0;
  int type_idx = 0;
  Map child = {
    "清水河-书籍资料": 286,
    "清水河-生活用品": 291,
    "清水河-交通工具": 290,
    "清水河-卡券虚拟": 289,
    "清水河-数码硬件": 287,
    "清水河-拼单": 288,
    "清水河-物品租借": 1287,
    "清水河-其他": 292,
    "沙河-书籍资料": 293,
    "沙河-生活用品": 777,
    "沙河-交通工具": 297,
    "沙河-卡券虚拟": 296,
    "沙河-数码硬件": 294,
    "沙河-拼单": 1286,
    "沙河-物品租借": 1288,
    "沙河-其他": 778,
  }; //子帖子专栏
  List<String> child_type = [
    "书籍资料",
    "生活用品",
    "交通工具",
    "卡券虚拟",
    "数码硬件",
    "拼单",
    "物品租借",
    "其他",
  ]; //子帖子专栏
  List<String> section_type = [
    "清水河",
    "沙河",
  ]; //子帖子专栏

  refresh() {
    String child_section =
        "${section_type[section_idx]}-${child_type[type_idx]}";
    if (widget.tap != null) {
      widget.tap!(child["$child_section"]);
    }
  }

  List<Widget> _buildChildList() {
    List<Widget> tmp = [];
    tmp.add(Padding(
      padding: const EdgeInsets.only(right: 10, top: 7.5, bottom: 7.5),
      child: Text(
        "选择校区:",
        style: XSTextStyle(
          context: context,
          color: Provider.of<ColorProvider>(context).isDark
              ? os_dark_dark_white
              : os_dark_back,
        ),
      ),
    ));
    for (var i = 0; i < section_type.length; i++) {
      tmp.add(GestureDetector(
        onTap: () {
          setState(() {
            section_idx = i;
          });
          refresh();
        },
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 7.5, bottom: 7.5),
          decoration: BoxDecoration(
            color: i == section_idx
                ? os_color_opa
                : (Provider.of<ColorProvider>(context).isDark
                    ? os_light_dark_card
                    : os_white),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            section_type[i],
            style: XSTextStyle(
              context: context,
              color: i == section_idx ? os_color : os_deep_grey,
              fontWeight:
                  i == section_idx ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ));
    }
    return tmp;
  }

  List<Widget> _buildTypeList() {
    List<Widget> tmp = [];
    tmp.add(Padding(
      padding: const EdgeInsets.only(right: 10, top: 7.5, bottom: 7.5),
      child: Text(
        "选择类型:",
        style: XSTextStyle(
          context: context,
          color: Provider.of<ColorProvider>(context).isDark
              ? os_dark_dark_white
              : os_dark_back,
        ),
      ),
    ));
    for (var i = 0; i < child_type.length; i++) {
      tmp.add(GestureDetector(
        onTap: () {
          setState(() {
            type_idx = i;
          });
          refresh();
        },
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 7.5, bottom: 7.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: i == type_idx
                ? os_color_opa
                : (Provider.of<ColorProvider>(context).isDark
                    ? os_light_dark_card
                    : os_white),
          ),
          child: Text(
            child_type[i],
            style: XSTextStyle(
              context: context,
              color: i == type_idx ? os_color : os_deep_grey,
              fontWeight: i == type_idx ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ));
    }
    return tmp;
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 40,
        ),
        child: Column(
          children: [
            widget.hideSection ?? false
                ? Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Wrap(
                          children: [
                            ..._buildChildList(),
                          ],
                        ),
                      ),
                    ],
                  )
                : Container(),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width -
                      30 -
                      MinusSpace(context),
                  margin: EdgeInsets.only(bottom: 10),
                  child: Wrap(
                    children: widget.hideSection ?? false
                        ? _buildTypeList()
                        : [
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 10, top: 7.5, bottom: 7.5),
                              child: Text(
                                "已选类型:",
                                style: XSTextStyle(
                                  context: context,
                                  color:
                                      Provider.of<ColorProvider>(context).isDark
                                          ? os_dark_dark_white
                                          : os_dark_back,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, top: 7.5, bottom: 7.5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: os_color_opa,
                              ),
                              child: Text(
                                child_type[type_idx],
                                style: XSTextStyle(
                                  context: context,
                                  color: os_color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChildColumnTip extends StatefulWidget {
  bool? select;
  String? name;
  int? child_id;
  Function? tap;
  ChildColumnTip({
    Key? key,
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
        widget.tap!(widget.child_id);
      },
      child: Container(
        padding: EdgeInsets.only(left: 0, right: 20, top: 5, bottom: 5),
        color: Provider.of<ColorProvider>(context).isDark
            ? os_light_dark_card
            : os_white,
        child: Text(
          widget.name!,
          style: XSTextStyle(
            context: context,
            color: widget.select! ? os_color : os_deep_grey,
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
    Key? key,
    required this.tip_controller,
    required this.tip_focus,
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
          keyboardAppearance:
              Provider.of<ColorProvider>(context, listen: false).isDark
                  ? Brightness.dark
                  : Brightness.light,
          controller: widget.tip_controller,
          focusNode: widget.tip_focus,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          cursorColor: os_color,
          style: XSTextStyle(
            context: context,
            height: 1.8,
            fontSize: 15,
            color: Provider.of<ColorProvider>(context).isDark
                ? os_dark_dark_white
                : os_black,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 500, top: 10),
            border: InputBorder.none,
            hintStyle: XSTextStyle(
              context: context,
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
    Key? key,
    required this.title_controller,
    required this.title_focus,
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
          keyboardAppearance:
              Provider.of<ColorProvider>(context, listen: false).isDark
                  ? Brightness.dark
                  : Brightness.light,
          controller: title_controller,
          focusNode: title_focus,
          style: XSTextStyle(
            context: context,
            fontSize: 17,
            color: Provider.of<ColorProvider>(context).isDark
                ? os_dark_white
                : os_black,
          ),
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
            hintStyle: XSTextStyle(
              context: context,
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
