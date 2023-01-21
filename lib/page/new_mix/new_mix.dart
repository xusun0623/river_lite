import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/home_desktop_mode.dart';
import 'package:offer_show/components/newNaviBar.dart';
import 'package:offer_show/page/topic/Your_emoji.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

final GlobalKey<MixContSectionState> mixContSectionKey = GlobalKey();

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
  bool choosingEmoji = false;
  int state = 0; // 0-不显示 1-显示Icon 2-显示Emoji
  ScrollController _controller = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Baaaar(
      color:
          Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_white,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Provider.of<ColorProvider>(context).isDark
              ? os_dark_back
              : os_white,
          elevation: 0,
          actions: [
            GestureDetector(child: SelectColumn()),
            GestureDetector(child: ConfirmPost()),
            Container(width: 5),
          ],
          leading: IconButton(
            icon: Icon(Icons.chevron_left_rounded,
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_dark_white
                    : Color(0xFF2E2E2E)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          color: Provider.of<ColorProvider>(context).isDark
              ? os_dark_back
              : os_white,
          child: Stack(
            children: [
              ListView(
                controller: _controller,
                children: [
                  MixTitleInput(),
                  MixContSection(
                    key: mixContSectionKey,
                    focus: () async {
                      setState(() {
                        state = 1;
                      });
                      print("134567876543");
                      await Future.delayed(Duration(milliseconds: 1000));
                      _controller.animateTo(
                        _controller.offset + 100,
                        duration: Duration(milliseconds: 100),
                        curve: Curves.ease,
                      );
                    },
                  ),
                  Container(
                    height: state == 1
                        ? 100
                        : state == 2
                            ? 360
                            : 100,
                  ),
                ],
              ),
              state == 1
                  ? Positioned(
                      child: Container(
                        color: os_white,
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: os_grey,
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
                                      onPressed: () {
                                        FocusManager.instance.primaryFocus
                                            .unfocus();
                                        setState(() {
                                          choosingEmoji = true;
                                          state = 2;
                                        });
                                      },
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
                                        FocusManager.instance.primaryFocus
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
                        color: os_white,
                        height: 360,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: os_grey,
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
                                      onPressed: () {
                                        FocusManager.instance.primaryFocus
                                            .unfocus();
                                        setState(() {
                                          choosingEmoji = true;
                                          state = 2;
                                        });
                                      },
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
                                        FocusManager.instance.primaryFocus
                                            .unfocus(); //去除焦点
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(child: YourEmoji(
                              tap: (res) {
                                mixContSectionKey.currentState.insertEmoji(res);
                                print("$res");
                              },
                            )),
                          ],
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
  MixContSection({
    Key key,
    this.focus,
  }) : super(key: key);

  @override
  State<MixContSection> createState() => MixContSectionState();
}

class MixContSectionState extends State<MixContSection> {
  int hasFocusIndex = -1;
  int lastEditIndex = 0;
  int lastEditPos = 0;

  List<BodyCont> body_cont = [
    BodyCont(BodyContType.txt, ""),
  ];
  List<FocusNode> _focusNode = [];
  List<TextEditingController> _textEditingController = [];

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
        ));
      }
      if (_body_cont_single.type == BodyContType.image) {
        _body_cont_tmp.add(MixPic(
          path: _body_cont_single.cont,
          delete: () {
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
          },
        ));
      }
    }
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

  addPic() async {
    unFocus();
    ImagePicker _picker = ImagePicker();
    List<XFile> _imgs = await _picker.pickMultiImage();
    for (var i = 0; i < _imgs.length; i++) {
      final XFile element = _imgs[i];
      body_cont.add(BodyCont(BodyContType.image, element.path));
      body_cont.add(BodyCont(BodyContType.txt, ""));
    }
    rebuildControlList();
    setState(() {});
  }

  listenController() {
    for (var i = 0; i < _textEditingController.length; i++) {
      _textEditingController[i].addListener(() {
        if (body_cont[i].type == BodyContType.txt) {
          body_cont[i].cont = _textEditingController[i].text;
          print("${_textEditingController[i].text}");
        }
        setState(() {
          lastEditPos = _textEditingController[i].selection.base.offset;
        });
      });
    }
    for (var i = 0; i < _focusNode.length; i++) {
      _focusNode[i].addListener(() {
        if (_focusNode[i].hasFocus) {
          if (widget.focus != null) widget.focus();
          setState(() {
            lastEditIndex = i;
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
    return Column(
      children: [
        ..._buildCont(),
        Container(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              IconButton(
                onPressed: addPic,
                icon: Icon(Icons.add),
              )
            ],
          ),
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
          Image.file(File(widget.path)),
          Positioned(
            right: 10,
            top: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0x44000000),
                borderRadius: BorderRadius.circular(100),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Color(0xccffffff),
                ),
                onPressed: () {
                  if (widget.delete != null) {
                    widget.delete();
                  }
                },
              ),
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
          controller: widget.controller,
          focusNode: widget.focusNode,
          cursorColor: os_deep_blue,
          maxLines: null,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 15),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide.none,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide.none,
            ),
            hintText: widget.placeholder ?? "点击输入内容",
          ),
        ),
      ),
    );
  }
}

class MixTitleInput extends StatelessWidget {
  const MixTitleInput({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      child: Container(
        height: 60,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          cursorColor: os_deep_blue,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 15),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: os_grey,
                width: 2,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: os_deep_blue,
                width: 2,
              ),
            ),
            hintText: "标题",
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
        color: os_deep_blue,
        border: Border.all(
          color: os_deep_blue,
          width: 2,
        ),
      ),
      child: Text(
        "发布",
        style: TextStyle(
          color: os_white,
        ),
      ),
    );
  }
}

class SelectColumn extends StatelessWidget {
  const SelectColumn({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      padding: EdgeInsets.symmetric(vertical: 2.5, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: os_deep_blue,
          width: 2,
        ),
      ),
      child: Text(
        "选择板块",
        style: TextStyle(
          color: os_deep_blue,
        ),
      ),
    );
  }
}
