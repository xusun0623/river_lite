import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/vibrate.dart';
import 'package:offer_show/outer/showActionSheet/action_item.dart';
import 'package:offer_show/outer/showActionSheet/bottom_action_item.dart';
import 'package:offer_show/outer/showActionSheet/bottom_action_sheet.dart';

saveImge(
  BuildContext context,
  List urls,
  int index,
) async {
  List<ActionItem> tmp = [
    ActionItem(
      title: "保存原图",
      onPressed: () async {
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
          quality: 60,
          name: "河畔-" + new DateTime.now().millisecondsSinceEpoch.toString(),
        );
        if (result["isSuccess"]) {
          showToast(context: context, type: XSToast.success, txt: "保存成功！");
        }
      },
    )
  ];
  if (urls.length > 1) {
    tmp.add(ActionItem(
      title: "一键保存所有原图",
      onPressed: () async {
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
          var result = await ImageGallerySaver.saveImage(
            Uint8List.fromList(response.data),
            quality: 60,
            name: "河畔-" + new DateTime.now().millisecondsSinceEpoch.toString(),
          );
        }
        hideToast();
        showToast(
          context: context,
          type: XSToast.success,
          txt: "保存成功！",
        );
      },
    ));
  }
  XSVibrate();
  showActionSheet(
    isScrollControlled: true,
    actionSheetColor: os_white,
    enableDrag: true,
    context: context,
    actions: tmp,
    bottomActionItem: BottomActionItem(title: "取消"),
  );
}
