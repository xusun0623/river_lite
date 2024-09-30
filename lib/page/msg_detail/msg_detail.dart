import 'dart:async';
import 'dart:io';

import 'package:badges/badges.dart' as Badgee;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offer_show/asset/bigScreen.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/mouse_speed.dart';
import 'package:offer_show/asset/phone_pick_images.dart';
import 'package:offer_show/asset/refreshIndicator.dart';
import 'package:offer_show/asset/saveImg.dart';
import 'package:offer_show/asset/showActionSheet.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/asset/time.dart';
import 'package:offer_show/asset/to_user.dart';
import 'package:offer_show/asset/uploadAttachment.dart';
import 'package:offer_show/asset/vibrate.dart';
import 'package:offer_show/asset/xs_textstyle.dart';
import 'package:offer_show/components/loading.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/page/photo_view/photo_view.dart';
import 'package:offer_show/page/topic/Your_emoji.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

Color theme = Color(0xFF4577f6);

class MsgDetail extends StatefulWidget {
  Map? usrInfo;
  MsgDetail({
    Key? key,
    this.usrInfo,
  }) : super(key: key);

  @override
  MsgDetailState createState() => MsgDetailState();
}

class MsgDetailState extends State<MsgDetail> {
  Map? userInfo = {};
  List? pmList = [];

  bool vibrate = false;
  bool i_am_selectimg_img = false;
  bool load_done = false;

  ScrollController _controller = new ScrollController();
  TextEditingController _textEditingController = new TextEditingController();

  int space = 50;

  _getCont() async {
    var data = await Api().message_pmlist({
      "pmlist": {
        "body": {
          "externInfo": {"onlyFromUid": 0},
          "pmInfos": [
            {
              "startTime": 0,
              "cacheCount": space,
              "stopTime": 0,
              "fromUid": widget.usrInfo!["uid"],
              "pmLimit": isDesktop() ? 1000000 : space
            }
          ]
        }
      }.toString()
    });
    load_done = true;
    if (data != null &&
        data["body"] != null &&
        data["body"]["userInfo"] != null &&
        data["body"]["pmList"] != null) {
      setState(() {
        userInfo = data["body"]["userInfo"];
        pmList = data["body"]["pmList"];
      });
    } else {
      userInfo = {};
      pmList = [];
      setState(() {});
    }
  }

  _getMore() async {
    List msgList = pmList![0]["msgList"];
    if (msgList.length % space != 0) return;
    var data = await Api().message_pmlist({
      "pmlist": {
        "body": {
          "externInfo": {"onlyFromUid": 0},
          "pmInfos": [
            {
              "startTime": 0,
              "cacheCount": space,
              "stopTime": msgList[0]["time"],
              "fromUid": widget.usrInfo!["uid"],
              "pmLimit": space
            }
          ]
        }
      }.toString()
    });
    if (data != null &&
        data["body"] != null &&
        data["body"]["userInfo"] != null &&
        data["body"]["pmList"] != null) {
      data["body"]["pmList"][0]["msgList"].addAll(pmList![0]["msgList"]);
      setState(() {
        pmList![0]["msgList"] = data["body"]["pmList"][0]["msgList"];
      });
    }
  }

  List<Widget> _buildCont() {
    List<Widget> tmp = [];
    tmp.add(Container(height: 130 + (i_am_selectimg_img ? 300.0 : 0.0)));
    if (pmList!.length != 0) {
      List msgList = pmList![0]["msgList"];
      msgList = msgList.reversed.toList();
      msgList.forEach((element) {
        tmp.add(MsgCont(
          fromInfo: {
            "fromUid": pmList![0]["fromUid"],
            "name": pmList![0]["name"],
            "avatar": pmList![0]["avatar"],
          },
          myInfo: {
            "fromUid": userInfo!["uid"],
            "name": userInfo!["name"],
            "avatar": userInfo!["avatar"],
          },
          msg: element,
        ));
      });
    }
    print("${pmList}");
    if (tmp.length % space == 1 &&
        pmList != null &&
        pmList!.length != 0 &&
        pmList![0] != null &&
        pmList![0]["msgList"] != null &&
        pmList![0]["msgList"].length != 0 &&
        tmp.length != 101) {
      tmp.add(Center(
        child: Container(
          width: 160,
          height: 36,
          margin: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                vibrate
                    ? Container()
                    : Icon(
                        Icons.arrow_downward_rounded,
                        color: theme,
                        size: 32,
                      ),
              ],
            ),
          ),
        ),
      ));
    }
    if (tmp.length > 52 && !isDesktop()) {
      tmp.add(Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: os_wonderful_color_opa[0],
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: [
            Icon(Icons.info, color: os_wonderful_color[0]),
            Container(width: 10),
            Container(
              width: MediaQuery.of(context).size.width - 96,
              child: Text(
                "客户端仅能显示最近100条信息，如有更多请前往网页版查看",
                style: XSTextStyle(
                  context: context,
                  color: os_wonderful_color[0],
                ),
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
    _getCont();

    _controller.addListener(() {
      if (_controller.position.pixels - _controller.position.maxScrollExtent >
          100) {
        if (!vibrate) {
          vibrate = true; //不允许再震动
          XSVibrate().impact();
        }
      }
      if (_controller.position.pixels - _controller.position.maxScrollExtent <=
          0) {
        vibrate = false; //允许震动
      }
      setState(() {});
    });
    speedUp(_controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: os_white,
      appBar: AppBar(
        systemOverlayStyle: Provider.of<ColorProvider>(context).isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        backgroundColor: Provider.of<ColorProvider>(context).isDark
            ? os_dark_back
            : os_white,
        foregroundColor: Provider.of<ColorProvider>(context).isDark
            ? os_dark_white
            : os_black,
        elevation: 0,
        toolbarHeight: 56,
        leading: BackButton(),
        centerTitle: true,
        actions: [
          LookRoom(uid: widget.usrInfo!["uid"]),
          Container(width: 15),
        ],
        title: DetailHead(
          uid: widget.usrInfo!["uid"],
          name: widget.usrInfo!["name"],
        ),
      ),
      body: Container(
        color: Provider.of<ColorProvider>(context).isDark
            ? os_dark_back
            : os_white,
        child: DismissiblePage(
          backgroundColor: Provider.of<ColorProvider>(context).isDark
              ? os_dark_back
              : os_white,
          direction: DismissiblePageDismissDirection.startToEnd,
          onDismissed: () {
            Navigator.of(context).pop();
          },
          child: Stack(
            children: [
              pmList!.length == 0 && !load_done
                  ? Loading()
                  : Container(
                      color: Provider.of<ColorProvider>(context).isDark
                          ? os_dark_back
                          : os_white,
                      height: MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top,
                      child: getMyRrefreshIndicator(
                        context: context,
                        color: theme,
                        onRefresh: () async {
                          await _getMore();
                          return;
                        },
                        child: ListView(
                          //physics: BouncingScrollPhysics(),
                          controller: _controller,
                          shrinkWrap: true,
                          reverse: true,
                          children: _buildCont(),
                        ),
                      ),
                    ),
              BottomFuncBar(
                i_am_selectimg_img: (flag) {
                  setState(() {
                    i_am_selectimg_img = flag;
                  });
                },
                pagecontroller: _controller,
                uid: widget.usrInfo!["uid"],
                sended: () {
                  _getCont();
                  _controller.animateTo(
                    0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                },
                textEditingController: _textEditingController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomFuncBar extends StatefulWidget {
  TextEditingController? textEditingController;
  Function? sended;
  Function? i_am_selectimg_img;
  ScrollController? pagecontroller;
  int? uid;
  BottomFuncBar({
    Key? key,
    this.textEditingController,
    this.sended,
    this.uid,
    this.pagecontroller,
    this.i_am_selectimg_img,
  }) : super(key: key);

  @override
  State<BottomFuncBar> createState() => _BottomFuncBarState();
}

class _BottomFuncBarState extends State<BottomFuncBar> {
  FocusNode _focusNode = new FocusNode();
  bool sending = false;
  bool uploadingImgs = false;
  List img_urls = [];

  bool dont_send_flag = false;
  int dont_send_clock = 10;

  bool selecting_emoji = false;

  var time;

  @override
  void initState() {
    _focusNode.addListener(() {
      setState(() {
        if (_focusNode.hasFocus) {
          setState(() {
            selecting_emoji = false;
            widget.i_am_selectimg_img!(selecting_emoji);
          });
          widget.pagecontroller!.animateTo(
            widget.pagecontroller!.position.minScrollExtent,
            duration: Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        }
      });
    });
    super.initState();
  }

  _sendImg() async {
    setState(() {
      sending = true;
    });
    await Api().message_pmadmin({
      "json":
          '{"action": "send","msg": {"type": "image","content": "${img_urls[0]["urlName"]}"},"toUid": ${widget.uid}}'
    });
    // showToast(
    //   context: context,
    //   type: XSToast.success,
    //   txt: "发送成功！",
    // );
    setState(() {
      dont_send_flag = true;
      dont_send_clock = 10;
      sending = false;
      img_urls = [];
      _focusNode.unfocus();
    });
    //可能需要延时一下再请求
    await Future.delayed(Duration(milliseconds: 750));
    widget.sended!();
    dont_send_clock = 10;
    time = Timer.periodic(Duration(milliseconds: 1000), (t) {
      setState(() {
        dont_send_clock--;
      });
    });
    await Future.delayed(Duration(milliseconds: 10000));
    time.cancel();
    dont_send_flag = false;
    setState(() {});
  }

  _send() async {
    if (widget.textEditingController!.text == "") {
      _focusNode.unfocus();
      setState(() {});
      return;
    }
    setState(() {
      sending = true;
      _focusNode.requestFocus();
    });
    await Api().message_pmadmin({
      "json":
          '{"action": "send","msg": {"type": "text","content": "${widget.textEditingController!.text}"},"toUid": ${widget.uid}}'
    });
    // showToast(
    //   context: context,
    //   type: XSToast.success,
    //   txt: "发送成功！",
    // );
    setState(() {
      dont_send_flag = true;
      dont_send_clock = 12;
      widget.textEditingController!.text = "";
      sending = false;
      _focusNode.unfocus();
    });
    //可能需要延时一下再请求
    await Future.delayed(Duration(milliseconds: 750));
    dont_send_clock = 12;
    widget.sended!();
    time = Timer.periodic(Duration(milliseconds: 1000), (t) {
      setState(() {
        dont_send_clock--;
      });
    });
    await Future.delayed(Duration(milliseconds: 12000));
    time.cancel();
    dont_send_flag = false;
    setState(() {});
  }

  @override
  void dispose() {
    if (time != null) {
      time.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        color: Provider.of<ColorProvider>(context).isDark
            ? os_dark_back
            : os_white,
        padding: EdgeInsets.only(
          bottom: (Platform.isAndroid
                  ? MediaQuery.of(context).padding.bottom
                  : 20.0) +
              10.0,
          top: 10.0,
        ),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: os_edge),
          decoration: BoxDecoration(
            color: _focusNode.hasFocus
                ? (Provider.of<ColorProvider>(context).isDark
                    ? os_light_dark_card
                    : os_white)
                : (Provider.of<ColorProvider>(context).isDark
                    ? os_light_dark_card
                    : Color(0xFFEEEEEE)),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(
              color: _focusNode.hasFocus
                  ? (Provider.of<ColorProvider>(context).isDark
                      ? os_light_dark_card
                      : os_deep_blue)
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width - 2 * os_edge,
            height: 60 + (selecting_emoji ? 300.0 : 0.0),
            child: uploadingImgs
                ? Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: os_deep_blue,
                            strokeWidth: 3,
                          ),
                        ),
                        Container(width: 10),
                        Text(
                          "上传图片中…",
                          style: XSTextStyle(
                            context: context,
                            color: Provider.of<ColorProvider>(context).isDark
                                ? os_dark_dark_white
                                : os_black,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        )
                      ],
                    ),
                  )
                : Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(children: [
                          img_urls.length != 0
                              ? Container()
                              : Container(
                                  width:
                                      MediaQuery.of(context).size.width - 120,
                                  // height: 53,
                                  child: TextField(
                                    keyboardAppearance:
                                        Provider.of<ColorProvider>(context,
                                                    listen: false)
                                                .isDark
                                            ? Brightness.dark
                                            : Brightness.light,
                                    enabled: !dont_send_flag,
                                    controller: widget.textEditingController,
                                    focusNode: _focusNode,
                                    cursorColor: os_deep_blue,
                                    onSubmitted: (e) {
                                      _send();
                                    },
                                    style: XSTextStyle(
                                      context: context,
                                      fontSize: 15,
                                      color: Provider.of<ColorProvider>(context)
                                              .isDark
                                          ? os_dark_white
                                          : os_black,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 15),
                                      border: InputBorder.none,
                                      hintStyle: XSTextStyle(
                                        context: context,
                                        height: 1.8,
                                        color:
                                            Provider.of<ColorProvider>(context)
                                                    .isDark
                                                ? os_dark_dark_white
                                                : Color(0xFFA3A3A3),
                                      ),
                                      hintText: dont_send_flag
                                          ? "由于河畔后台限制，请稍等 ${dont_send_clock} 秒…"
                                          : (isMacOS()
                                              ? "说点什么吧…（按住control键+空格键以切换中英文输入法）"
                                              : "说点什么吧…"),
                                    ),
                                  ),
                                ),
                          img_urls.length != 0
                              ? Container(
                                  width: 10,
                                )
                              : myInkWell(
                                  tap: () {
                                    if (dont_send_flag) return;
                                    setState(() {
                                      selecting_emoji = !selecting_emoji;
                                    });
                                    widget.i_am_selectimg_img!(selecting_emoji);
                                    if (selecting_emoji) {
                                      _focusNode.unfocus();
                                    }
                                  },
                                  color: Colors.transparent,
                                  widget: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Provider.of<ColorProvider>(context)
                                            .isDark
                                        ? Icon(
                                            Icons.emoji_emotions,
                                            size: 30,
                                            color: Color(0xFF004DFF),
                                          )
                                        : os_svg(
                                            path: "lib/img/topic_emoji.svg",
                                            width: 25,
                                            height: 25,
                                          ),
                                  ),
                                  radius: 100,
                                ),
                          _focusNode.hasFocus || selecting_emoji
                              ? (sending
                                  ? Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: os_deep_blue,
                                          strokeWidth: 3,
                                        ),
                                      ),
                                    )
                                  : myInkWell(
                                      tap: () {
                                        _focusNode.unfocus();
                                        _send();
                                      },
                                      color: Colors.transparent,
                                      widget: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: os_svg(
                                          path: "lib/img/msg_send.svg",
                                          width: 25,
                                          height: 25,
                                        ),
                                      ),
                                      radius: 100,
                                    ))
                              : myInkWell(
                                  tap: () async {
                                    try {
                                      _focusNode.unfocus();
                                      XFile? image;
                                      setState(() {
                                        selecting_emoji = false;
                                        widget.i_am_selectimg_img!(
                                            selecting_emoji);
                                      });
                                      if (dont_send_flag) return;
                                      if (isMacOS()) {
                                        setState(() {
                                          uploadingImgs = true;
                                        });
                                        image =
                                            await pickeSingleImgFile(context);
                                      } else {
                                        setState(() {
                                          uploadingImgs = true;
                                        });
                                        print("选择小屏图片");
                                        image =
                                            await getSinglePhoneImage(context);
                                      }
                                      if (image != null) {
                                        img_urls = await Api().uploadImage(
                                          imgs: [image],
                                        );
                                      }
                                      setState(() {
                                        uploadingImgs = false;
                                      });
                                      print("${img_urls}");
                                    } catch (e) {
                                      print(e);
                                      setState(() {
                                        uploadingImgs = false;
                                      });
                                    }
                                  },
                                  color: Colors.transparent,
                                  widget: Badgee.Badge(
                                    showBadge: img_urls.length != 0,
                                    badgeContent: Text(
                                      img_urls.length.toString(),
                                      style: XSTextStyle(
                                        context: context,
                                        color: os_white,
                                        fontSize: 10,
                                      ),
                                    ),
                                    // badgeColor: os_deep_blue,
                                    badgeStyle: Badgee.BadgeStyle(
                                      badgeColor: os_deep_blue,
                                    ),
                                    position: Badgee.BadgePosition.topEnd(
                                        top: 0, end: 0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: os_svg(
                                        path: "lib/img/topic_picture.svg",
                                        width: 25,
                                        height: 25,
                                      ),
                                    ),
                                  ),
                                  radius: 100,
                                ),
                          img_urls.length != 0
                              ? Container(width: 12.5)
                              : Container(),
                          img_urls.length != 0
                              ? myInkWell(
                                  tap: () {
                                    _sendImg();
                                  },
                                  color: os_deep_blue,
                                  widget: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 200,
                                    height: 45,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          sending
                                              ? Container(
                                                  width: 15,
                                                  height: 15,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: os_white,
                                                    strokeWidth: 2,
                                                  ),
                                                )
                                              : Icon(Icons.upload,
                                                  color: os_white, size: 18),
                                          Container(width: 5),
                                          Text(
                                            "发送这张 图片",
                                            style: XSTextStyle(
                                                context: context,
                                                color: os_white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  radius: 15,
                                )
                              : Container(),
                          img_urls.length != 0
                              ? Container(width: 7.5)
                              : Container(),
                          img_urls.length != 0
                              ? myInkWell(
                                  color:
                                      Provider.of<ColorProvider>(context).isDark
                                          ? os_dark_back
                                          : os_white,
                                  tap: () {
                                    img_urls = [];
                                    setState(() {});
                                  },
                                  widget: Container(
                                    width: 97.5,
                                    height: 45,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "取消发送",
                                            style: XSTextStyle(
                                                context: context,
                                                color: os_deep_grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  radius: 15,
                                )
                              : Container(),
                        ]),
                        !selecting_emoji
                            ? Container()
                            : Container(
                                height: 300,
                                child: YourEmoji(
                                  size: 35,
                                  tap: (e) {
                                    widget.textEditingController!.text =
                                        widget.textEditingController!.text + e;
                                    setState(() {});
                                  },
                                ),
                              ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class MsgCont extends StatefulWidget {
  Map? fromInfo;
  Map? myInfo;
  Map? msg;
  MsgCont({
    Key? key,
    this.fromInfo,
    this.myInfo,
    this.msg,
  }) : super(key: key);

  @override
  State<MsgCont> createState() => _MsgContState();
}

class _MsgContState extends State<MsgCont> {
  @override
  Widget build(BuildContext context) {
    return widget.fromInfo!["fromUid"] == widget.msg!["sender"]
        ? MsgContBodyWidget(
            index: 0,
            isImage: widget.msg!["type"] == "image",
            cont: widget.msg!["content"],
            avatar: widget.fromInfo!["avatar"],
            time: int.parse(widget.msg!["time"]),
          )
        : MsgContBodyWidget(
            index: 1,
            isImage: widget.msg!["type"] == "image",
            cont: widget.msg!["content"],
            avatar: widget.myInfo!["avatar"],
            time: int.parse(widget.msg!["time"]),
          );
  }
}

class MsgContBodyWidget extends StatefulWidget {
  int? index;
  String? cont;
  String? avatar;
  int? time;
  int? mid;
  bool? isImage;
  MsgContBodyWidget({
    Key? key,
    this.index, //0-他 1-我
    this.cont,
    this.avatar,
    this.time,
    this.mid,
    this.isImage,
  }) : super(key: key);

  @override
  State<MsgContBodyWidget> createState() => _MsgContBodyWidgetState();
}

class _MsgContBodyWidgetState extends State<MsgContBodyWidget> {
  List<InlineSpan> _getRichText(String t) {
    List<InlineSpan> ret = [];
    t = t.replaceAll("&nbsp;", " ");
    List<String> tmp = t.split("[mobcent_phiz=");
    ret.add(TextSpan(text: tmp[0]));
    for (var i = 1; i < tmp.length; i++) {
      var first_idx = tmp[i].indexOf(']');
      ret.add(WidgetSpan(
        child: Container(
          decoration: BoxDecoration(
            color: Provider.of<ColorProvider>(context).isDark
                ? os_light_dark_card
                : os_white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          child: SizedBox(
            width: 30,
            height: 30,
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
      ret.add(
        TextSpan(
          text: tmp[i].substring(first_idx + 1),
        ),
      );
    }
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    Widget txt = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        myInkWell(
            longPress: () {
              if (widget.isImage!) {
                saveImge(context, [widget.cont], 0);
              } else {
                XSVibrate().impact();
                showAction(
                  context: context,
                  options: ["复制文本"],
                  icons: [Icons.copy],
                  tap: (res) {
                    if (res == "复制文本") {
                      Clipboard.setData(ClipboardData(text: widget.cont!));
                      Navigator.pop(context);
                      showToast(
                        context: context,
                        type: XSToast.success,
                        txt: widget.isImage! ? "复制链接成功" : "复制文本成功",
                      );
                    }
                  },
                );
              }
            },
            color: widget.index == 0
                ? (Provider.of<ColorProvider>(context).isDark
                    ? Color(0x22FFFFFF)
                    : Color(0xFFEEEEEE))
                : (Provider.of<ColorProvider>(context).isDark
                    ? Color(0xFF0C4AE7)
                    : theme),
            splashColor:
                widget.index == 0 ? Color(0x44707070) : Color(0x44002873),
            highlightColor:
                widget.index == 0 ? Color(0x88C8C8C8) : Color(0x88135CE2),
            radius: 10,
            widget: widget.isImage ?? false
                ? Stack(
                    children: [
                      Container(
                        width: 125,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PhotoPreview(
                                  galleryItems: [widget.cont],
                                  defaultImage: 0,
                                ),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Hero(
                              tag: widget.cont!,
                              child: CachedNetworkImage(
                                filterQuality: FilterQuality.low,
                                width: 125,
                                height: 180,
                                fit: BoxFit.cover,
                                placeholderFadeInDuration:
                                    Duration(milliseconds: 500),
                                // memCacheHeight: 540,
                                memCacheWidth: 375,
                                placeholder: (context, url) => Container(
                                  width: 125,
                                  height: 180,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 50,
                                    vertical: 77.5,
                                  ),
                                  child: CircularProgressIndicator(
                                    color: widget.index == 0
                                        ? os_deep_grey
                                        : os_white,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: widget.index == 0
                                        ? os_grey
                                        : os_deep_blue,
                                  ),
                                ),
                                imageUrl: widget.cont!,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(0, 0, 0, 0.20),
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                          ),
                          child: Text(
                            RelativeDateFormat.format(
                              DateTime.fromMillisecondsSinceEpoch(widget.time!),
                            ),
                            style: XSTextStyle(
                              context: context,
                              color: Color.fromRGBO(255, 255, 255, 0.9),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width - 130,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 3),
                            child: Text.rich(
                              TextSpan(
                                style: XSTextStyle(
                                  context: context,
                                  fontSize: 16,
                                  height: 1.6,
                                  color: widget.index == 0
                                      ? (Provider.of<ColorProvider>(context)
                                              .isDark
                                          ? os_dark_white
                                          : os_black)
                                      : (os_white),
                                ),
                                children: _getRichText(widget.cont!),
                              ),
                            ),
                          ),
                          Text(
                            RelativeDateFormat.format(
                              DateTime.fromMillisecondsSinceEpoch(widget.time!),
                            ),
                            style: XSTextStyle(
                              context: context,
                              color: widget.index == 0
                                  ? (Provider.of<ColorProvider>(context).isDark
                                      ? os_dark_dark_white
                                      : Color.fromRGBO(0, 0, 0, 0.3))
                                  : (Provider.of<ColorProvider>(context).isDark
                                      ? os_dark_white
                                      : Color.fromRGBO(255, 255, 255, 0.6)),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
      ],
    );
    Widget avatar = ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(100)),
      child: CachedNetworkImage(
        placeholder: (context, url) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: os_grey,
          ),
        ),
        imageUrl: widget.avatar!,
        width: 36,
        height: 36,
      ),
    );
    Widget space = Container(width: 10);
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: widget.index == 0
              ? MainAxisAlignment.start
              : MainAxisAlignment.end,
          children:
              widget.index == 0 ? [avatar, space, txt] : [txt, space, avatar],
        ));
  }
}

class LookRoom extends StatefulWidget {
  int? uid;
  LookRoom({Key? key, this.uid}) : super(key: key);

  @override
  State<LookRoom> createState() => _LookRoomState();
}

class _LookRoomState extends State<LookRoom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: myInkWell(
        tap: () {
          toUserSpace(context, widget.uid);
        },
        color: Provider.of<ColorProvider>(context).isDark
            ? os_light_dark_card
            : Color(0xFFEEEEEE),
        widget: Container(
          padding: EdgeInsets.symmetric(horizontal: 7.5),
          child: Center(
            child: Icon(Icons.person_outline),
          ),
        ),
        radius: 100,
      ),
    );
  }
}

class DetailHead extends StatefulWidget {
  int? uid;
  String? name;
  DetailHead({
    Key? key,
    this.uid,
    this.name,
  }) : super(key: key);

  @override
  State<DetailHead> createState() => _DetailHeadState();
}

class _DetailHeadState extends State<DetailHead> {
  Map data = {};
  _getStatus() async {
    var tmp = await Api().user_userinfo({
      "userId": widget.uid,
    });
    setState(() {
      data = tmp;
    });
  }

  @override
  void initState() {
    _getStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.name!,
          textAlign: TextAlign.center,
          style: XSTextStyle(
            context: context,
            fontSize: 18,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 7.5,
              height: 7.5,
              decoration: BoxDecoration(
                color: data["rs"] == null
                    ? Color.fromARGB(255, 186, 186, 186)
                    : (data["status"] == 0
                        ? Color.fromARGB(255, 186, 186, 186)
                        : Color(0xFF1AE316)),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            Container(width: 5),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 130,
              ),
              child: Text(
                data["rs"] == null
                    ? "该用户当前网页不在线"
                    : (data["status"] == 0 ? "该用户当前网页不在线" : "该用户当前在线"),
                overflow: TextOverflow.ellipsis,
                style: XSTextStyle(
                  context: context,
                  fontSize: 12,
                  color: Color(0xFFADADAD),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BackButton extends StatelessWidget {
  const BackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(Icons.chevron_left_rounded,
          color: Provider.of<ColorProvider>(context).isDark
              ? os_dark_white
              : os_black),
    );
  }
}
