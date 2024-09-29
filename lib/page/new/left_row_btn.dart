import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offer_show/asset/bigScreen.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/phone_pick_images.dart';
import 'package:offer_show/asset/showActionSheet.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/asset/uploadAttachment.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/page/photo_view/photo_view.dart';
import 'package:offer_show/page/topic/topic_RichInput.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class LeftRowBtn extends StatefulWidget {
  FocusNode title_focus;
  FocusNode tip_focus;
  int pop_section_index;
  bool pop_section;
  bool uploading;
  bool showAttach;
  Function setPopSection;
  Function setPopSectionIndex;
  Function setUploading;
  Function setImgUrls;
  List img_urls;
  LeftRowBtn({
    Key? key,
    required this.title_focus,
    required this.tip_focus,
    required this.pop_section_index,
    required this.pop_section,
    required this.uploading,
    required this.showAttach,
    required this.setPopSection,
    required this.setPopSectionIndex,
    required this.setUploading,
    required this.setImgUrls,
    required this.img_urls,
  }) : super(key: key);

  @override
  State<LeftRowBtn> createState() => _LeftRowBtnState();
}

class _LeftRowBtnState extends State<LeftRowBtn> {
  bool isUpLoading = false;
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
          widget: BtnContainer(
            svg_path: "lib/img/topic_emoji_black.svg",
            txt: "表情",
          ),
          radius: 10,
          // width: 30,
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
          widget: BtnContainer(
            svg_path: "lib/img/topic_@_black.svg",
            txt: "提及某人",
          ),
          radius: 10,
          // width: 30,
          height: 29,
        ),
        Container(width: 15),
        myInkWell(
          color: Provider.of<ColorProvider>(context).isDark
              ? os_light_dark_card
              : os_white,
          tap: () async {
            showAction(
              context: context,
              options: widget.img_urls.length == 0
                  ? ["选择图片（建议3张以内）"]
                  : ["选择图片（建议3张以内）", "查看图片", "清空已上传图片"],
              icons: widget.img_urls.length == 0
                  ? [Icons.image_outlined]
                  : [
                      Icons.image_outlined,
                      Icons.preview_outlined,
                      Icons.clear_all,
                    ],
              tap: (res) async {
                if (res == "选择图片（建议3张以内）") {
                  List<XFile> image = [];
                  widget.setImgUrls([]);
                  Navigator.pop(context);
                  widget.title_focus.unfocus();
                  widget.tip_focus.unfocus();
                  if (isMacOS()) {
                    print("选择大屏图片");
                    image = await pickeImgFile(context);
                  } else {
                    print("选择小屏图片");
                    List res = (await getPhoneImages(context))!;
                    res.forEach((element) {
                      image.add(XFile(element.path));
                    });
                  }
                  print("${image}");
                  if (image == null || image.length == 0) {
                    return;
                  }
                  setState(() {
                    isUpLoading = true;
                  });
                  widget.setImgUrls(await Api().uploadImage(imgs: image));
                  setState(() {
                    isUpLoading = false;
                  });
                }
                if (res == "查看图片") {
                  Navigator.pop(context);
                  if (widget.img_urls.length != 0) {
                    print("${widget.img_urls}");
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => PhotoPreview(
                          galleryItems:
                              widget.img_urls.map((e) => e["urlName"]).toList(),
                          defaultImage: 0,
                        ),
                      ),
                    );
                  }
                }
                if (res == "清空已上传图片") {
                  widget.setImgUrls([]);
                  Navigator.pop(context);
                }
              },
            );
          },
          widget: Stack(
            children: [
              BtnContainer(
                svg_path: "lib/img/topic_line_image.svg",
                txt: "上传图片",
              ),
              widget.img_urls.length == 0
                  ? !isUpLoading
                      ? Container()
                      : Container(
                          child: Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    10,
                                  ),
                                ),
                              ),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        )
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
          // width: 30,
          height: 29,
        ),
        Container(width: 15),
        widget.showAttach ?? true
            ? myInkWell(
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
                widget: BtnContainer(
                  svg_path: "lib/img/topic_attach_black.svg",
                  txt: "上传附件",
                ),
                radius: 10,
                // width: 30,
                height: 29,
              )
            : Container(),
        widget.showAttach ?? true ? Container(width: 12.5) : Container(),
        SwitchHead(small: true),
      ],
    );
  }
}

class BtnContainer extends StatelessWidget {
  String? svg_path;
  String? txt;
  BtnContainer({Key? key, this.svg_path, this.txt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.5),
      child: Row(
        children: [
          os_svg(
            path: svg_path ?? "lib/img/topic_emoji_black.svg",
            width: 22,
            height: 22,
          ),
          isDesktop() ? Container(width: 5) : Container(),
          isDesktop()
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    txt ?? "表情",
                    style: TextStyle(
                      color: Color(0xFF707070),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
