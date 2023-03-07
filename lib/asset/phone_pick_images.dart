import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:images_picker/images_picker.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/util/storage.dart';

Future<List> getPhoneImages(BuildContext context) async {
  if (Platform.isAndroid) {
    Completer c = new Completer<List>();
    handler() async {
      final ImagePicker _picker = ImagePicker();
      final List<XFile> images = await _picker.pickMultiImage();
      c.complete(images);
    }

    if ((await getStorage(key: "image_select")) != "") {
      handler();
    } else {
      showModal(
        context: context,
        title: "提示",
        cont: "在原生图片选择器中，长按可以【多选】",
        confirmTxt: "立即前往",
        cancelTxt: "不再提示",
        cancel: () async {
          await setStorage(key: "image_select", value: "1");
          handler();
        },
        confirm: () {
          handler();
        },
      );
    }
    return c.future;
  } else {
    List res = await ImagesPicker.pick(
      count: 10,
      pickType: PickType.image,
      quality: 0.7, //一半的质量
      // maxSize: 2048, //1024KB
    );
    return res;
  }
}
