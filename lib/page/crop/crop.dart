import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/components/niw.dart';

class CropImg extends StatefulWidget {
  CropImg({Key key}) : super(key: key);

  @override
  _CropImgState createState() => _CropImgState();
}

class _CropImgState extends State<CropImg> {
  final _controller = CropController();
  Uint8List img;

  _pickImg() async {
    final ImagePicker _picker = ImagePicker();
    final XFile image = await _picker.pickImage(source: ImageSource.gallery);
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
        backgroundColor: os_back,
        foregroundColor: os_black,
        title: Text("上传新头像", style: TextStyle(fontSize: 16)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.chevron_left_rounded),
        ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          img == null
              ? GestureDetector(
                  onTap: () {
                    _pickImg();
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.width - 40,
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: os_grey,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.photo_size_select_actual_rounded),
                          Container(width: 10),
                          Text("点此选择您的新头像"),
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
                        image: img,
                        onCropped: (image) {},
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

class MyButton extends StatefulWidget {
  Function tap;
  String txt;
  int index;
  bool show;
  MyButton({
    Key key,
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
    return !widget.show
        ? Container()
        : Container(
            margin: EdgeInsets.only(left: os_edge, right: os_edge, bottom: 10),
            child: myInkWell(
              tap: () {
                widget.tap();
              },
              color: widget.index == 0 ? os_color : os_color_opa,
              radius: 20,
              widget: Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    widget.txt,
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
  const InfoTip({Key key}) : super(key: key);

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
