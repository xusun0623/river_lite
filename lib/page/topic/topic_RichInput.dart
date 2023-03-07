import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:offer_show/asset/bigScreen.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/gallery_permission.dart';
import 'package:offer_show/asset/home_desktop_mode.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/phone_pick_images.dart';
import 'package:offer_show/asset/showActionSheet.dart';
import 'package:offer_show/asset/uploadAttachment.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/page/topic/At_someone.dart';
import 'package:offer_show/page/topic/Your_emoji.dart';
import 'package:offer_show/page/topic/topic_sendFunc.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
import 'package:provider/provider.dart';

class RichInput extends StatefulWidget {
  double bottom;
  TextEditingController controller;
  FocusNode focusNode;
  int tid;
  int fid;
  Function cancel;
  Function send;
  Function uploadImg;
  Function uploadFile;
  String placeholder;
  Function atUser;
  bool sending;
  bool anonymous;
  RichInput({
    Key key,
    this.bottom,
    @required this.tid,
    @required this.fid,
    @required this.controller,
    @required this.focusNode,
    @required this.cancel,
    @required this.send,
    @required this.uploadImg,
    @required this.atUser,
    @required this.placeholder,
    @required this.uploadFile,
    @required this.sending,
    @required this.anonymous,
  }) : super(key: key);

  @override
  _RichInputState createState() => _RichInputState();
}

class _RichInputState extends State<RichInput> with TickerProviderStateMixin {
  List<XFile> image = [];
  List<PlatformFile> files = [];
  String uploadFile = "";
  bool popSection = false;
  bool isAnonymous = false; //是否勾选匿名
  int popSectionIndex = 0; //0-表情包 1-艾特某人
  int inserting_num = 0; //插入的位置

  double uploadProgress = 0; //上传进度

  AnimationController controller; //动画控制器
  Animation<double> animation;
  double popHeight = 0;

  _foldPop() async {
    controller.reverse();
    setState(() {
      popSection = false;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      inserting_num = widget.controller.selection.base.offset;
    });
    widget.focusNode.addListener(() {
      if (widget.focusNode.hasFocus) {
        _foldPop();
      }
    });
    controller = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    animation = Tween(begin: 0.0, end: 300.0).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ))
      ..addListener(() {
        setState(() {
          popHeight = animation.value;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    List<Map> at_user = [];
    bool upLoading = false;
    return Positioned(
      bottom: widget.bottom ?? 0,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding:
                  EdgeInsets.symmetric(horizontal: MinusSpace(context) / 2),
              height: popSection ? 200 : 250,
              decoration: BoxDecoration(
                color: Provider.of<ColorProvider>(context).isDark
                    ? Color(0xFF222222)
                    : os_white,
                border: Border(
                    top: BorderSide(
                        width: 1,
                        color: Provider.of<ColorProvider>(context).isDark
                            ? Color(0x11ffffff)
                            : os_grey)),
                boxShadow: [
                  // BoxShadow(
                  //   color: Color.fromRGBO(0, 0, 0, 0.1),
                  //   blurRadius: 7,
                  //   offset: Offset(1, -2),
                  // )
                ],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            SendFunc(
                              path: Provider.of<ColorProvider>(context).isDark
                                  ? "lib/img/topic_dark_func/topic_emoji.svg"
                                  : "lib/img/topic_emoji.svg",
                              tap: () {
                                widget.focusNode.unfocus();
                                popSectionIndex = 0;
                                popSection = true;
                                controller.forward();
                                setState(() {});
                              },
                            ),
                            SendFunc(
                              path: Provider.of<ColorProvider>(context).isDark
                                  ? "lib/img/topic_dark_func/topic_@.svg"
                                  : "lib/img/topic_@.svg",
                              tap: () async {
                                widget.focusNode.unfocus();
                                popSectionIndex = 1;
                                popSection = true;
                                controller.forward();
                                setState(() {});
                              },
                            ),
                            SendFunc(
                              nums: image.length == 0 ? null : image.length,
                              loading: upLoading,
                              path: Provider.of<ColorProvider>(context).isDark
                                  ? "lib/img/topic_dark_func/topic_picture.svg"
                                  : "lib/img/topic_picture.svg",
                              tap: () async {
                                setState(() {
                                  widget.focusNode.unfocus();
                                  upLoading = true;
                                });
                                if (isMacOS()) {
                                  ///单独对MacOS进行处理
                                  image = await pickeImgFile(context);
                                } else {
                                  print("选择小屏图片");
                                  List res = await getPhoneImages(context);
                                  // List<Media> res = await ImagesPicker.pick(
                                  //   count: 50,
                                  //   // cropOpt: CropOption(),
                                  //   pickType: PickType.image,
                                  //   quality: 0.7, //一半的质量
                                  //   // maxSize: 1024, //1024KB
                                  // );
                                  res.forEach((element) {
                                    image.add(XFile(element.path));
                                  });
                                  showToast(
                                    context: context,
                                    type: XSToast.loading,
                                    txt: "上传中…",
                                  );
                                }
                                var img_urls =
                                    await Api().uploadImage(imgs: image) ?? [];
                                await widget.uploadImg(img_urls);
                                setState(() {
                                  upLoading = false;
                                });
                                hideToast();
                              },
                            ),
                            SendFunc(
                              path: Provider.of<ColorProvider>(context).isDark
                                  ? "lib/img/topic_attach_light.svg"
                                  : "lib/img/topic_attach.svg",
                              uploadProgress: uploadProgress,
                              tap: () async {
                                showAction(
                                  context: context,
                                  options: ["上传视频", "上传附件"],
                                  icons: [
                                    Icons.videocam_outlined,
                                    Icons.attachment
                                  ],
                                  tap: (res) async {
                                    if (res == 0) {
                                      Navigator.pop(context);
                                      String aid = await getVideoUploadAid(
                                        tid: widget.tid,
                                        fid: widget.fid,
                                        context: context,
                                        onUploadProgress: (rate) {
                                          setState(() {
                                            uploadProgress = rate;
                                          });
                                        },
                                      );
                                      print("上传的附件${aid}");
                                      if (aid != "") {
                                        setState(() {
                                          uploadFile = aid;
                                        });
                                        widget.uploadFile(aid); //上传附件
                                      } else {
                                        setState(() {
                                          uploadFile = "";
                                        });
                                      }
                                    }
                                    if (res == 1) {
                                      Navigator.pop(context);
                                      String aid = await getUploadAid(
                                        tid: widget.tid,
                                        fid: widget.fid,
                                        context: context,
                                        onUploadProgress: (rate) {
                                          setState(() {
                                            uploadProgress = rate;
                                          });
                                        },
                                      );
                                      print("上传的附件${aid}");
                                      if (aid != "") {
                                        setState(() {
                                          uploadFile = aid;
                                        });
                                        widget.uploadFile(aid); //上传附件
                                      } else {
                                        setState(() {
                                          uploadFile = "";
                                        });
                                      }
                                    }
                                  },
                                );
                              },
                            ),
                            SwitchHead(),
                          ],
                        ),
                      ),
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: (MediaQuery.of(context).size.width -
                                      MinusSpace(context)) *
                                  0.75,
                              height: popSection
                                  ? (widget.anonymous ?? false ? 95 : 135)
                                  : (widget.anonymous ?? false ? 145 : 185),
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: TextField(
                                keyboardAppearance: Provider.of<ColorProvider>(
                                            context,
                                            listen: false)
                                        .isDark
                                    ? Brightness.dark
                                    : Brightness.light,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                focusNode: widget.focusNode,
                                controller: widget.controller,
                                style: TextStyle(
                                  height: 1.8,
                                  color:
                                      Provider.of<ColorProvider>(context).isDark
                                          ? os_dark_white
                                          : os_black,
                                ),
                                cursorColor: Color(0xFF004DFF),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: widget.placeholder ??
                                      (isMacOS()
                                          ? "请在此编辑回复，按住control键+空格键以切换中英文输入法"
                                          : "请在此编辑回复"),
                                  hintStyle: TextStyle(
                                    height: 1.8,
                                    color: Provider.of<ColorProvider>(context)
                                            .isDark
                                        ? os_dark_dark_white
                                        : Color(0xFFBBBBBB),
                                  ),
                                ),
                              ),
                            ),
                            widget.anonymous
                                ? Container(
                                    // color: os_color,
                                    padding: EdgeInsets.only(left: 10),
                                    height: 40,
                                    width: (MediaQuery.of(context).size.width -
                                            MinusSpace(context)) *
                                        0.75,
                                    child: Row(
                                      children: [
                                        Switch(
                                          trackColor: MaterialStatePropertyAll(
                                            isAnonymous
                                                ? os_deep_blue
                                                : os_middle_grey,
                                          ),
                                          value: isAnonymous,
                                          onChanged: (val) {
                                            setState(() {
                                              isAnonymous = val;
                                            });
                                          },
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isAnonymous = !isAnonymous;
                                            });
                                          },
                                          child: Text(
                                            "是否匿名",
                                            style: TextStyle(
                                              color: os_deep_grey,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      myInkWell(
                        color: Colors.transparent,
                        tap: () {
                          widget.cancel();
                        },
                        widget: Container(
                          width: (MediaQuery.of(context).size.width -
                                  MinusSpace(context)) *
                              0.25,
                          height: 60,
                          child: Center(
                            child: Text(
                              "取消",
                              style: TextStyle(
                                fontSize: 16,
                                color:
                                    Provider.of<ColorProvider>(context).isDark
                                        ? os_dark_white
                                        : Color(0xFF656565),
                              ),
                            ),
                          ),
                        ),
                        radius: 15,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 15),
                        child: myInkWell(
                          tap: () {
                            if (!widget.sending) {
                              widget.send(isAnonymous);
                            }
                          },
                          color: Color(0xFF004DFF),
                          widget: Container(
                            width: (MediaQuery.of(context).size.width -
                                    MinusSpace(context)) *
                                0.2,
                            height: 100,
                            child: Center(
                              child: widget.sending
                                  ? Container(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: os_white,
                                      ),
                                    )
                                  : Text(
                                      "发\n送",
                                      style: TextStyle(
                                        color: os_white,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          ),
                          radius: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          popSection
              ? Container(
                  width:
                      (MediaQuery.of(context).size.width - MinusSpace(context)),
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_dark_back
                      : os_white,
                  height: popHeight,
                  child: popSectionIndex == 0
                      ? YourEmoji(
                          tap: (emoji) {
                            //inserting_num
                            int inserting_tmp = inserting_num;
                            widget.controller.text = widget.controller.text
                                    .substring(0, inserting_tmp) +
                                emoji +
                                widget.controller.text.substring(inserting_tmp,
                                    widget.controller.text.length);
                            inserting_num =
                                inserting_tmp + emoji.toString().length;
                            setState(() {});
                          },
                        )
                      : AtSomeone(
                          hide: () {
                            setState(() {
                              popSection = false;
                            });
                          },
                          tap: (uid, name) {
                            at_user.add({uid: uid, name: name});
                            widget.atUser(at_user);
                            widget.controller.text =
                                widget.controller.text + " @${name} ";
                            setState(() {});
                          },
                        ),
                )
              : Container(),
        ],
      ),
    );
  }
}

class SwitchHead extends StatefulWidget {
  const SwitchHead({Key key}) : super(key: key);

  @override
  State<SwitchHead> createState() => _SwitchHeadState();
}

class _SwitchHeadState extends State<SwitchHead> {
  String head_url = "";

  getHead() async {
    String myinfo_txt = await getStorage(key: "myinfo", initData: "");
    Map myinfo_map = jsonDecode(myinfo_txt);
    head_url = myinfo_map["avatar"];
    setState(() {});
  }

  @override
  void initState() {
    getHead();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: head_url == ""
              ? Container()
              : myInkWell(
                  radius: 100,
                  widget: Padding(
                    padding: const EdgeInsets.all(12.5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        color: Provider.of<ColorProvider>(context).isDark
                            ? os_light_dark_card
                            : os_grey,
                        child: Image.network(
                          head_url,
                          width: 26.5,
                          height: 26.5,
                        ),
                      ),
                    ),
                  ),
                  color: Colors.transparent,
                  tap: () {
                    Navigator.pushNamed(context, "/account")
                        .then((value) => getHead());
                  },
                ),
        ),
        // Positioned(
        //   right: 5,
        //   bottom: 5,
        //   child: Transform.rotate(
        //     angle: pi / 4,
        //     child: Icon(
        //       Icons.chevron_right_rounded,
        //       color: Provider.of<ColorProvider>(context).isDark
        //           ? os_dark_dark_white
        //           : os_deep_grey,
        //       size: 18,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
