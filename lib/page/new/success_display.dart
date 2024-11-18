import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/xs_textstyle.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
import 'package:provider/provider.dart';

class SuccessDisplay extends StatelessWidget {
  const SuccessDisplay({
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
            color: Provider.of<ColorProvider>(context).isDark
                ? os_dark_white
                : os_deep_blue,
          ),
          Container(height: 10),
          Text(
            "发表成功",
            style: XSTextStyle(
              context: context,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Provider.of<ColorProvider>(context).isDark
                  ? os_dark_white
                  : os_black,
            ),
          ),
          Container(height: 10),
          Container(
            width: 300,
            child: Text(
              "你已成功发送该帖子，客户端内帖子显示图片会有延时，你可以点击下方按钮查看",
              textAlign: TextAlign.center,
              style: XSTextStyle(
                context: context,
                fontSize: 16,
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_dark_white
                    : os_black,
              ),
            ),
          ),
          Container(height: 300),
          GestureDetector(
            onTap: () async {
              String myinfo_txt = await getStorage(key: "myinfo", initData: "");
              Map myinfo = jsonDecode(myinfo_txt);
              Navigator.pushNamed(
                context,
                "/me_func",
                arguments: {"type": 2, "uid": myinfo["uid"]},
              );
            },
            child: Container(
              width: 150,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_light_dark_card
                    : Color.fromRGBO(0, 77, 255, 1),
              ),
              child: Center(
                child: Text(
                  "查看帖子",
                  textAlign: TextAlign.center,
                  style: XSTextStyle(
                    context: context,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Provider.of<ColorProvider>(context).isDark
                        ? os_dark_white
                        : os_white,
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
