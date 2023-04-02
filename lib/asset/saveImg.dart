import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/showActionSheet.dart';
import 'package:offer_show/asset/vibrate.dart';

saveImge(
  BuildContext context,
  List urls,
  int index,
) async {
  XSVibrate();
  showAction(
    context: context,
    options: urls.length > 1 ? ["保存原图", "一键保存所有原图"] : ["保存原图"],
    icons: urls.length > 1
        ? [Icons.save_alt_outlined, Icons.downloading_rounded]
        : [Icons.save_alt_outlined],
    tap: (res) async {
      if (res == "保存原图") {
        Navigator.pop(context);
        showToast(
          context: context,
          type: XSToast.loading,
          txt: "保存中…",
        );
        var response = await Dio().get(
          urls[index],
          options: Options(responseType: ResponseType.bytes),
        );
        hideToast();
        final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 100,
          name: "河畔-" + new DateTime.now().millisecondsSinceEpoch.toString(),
        );
        if (result["isSuccess"]) {
          showToast(context: context, type: XSToast.success, txt: "保存成功！");
        }
      }
      if (res == "一键保存所有原图") {
        Navigator.pop(context);
        showToast(
          duration: 10000,
          context: context,
          type: XSToast.loading,
          txt: "保存中…",
        );
        for (var i = 0; i < urls.length; i++) {
          var response = await Dio().get(
            urls[i],
            options: Options(responseType: ResponseType.bytes),
          );
          await ImageGallerySaver.saveImage(
            Uint8List.fromList(response.data),
            quality: 100,
            name: "河畔-" + new DateTime.now().millisecondsSinceEpoch.toString(),
          );
        }
        hideToast();
        showToast(
          context: context,
          type: XSToast.success,
          txt: "保存成功！",
        );
      }
    },
  );
}
