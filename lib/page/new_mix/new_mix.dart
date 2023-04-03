import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:offer_show/asset/bigScreen.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/home_desktop_mode.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/phone_pick_images.dart';
import 'package:offer_show/asset/showPop.dart';
import 'package:offer_show/asset/uploadAttachment.dart';
import 'package:offer_show/components/newNaviBar.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/page/new/success_display.dart';
import 'package:offer_show/page/topic/Your_emoji.dart';
import 'package:offer_show/page/topic/topic_RichInput.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

final GlobalKey<MixContSectionState> mixContSectionKey = GlobalKey();

class PostWithImagePopWidget extends StatefulWidget {
  String title = "";
  List<BodyCont> cont;
  int column_id = 0;
  int column_child_id = 0;
  Function successSent;
  PostWithImagePopWidget({
    Key key,
    this.title,
    this.cont,
    this.column_id,
    this.column_child_id,
    this.successSent,
  }) : super(key: key);

  @override
  State<PostWithImagePopWidget> createState() => _PostWithImagePopWidgetState();
}

class _PostWithImagePopWidgetState extends State<PostWithImagePopWidget> {
  int progress = 0;
  int total_cnt = 1;
  bool successSent = false;
  List<Map> cont_map_list = []; // { "type": 0, "cont": "" }
  List<BodyCont> cont_tmp = [];
  String aid = "";

  countNum() {
    total_cnt = 0;
    widget.cont.forEach((element) {
      if (element.type == BodyContType.image) {
        total_cnt++;
      }
      if (element.cont != "") {
        cont_tmp.add(element);
      }
    });
    setState(() {});
  }

  uploadData() async {
    cont_map_list = [];
    for (var i = 0; i < cont_tmp.length; i++) {
      if (cont_tmp[i].type == BodyContType.txt) {
        // 文字
        cont_map_list.add({
          "type": 0, // 0-文字 1-图片
          "cont": cont_tmp[i].cont,
        });
      } else {
        // 图片
        List img_urls = await Api().uploadImage(
          imgs: [XFile(cont_tmp[i].cont)],
        );
        setState(() {
          progress++;
        });
        aid += (aid == ""
            ? img_urls[0]["id"].toString()
            : "," + img_urls[0]["id"].toString());
        cont_map_list.add({
          "type": 1, // 0-文字 1-图片
          "cont": img_urls[0]["urlName"],
        });
      }
    }

    // print("$cont_map_list");
    // print("$aid");

    List<Map> _buildPureContent() {
      List<Map> t = [];
      cont_map_list.forEach((element) {
        t.add({"type": element["type"], "infor": element["cont"]});
      });
      return t;
    }

    Map json = {
      "body": {
        "json": {
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "typeId": widget.column_child_id == 0 ? "" : widget.column_child_id,
          "aid": aid,
          "fid": widget.column_id,
          "isQuote": 0, // 是否引用之前回复的内容
          "title": widget.title,
          "content": jsonEncode(_buildPureContent()),
          "poll": "",
        }
      }
    };

    var ret_tip = await Api().forum_topicadmin({
      "act": "new",
      "json": jsonEncode(json),
    });
    if (ret_tip["rs"] == 1) {
      if (widget.successSent != null) {
        widget.successSent();
      }
    } else {
      showToast(
        context: context,
        type: XSToast.none,
        txt: ret_tip["errcode"],
      );
    }
  }

  @override
  void initState() {
    countNum();
    uploadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        height: 300,
        child: Column(
          children: [
            Container(
              child: Lottie.asset(
                "lib/lottie/loading.json",
                width: 200,
                height: 200,
              ),
            ),
            Container(height: 5),
            Text(
              "${progress}/${total_cnt}",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_dark_white
                    : os_black,
              ),
            ),
            Container(height: 10),
            Text(
              "上传图片中",
              style: TextStyle(
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_dark_white
                    : os_black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostNewMix extends StatefulWidget {
  int board_id;

  PostNewMix({
    Key key,
    this.board_id,
  }) : super(key: key);

  @override
  _PostNewMixState createState() => _PostNewMixState();
}

class _PostNewMixState extends State<PostNewMix> {
  bool successSent = false;

  bool choosingEmoji = false;
  int state = 0; // 0-不显示 1-显示Icon 2-显示Emoji
  int column_id = 0;
  int column_child_id = 0;
  String column_name = "";
  String title = "";
  List<BodyCont> cont = [];

  List<Map> _buildPureTxtContent() {
    List<Map> t = [];
    cont.forEach((element) {
      t.add({"type": 0, "infor": element.cont});
    });
    return t;
  }

  send() async {
    if (title == "") {
      showToast(context: context, type: XSToast.none, txt: "标题内容不可为空");
      return;
    }
    if (column_id == 0 || column_child_id == 0) {
      showToast(context: context, type: XSToast.none, txt: "请选择板块后发布");
      return;
    }
    bool isTxtNotEmpty = false;
    cont.forEach((element) {
      if (element.cont != "") {
        isTxtNotEmpty = true;
      }
    });

    if (!isTxtNotEmpty) {
      showToast(context: context, type: XSToast.none, txt: "正文内容不可以为空");
      return;
    }
    // 水水
    // 小学生该刷起算法题辣
    // wohu 1234567xS

    bool hasImage = false;
    cont.forEach(
      (element) {
        if (element.type == BodyContType.image) {
          hasImage = true;
        }
      },
    );
    if (hasImage) {
      showPopWithHeight(
        context,
        [
          Container(height: 30),
          PostWithImagePopWidget(
            title: title,
            cont: cont,
            column_id: column_id,
            column_child_id: column_child_id,
            successSent: () {
              Navigator.pop(context);
              setState(() {
                successSent = true;
              });
            },
          ),
        ],
        MediaQuery.of(context).size.height - 150,
      );
    } else {
      assert(title != "" && cont.length != 0);
      //只有文字的发送
      // 水水，大年初一晚上
      // 大伙在干啥
      Map json = {
        "body": {
          "json": {
            "isAnonymous": 0,
            "isOnlyAuthor": 0,
            "typeId": column_child_id == 0 ? "" : column_child_id,
            "aid": "",
            "fid": column_id,
            "isQuote": 0, // 是否引用之前回复的内容
            "title": title,
            "content": jsonEncode(_buildPureTxtContent()),
            "poll": "",
          }
        }
      };
      showToast(context: context, type: XSToast.loading, txt: "发表中…");
      var ret_tip = await Api().forum_topicadmin({
        "act": "new",
        "json": jsonEncode(json),
      });
      hideToast();
      if (ret_tip["rs"] == 1) {
        setState(() {
          successSent = true;
        });
      } else {
        showToast(
          context: context,
          type: XSToast.none,
          txt: ret_tip["errcode"],
        );
      }
    }
  }

  clickEmoji() {
    FocusManager.instance.primaryFocus.unfocus();
    setState(() {
      choosingEmoji = true;
      state = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Baaaar(
      color:
          Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_white,
      child: WillPopScope(
        onWillPop: () async {
          showModal(
              context: context,
              cont: "如果现在退出，你的草稿内容将不会被保存",
              confirm: () {
                Navigator.pop(context);
              });
          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: Provider.of<ColorProvider>(context).isDark
                ? os_dark_back
                : os_white,
            elevation: 0,
            actions: successSent
                ? []
                : [
                    Transform.translate(
                      offset: Offset(5, 0),
                      child: SwitchHead(small: false),
                    ),
                    // Container(width: 5),
                    GestureDetector(
                      child: SelectColumn(
                        column_id: column_id,
                        column_child_id: column_child_id,
                        txt: column_name,
                        selectColumn: (s, id_1, id_2) {
                          setState(() {
                            column_name = s;
                            column_id = id_1;
                            column_child_id = id_2;
                          });
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // 发布
                        print(title);
                        cont.forEach((element) {
                          print("${element.cont}");
                        });
                        send();
                      },
                      child: ConfirmPost(),
                    ),
                    Container(width: 5),
                  ],
            leading: IconButton(
              icon: Icon(Icons.chevron_left_rounded,
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_dark_dark_white
                      : Color(0xFF2E2E2E)),
              onPressed: () {
                showModal(
                    context: context,
                    cont: "如果现在退出，你的草稿内容将不会被保存",
                    confirm: () {
                      Navigator.pop(context);
                    });
              },
            ),
          ),
          body: successSent
              ? Container(
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_dark_back
                      : os_white,
                  child: SuccessDisplay(),
                )
              : Container(
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_dark_back
                      : os_white,
                  child: Stack(
                    children: [
                      MixContSection(
                        state: state,
                        clickEmoji: clickEmoji,
                        key: mixContSectionKey,
                        emitTitle: (res) {
                          setState(() {
                            title = res;
                          });
                        },
                        emit: (List<BodyCont> res) {
                          cont = res;
                        },
                        setState: (i) {
                          setState(() {
                            state = i;
                          });
                        },
                        focus: () {
                          if (!isDesktop()) {
                            setState(() {
                              state = 1;
                            });
                          }
                        },
                      ),
                      state == 1 && !isDesktop()
                          ? Positioned(
                              child: Container(
                                color:
                                    Provider.of<ColorProvider>(context).isDark
                                        ? os_light_dark_card
                                        : os_white,
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                            color: Provider.of<ColorProvider>(
                                                        context)
                                                    .isDark
                                                ? os_light_dark_card
                                                : os_grey,
                                          ),
                                        ),
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      child: ResponsiveWidget(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.emoji_emotions_outlined,
                                                color: os_deep_grey,
                                              ),
                                              onPressed: clickEmoji,
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.keyboard_hide_rounded,
                                                color: os_deep_grey,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  choosingEmoji = false;
                                                  state = 0;
                                                });
                                                FocusManager
                                                    .instance.primaryFocus
                                                    .unfocus(); //去除焦点
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              bottom: 0,
                              left: 0,
                            )
                          : Container(),
                      state == 2
                          ? Positioned(
                              child: Container(
                                color:
                                    Provider.of<ColorProvider>(context).isDark
                                        ? os_light_dark_card
                                        : os_white,
                                height: 360,
                                width: MediaQuery.of(context).size.width,
                                child: ResponsiveWidget(
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              color: Provider.of<ColorProvider>(
                                                          context)
                                                      .isDark
                                                  ? os_light_dark_card
                                                  : os_grey,
                                            ),
                                          ),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ResponsiveWidget(
                                          child: Row(
                                            mainAxisAlignment: isDesktop()
                                                ? MainAxisAlignment.center
                                                : MainAxisAlignment
                                                    .spaceBetween,
                                            children: [
                                              ...(isDesktop()
                                                  ? []
                                                  : [
                                                      IconButton(
                                                        icon: Icon(
                                                          Icons
                                                              .emoji_emotions_outlined,
                                                          color: os_deep_grey,
                                                        ),
                                                        onPressed: () {
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              .unfocus();
                                                          setState(() {
                                                            choosingEmoji =
                                                                true;
                                                            state = 2;
                                                          });
                                                        },
                                                      )
                                                    ]),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.keyboard_hide_rounded,
                                                  color: os_deep_grey,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    choosingEmoji = false;
                                                    state = 0;
                                                  });
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      .unfocus(); //去除焦点
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: YourEmoji(
                                          tap: (res) {
                                            mixContSectionKey.currentState
                                                .insertEmoji(res);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              bottom: 0,
                              left: 0,
                            )
                          : Container(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

enum BodyContType {
  image,
  txt,
}

class BodyCont {
  BodyContType type; //类型
  //type==image，cont为path；
  //type==txt，cont为内容；
  String cont; //内容
  BodyCont(BodyContType t, String c) {
    this.type = t;
    this.cont = c;
  }
}

class MixContSection extends StatefulWidget {
  Function focus;
  Function setState;
  Function emit;
  Function emitTitle;
  Function clickEmoji;
  int state;
  MixContSection({
    Key key,
    this.focus,
    this.setState,
    this.state,
    this.emit,
    this.emitTitle,
    this.clickEmoji,
  }) : super(key: key);

  @override
  State<MixContSection> createState() => MixContSectionState();
}

class MixContSectionState extends State<MixContSection> {
  int hasFocusIndex = -1;
  int lastEditIndex = 0;
  int lastEditPos = 0;

  List<BodyCont> body_cont = [BodyCont(BodyContType.txt, "")];
  List<FocusNode> _focusNode = [];
  List<TextEditingController> _textEditingController = [];

  returnTotalCont() {
    if (widget.emit != null) {
      widget.emit(body_cont);
    }
  }

  insertEmoji(String s) {
    final int lastEditPosTmp = lastEditPos;
    final String txt = _textEditingController[lastEditIndex].text;
    _textEditingController[lastEditIndex].text =
        txt.substring(0, lastEditPos) + s + txt.substring(lastEditPos);
    setState(() {});
    lastEditPos = lastEditPosTmp + s.length;
    setState(() {});
    unFocus();
  }

  rebuildControlList() {
    _focusNode = [];
    _textEditingController = [];
    for (var i = 0; i < body_cont.length; i++) {
      _focusNode.add(FocusNode());
      _textEditingController.add(
        TextEditingController(text: body_cont[i].cont),
      );
    }
    unFocus();
    setState(() {});
    listenController();
  }

  unFocus() {
    FocusManager.instance.primaryFocus.unfocus(); //去除焦点
  }

  List<Widget> _buildCont() {
    List<Widget> _body_cont_tmp = [];
    for (var i = 0; i < body_cont.length; i++) {
      final BodyCont _body_cont_single = body_cont[i];
      if (_body_cont_single.type == BodyContType.txt) {
        _body_cont_tmp.add(MixContInput(
          controller: _textEditingController[i],
          focusNode: _focusNode[i],
          placeholder: i == 0 ? "正文" : "点击输入内容",
        ));
      }
      if (_body_cont_single.type == BodyContType.image) {
        _body_cont_tmp.add(MixPic(
          path: _body_cont_single.cont,
          delete: () {
            unFocus();
            for (var i = 0; i < body_cont.length; i++) {
              if (body_cont[i].cont == _body_cont_single.cont) {
                if (i + 1 < body_cont.length &&
                    _textEditingController[i + 1].text == "") {
                  _textEditingController.removeAt(i);
                  _textEditingController.removeAt(i);
                  _focusNode.removeAt(i);
                  _focusNode.removeAt(i);
                  body_cont.removeAt(i);
                  body_cont.removeAt(i);
                } else {
                  _textEditingController.removeAt(i);
                  _focusNode.removeAt(i);
                  body_cont.removeAt(i);
                }
                setState(() {});
              }
            }
            mergeInput();
            returnTotalCont();
          },
        ));
      }
    }
    _body_cont_tmp.add(
      ResponsiveWidget(
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 10),
              child: myInkWell(
                radius: 2.5,
                tap: addPic,
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_light_dark_card
                    : os_grey,
                widget: Container(
                  padding: EdgeInsets.all(25),
                  child: Icon(
                    Icons.add_photo_alternate_outlined,
                    color: os_deep_grey,
                  ),
                ),
              ),
            ),
            Platform.isAndroid || Platform.isIOS
                ? Container(
                    margin: EdgeInsets.only(
                      top: 20,
                      bottom: 20,
                      right: 10,
                    ),
                    child: myInkWell(
                      radius: 2.5,
                      tap: addCamera,
                      color: Provider.of<ColorProvider>(context).isDark
                          ? os_light_dark_card
                          : os_grey,
                      widget: Container(
                        padding: EdgeInsets.all(25),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: os_deep_grey,
                        ),
                      ),
                    ),
                  )
                : Container(),
            !isDesktop()
                ? Container()
                : Container(
                    margin: EdgeInsets.only(
                      top: 20,
                      bottom: 20,
                      right: 10,
                    ),
                    child: myInkWell(
                      radius: 2.5,
                      tap: () {
                        if (widget.clickEmoji != null) {
                          widget.clickEmoji();
                        }
                      },
                      color: Provider.of<ColorProvider>(context).isDark
                          ? os_light_dark_card
                          : os_grey,
                      widget: Container(
                        padding: EdgeInsets.all(25),
                        child: Icon(
                          Icons.emoji_emotions_outlined,
                          color: os_deep_grey,
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
    return _body_cont_tmp;
  }

  mergeInput() {
    for (var i = 0; i < body_cont.length; i++) {
      if (i < body_cont.length - 1 &&
          body_cont[i].type == BodyContType.txt &&
          body_cont[i + 1].type == BodyContType.txt) {
        //合并两个相邻的Input
        body_cont[i].cont += "\n" + body_cont[i + 1].cont;
        _textEditingController[i].text +=
            "\n" + _textEditingController[i + 1].text;
        body_cont.removeAt(i + 1);
        _textEditingController.removeAt(i + 1);
        _focusNode.removeAt(i + 1);
        rebuildControlList();
      }
    }
  }

  addCamera() async {
    unFocus();
    final XFile photo = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    body_cont.add(BodyCont(BodyContType.image, photo.path));
    body_cont.add(BodyCont(BodyContType.txt, ""));
    rebuildControlList();
    returnTotalCont();
    setState(() {});
  }

  addPic() async {
    unFocus();
    if (isMacOS()) {
      // 桌面端
      List<XFile> images = await pickeImgFile(context);
      for (var i = 0; i < images.length; i++) {
        final XFile element = images[i];
        body_cont.add(BodyCont(BodyContType.image, element.path));
        body_cont.add(BodyCont(BodyContType.txt, ""));
      }
    } else {
      // 移动端
      // List<Media> res = await ImagesPicker.pick(
      //   count: 10,
      //   pickType: PickType.image,
      //   quality: 0.7, //一半的质量
      //   // maxSize: 2048, //1024KB
      // );
      List res = await getPhoneImages(context);
      for (var i = 0; i < res.length; i++) {
        final XFile element = XFile(res[i].path);
        body_cont.add(BodyCont(BodyContType.image, element.path));
        body_cont.add(BodyCont(BodyContType.txt, ""));
      }
    }
    rebuildControlList();
    returnTotalCont();
    setState(() {});
  }

  listenController() {
    for (var i = 0; i < _textEditingController.length; i++) {
      _textEditingController[i].addListener(() {
        if (body_cont[i].type == BodyContType.txt) {
          body_cont[i].cont = _textEditingController[i].text;
        }
        setState(() {
          lastEditPos = _textEditingController[i].selection.base.offset;
          returnTotalCont();
        });
      });
    }
    for (var i = 0; i < _focusNode.length; i++) {
      _focusNode[i].addListener(() {
        if (_focusNode[i].hasFocus) {
          if (widget.focus != null) widget.focus();
          setState(() {
            lastEditIndex = i;
            returnTotalCont();
          });
        }
      });
    }
  }

  @override
  void initState() {
    listenController();
    rebuildControlList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              MixTitleInput(
                emitTxt: (res) {
                  if (widget.emitTitle != null) {
                    widget.emitTitle(res);
                  }
                },
              ),
              ..._buildCont(),
            ],
          ),
        ),
        Container(
          height: widget.state == 1
              ? 100
              : widget.state == 2
                  ? 360
                  : 100,
        ),
      ],
    );
  }
}

class MixPic extends StatefulWidget {
  String path;
  Function delete;
  MixPic({
    Key key,
    this.path,
    this.delete,
  }) : super(key: key);

  @override
  State<MixPic> createState() => _MixPicState();
}

class _MixPicState extends State<MixPic> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Stack(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isDesktop() ? 400 : 10000,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2.5),
              child: Image.file(File(widget.path)),
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: myInkWell(
              tap: () {
                if (widget.delete != null) widget.delete();
              },
              color: Color(0x44000000),
              widget: Padding(
                padding: EdgeInsets.all(6),
                child: Icon(
                  Icons.close,
                  color: Color(0xccffffff),
                  size: 20,
                ),
              ),
              radius: 2.5,
            ),
          ),
        ],
      ),
    );
  }
}

class MixContInput extends StatefulWidget {
  TextEditingController controller;
  FocusNode focusNode;
  String placeholder;
  MixContInput({
    Key key,
    this.controller,
    this.focusNode,
    this.placeholder,
  }) : super(key: key);

  @override
  State<MixContInput> createState() => _MixContInputState();
}

class _MixContInputState extends State<MixContInput> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          keyboardAppearance:
              Provider.of<ColorProvider>(context, listen: false).isDark
                  ? Brightness.dark
                  : Brightness.light,
          scrollPadding: EdgeInsets.only(bottom: 60),
          controller: widget.controller,
          focusNode: widget.focusNode,
          cursorColor: Provider.of<ColorProvider>(context).isDark
              ? os_dark_dark_white
              : os_deep_blue,
          maxLines: null,
          style: TextStyle(
            color: Provider.of<ColorProvider>(context).isDark
                ? os_dark_white
                : os_black,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 15),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide.none,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide.none,
            ),
            hintText: widget.placeholder ?? "点击输入内容",
            hintStyle: TextStyle(
              color: Provider.of<ColorProvider>(context).isDark
                  ? Color(0x55ffffff)
                  : os_deep_grey,
            ),
          ),
        ),
      ),
    );
  }
}

class MixTitleInput extends StatefulWidget {
  Function emitTxt;
  MixTitleInput({
    Key key,
    this.emitTxt,
  }) : super(key: key);

  @override
  State<MixTitleInput> createState() => _MixTitleInputState();
}

class _MixTitleInputState extends State<MixTitleInput> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      child: Container(
        height: 60,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          keyboardAppearance:
              Provider.of<ColorProvider>(context, listen: false).isDark
                  ? Brightness.dark
                  : Brightness.light,
          cursorColor: Provider.of<ColorProvider>(context).isDark
              ? os_dark_dark_white
              : os_deep_blue,
          onChanged: (value) {
            if (widget.emitTxt != null) {
              widget.emitTxt(value);
            }
          },
          style: TextStyle(
            color: Provider.of<ColorProvider>(context).isDark
                ? os_dark_white
                : os_black,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 15),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_light_dark_card
                    : os_grey,
                width: 2,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_dark_white
                    : os_deep_blue,
                width: 2,
              ),
            ),
            hintText: "标题",
            hintStyle: TextStyle(
              color: Provider.of<ColorProvider>(context).isDark
                  ? Color(0x55ffffff)
                  : os_deep_grey,
            ),
          ),
        ),
      ),
    );
  }
}

class ConfirmPost extends StatelessWidget {
  const ConfirmPost({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      padding: EdgeInsets.symmetric(vertical: 2.5, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Provider.of<ColorProvider>(context).isDark
            ? os_dark_white
            : os_deep_blue,
        border: Border.all(
          color: Provider.of<ColorProvider>(context).isDark
              ? os_dark_white
              : os_deep_blue,
          width: 2,
        ),
      ),
      child: Text(
        "发布",
        style: TextStyle(
          color: Provider.of<ColorProvider>(context).isDark
              ? os_dark_back
              : os_white,
        ),
      ),
    );
  }
}

class SelectColumn extends StatefulWidget {
  String txt;
  Function selectColumn;
  int column_id;
  int column_child_id;
  SelectColumn({
    Key key,
    this.txt,
    this.selectColumn,
    this.column_id,
    this.column_child_id,
  }) : super(key: key);

  @override
  State<SelectColumn> createState() => _SelectColumnState();
}

class _SelectColumnState extends State<SelectColumn> {
  showSelect() {
    showPop(context, [
      SelectSectionPopWidget(
        column_id: widget.column_id,
        column_child_id: widget.column_child_id,
        selectColumn: widget.selectColumn,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showSelect();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        padding: EdgeInsets.symmetric(vertical: 2.5, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: Provider.of<ColorProvider>(context).isDark
                ? os_dark_dark_white
                : os_deep_blue,
            width: 2,
          ),
        ),
        child: Text(
          widget.txt == "" ? "选择板块" : widget.txt,
          style: TextStyle(
            color: Provider.of<ColorProvider>(context).isDark
                ? os_dark_dark_white
                : os_deep_blue,
          ),
        ),
      ),
    );
  }
}

class SelectSectionPopWidget extends StatefulWidget {
  Function selectColumn;
  int column_id;
  int column_child_id;

  SelectSectionPopWidget({
    Key key,
    this.column_id,
    this.column_child_id,
    this.selectColumn,
  }) : super(key: key);

  @override
  State<SelectSectionPopWidget> createState() => _SelectSectionPopWidgetState();
}

class _SelectSectionPopWidgetState extends State<SelectSectionPopWidget> {
  int column_id = 0;
  int column_child_id = 0;
  bool loading_1 = false;
  bool loading_2 = false;
  List<Map> columns = []; // { "board_id": 1 , "board_name": "就业创业" }
  List<Map> column_children = []; // { "board_id": 1 , "board_name": "就业创业" }

  bool denyPost = false;
  String column_title = "";

  getColumn() async {
    setState(() {
      loading_1 = true;
      column_id = widget.column_id;
      column_child_id = widget.column_child_id;
    });
    var data = await Api().forum_forumlist({});
    if (column_id != 0) {
      getColumnChild();
    }
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
      columns = tmp;
      setState(() {
        loading_1 = false;
      });
    }
  }

  getColumnChild() async {
    setState(() {
      loading_2 = true;
    });
    var data = await Api().certain_forum_topiclist({
      "page": 1,
      "pageSize": 0,
      "boardId": column_id,
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
      column_children = tmp;
      denyPost = false;
    } else {
      denyPost = true;
    }
    setState(() {
      loading_2 = false;
    });
  }

  Widget _getColumns() {
    List<Widget> t = [];
    columns.forEach((element) {
      t.add(
        GestureDetector(
          onTap: () {
            setState(() {
              column_id = element["board_id"];
              column_title = element["board_name"];
              column_children = [];
              getColumnChild();
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            margin: EdgeInsets.only(right: 5, bottom: 5),
            decoration: BoxDecoration(
              color: column_id == element["board_id"]
                  ? (Provider.of<ColorProvider>(context).isDark
                      ? os_dark_white
                      : os_deep_blue)
                  : (Provider.of<ColorProvider>(context).isDark
                      ? Color(0x11ffffff)
                      : os_grey),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              element["board_name"],
              style: TextStyle(
                color: column_id == element["board_id"]
                    ? (Provider.of<ColorProvider>(context).isDark
                        ? os_dark_back
                        : os_white)
                    : (Provider.of<ColorProvider>(context).isDark
                        ? os_dark_dark_white
                        : Color.fromARGB(255, 74, 77, 87)),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    });
    return Wrap(children: t);
  }

  Widget _getColumnChildren() {
    List<Widget> t = [];
    column_children.forEach((element) {
      t.add(
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            setState(() {
              column_child_id = element["board_id"];
              if (widget.selectColumn != null) {
                // 子板块名字 板块ID 子板块ID
                widget.selectColumn(
                  column_title +
                      (column_title == "" ? "" : "-") +
                      element["board_name"],
                  column_id,
                  column_child_id,
                );
              }
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            margin: EdgeInsets.only(right: 5, bottom: 5),
            decoration: BoxDecoration(
              color: column_child_id == element["board_id"]
                  ? (Provider.of<ColorProvider>(context).isDark
                      ? os_dark_white
                      : Color(0xFFEA8324))
                  : (Provider.of<ColorProvider>(context).isDark
                      ? Color(0x11ffffff)
                      : os_grey),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              element["board_name"],
              style: TextStyle(
                color: column_child_id == element["board_id"]
                    ? (Provider.of<ColorProvider>(context).isDark
                        ? os_dark_back
                        : os_white)
                    : (Provider.of<ColorProvider>(context).isDark
                        ? os_dark_dark_white
                        : Color.fromARGB(255, 74, 77, 87)),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    });
    return Wrap(children: t);
  }

  @override
  void initState() {
    getColumn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 120,
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Container(height: 5),
          Container(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Container(
                    decoration: BoxDecoration(
                      color: Provider.of<ColorProvider>(context).isDark
                          ? Color(0x22ffffff)
                          : os_grey,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Center(
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Provider.of<ColorProvider>(context).isDark
                            ? os_dark_dark_white
                            : os_black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          title(1, "选择板块", loading_1),
          Container(height: 10),
          _getColumns(),
          Container(height: 20),
          column_id == 0 || denyPost
              ? Container()
              : title(2, "选择子板块", loading_2),
          denyPost ? title(2, "您不可在此发帖", loading_2) : Container(),
          Container(height: 10),
          column_id == 0 || denyPost ? Container() : _getColumnChildren(),
        ],
      ),
    );
  }

  Widget title(int index, String txt, bool loading) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Provider.of<ColorProvider>(context).isDark
                ? os_dark_white
                : [os_deep_blue, Color(0xFFEA8324)][index - 1],
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: Text(
              "$index",
              style: TextStyle(
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_back
                    : os_white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Container(width: 10),
        Text(
          "$txt",
          style: TextStyle(
            fontSize: 16,
            color: Provider.of<ColorProvider>(context).isDark
                ? os_dark_white
                : os_black,
          ),
        ),
        Container(width: 10),
        loading
            ? Container(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_dark_dark_white
                      : [os_deep_blue, Color(0xFFEA8324)][index - 1],
                ),
              )
            : Container(),
      ],
    );
  }
}
