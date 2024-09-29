import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import "package:image/image.dart" as IMG;
import 'package:image_picker/image_picker.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/myinfo.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/mid_request.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class CropImg extends StatefulWidget {
  CropImg({Key? key}) : super(key: key);

  @override
  _CropImgState createState() => _CropImgState();
}

class _CropImgState extends State<CropImg> {
  final _controller = CropController();
  Uint8List? img;
  bool edit_done = false;

  _pickImg() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      img = await image.readAsBytes();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Provider.of<ColorProvider>(context).isDark
            ? os_dark_back
            : os_white,
        foregroundColor: Provider.of<ColorProvider>(context).isDark
            ? os_dark_white
            : os_black,
        title: Text(edit_done ? "" : "上传新头像", style: TextStyle(fontSize: 16)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.chevron_left_rounded),
        ),
      ),
      backgroundColor:
          Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_white,
      body: edit_done
          ? EditDoneDisplay()
          : ListView(
              physics: NeverScrollableScrollPhysics(),
              //physics: BouncingScrollPhysics(),
              children: [
                img == null
                    ? Bounce(
                        onPressed: () {
                          _pickImg();
                        },
                        duration: Duration(milliseconds: 200),
                        child: Container(
                          height: MediaQuery.of(context).size.width - 40,
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Provider.of<ColorProvider>(context).isDark
                                ? os_light_dark_card
                                : os_grey,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.photo_size_select_actual_rounded,
                                  color:
                                      Provider.of<ColorProvider>(context).isDark
                                          ? os_dark_white
                                          : os_black,
                                ),
                                Container(width: 10),
                                Text(
                                  "点此选择您的新头像",
                                  style: TextStyle(
                                    color: Provider.of<ColorProvider>(context)
                                            .isDark
                                        ? os_dark_white
                                        : os_black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.black.withAlpha(150),
                        child: Container(
                          height: MediaQuery.of(context).size.width,
                          child: Material(
                            child: Crop(
                              controller: _controller,
                              image: img!,
                              onCropped: (image) async {
                                IMG.Image img = IMG.decodeImage(image)!;
                                Uint8List resizedData200 = IMG.encodeJpg(
                                    IMG.copyResize(img,
                                        width: 200, height: 200)) as Uint8List;
                                Uint8List resizedData120 = IMG.encodeJpg(
                                    IMG.copyResize(img,
                                        width: 120, height: 120)) as Uint8List;
                                Uint8List resizedData48 = IMG.encodeJpg(IMG
                                        .copyResize(img, width: 48, height: 48))
                                    as Uint8List;
                                String base64_200 =
                                    base64Encode(resizedData200);
                                String base64_120 =
                                    base64Encode(resizedData120);
                                String base64_48 = base64Encode(resizedData48);
                                await Api().edit_avator(
                                  base64_1: base64_200,
                                  base64_2: base64_120,
                                  base64_3: base64_48,
                                );
                                int? uid = await getUid();
                                CachedNetworkImage.evictFromCache(
                                  //清除原有缓存
                                  base_url +
                                      "uc_server/avatar.php?uid=${uid}&size=big",
                                );
                                CachedNetworkImage.evictFromCache(
                                  base_url +
                                      "uc_server/avatar.php?uid=${uid}&size=middle",
                                );
                                CachedNetworkImage.evictFromCache(
                                  base_url +
                                      "uc_server/avatar.php?uid=${uid}&size=small",
                                );
                                setState(() {
                                  edit_done = true;
                                });
                                hideToast();
                              },
                              radius: 15,
                              aspectRatio: 1,
                              maskColor: Colors.black.withAlpha(150),
                              cornerDotBuilder: (size, edgeAlignment) =>
                                  const DotControl(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                img == null ? Container() : InfoTip(),
                MyButton(
                  index: 0,
                  show: img != null,
                  tap: () {
                    showToast(
                      context: context,
                      type: XSToast.loading,
                      txt: "努力上传中…",
                      duration: 10000,
                    );
                    _controller.crop();
                  },
                  txt: "完成并上传",
                ),
                MyButton(
                  index: 1,
                  show: img != null,
                  tap: () {
                    setState(() {
                      img = null;
                    });
                    _pickImg();
                  },
                  txt: "重新选择图片",
                ),
              ],
            ),
    );
  }
}

class EditDoneDisplay extends StatelessWidget {
  const EditDoneDisplay({
    Key? key,
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
            color: os_deep_blue,
          ),
          Container(height: 10),
          Text(
            "上传头像成功",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          Container(height: 10),
          Container(
            width: 300,
            child: Text(
              "您已成功上传新的头像，在其它具有缓存的客户端可能有延时，你可以尝试清除缓存后查看新头像",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Container(height: 300),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 150,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Color.fromRGBO(0, 77, 255, 1),
              ),
              child: Center(
                child: Text(
                  "返回",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: os_white,
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

class MyButton extends StatefulWidget {
  Function? tap;
  String? txt;
  int? index;
  bool? show;
  MyButton({
    Key? key,
    this.tap,
    this.txt,
    this.index,
    this.show,
  }) : super(key: key);

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return !widget.show!
        ? Container()
        : Container(
            margin: EdgeInsets.only(left: os_edge, right: os_edge, bottom: 10),
            child: myInkWell(
              tap: () {
                widget.tap!();
              },
              color: widget.index == 0 ? os_color : os_color_opa,
              radius: 20,
              widget: Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    widget.txt!,
                    style: TextStyle(
                      fontSize: 15,
                      color: widget.index == 0 ? os_white : os_color,
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}

class InfoTip extends StatelessWidget {
  const InfoTip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.only(left: os_edge, right: os_edge, top: 20, bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: os_edge * 1.5, vertical: 20),
      decoration: BoxDecoration(
        color: os_grey,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        children: [
          Icon(Icons.info, color: os_deep_grey),
          Container(width: 5),
          Text(
            "请移动顶角滑柄以裁切图像",
            style: TextStyle(
              color: os_deep_grey,
            ),
          ),
        ],
      ),
    );
  }
}
