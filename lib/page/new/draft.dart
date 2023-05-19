import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
import 'package:provider/provider.dart';

class SaveDraftBtn extends StatelessWidget {
  const SaveDraftBtn({
    Key? key,
    required this.tip_controller,
    required this.tip_focus,
  }) : super(key: key);

  final TextEditingController tip_controller;
  final FocusNode tip_focus;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (tip_controller.text == "") return;
        String tmp = await getStorage(key: "draft", initData: "[]");
        List tmp_arr = jsonDecode(tmp);
        List tmp_tmp_arr = [tip_controller.text];
        tmp_tmp_arr.addAll(tmp_arr);
        await setStorage(key: "draft", value: jsonEncode(tmp_tmp_arr));
        showToast(context: context, type: XSToast.success, txt: "保存成功！");
        tip_focus.unfocus();
      },
      child: SaveDraft(),
    );
  }
}

class SaveDraft extends StatelessWidget {
  const SaveDraft({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Provider.of<ColorProvider>(context).isDark
              ? Color.fromRGBO(0, 146, 255, 0.2)
              : os_color_opa,
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
        child: Center(
          child: Container(
            child: Text(
              "保存草稿",
              style: TextStyle(color: os_color),
            ),
          ),
        ),
      ),
    );
  }
}
