import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class ToWaterTip extends StatefulWidget {
  Function confirm;
  ToWaterTip({
    Key key,
    this.confirm,
  }) : super(key: key);

  @override
  State<ToWaterTip> createState() => _ToWaterTipState();
}

class _ToWaterTipState extends State<ToWaterTip> {
  String txt = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 30,
      ),
      height: MediaQuery.of(context).size.height - 100,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(height: 30),
          Center(
            child: Text(
              "请确认",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_white
                    : os_black,
              ),
            ),
          ),
          Container(height: 10),
          Center(
            child: Text(
              "此功能为无权限访问的成电校友开发，在使用此功能时请确保所搬运的内容不得包含任何未经审核的具有舆论矛盾的校园热点、成电锐评、情感专区等校内专属内容。违规时由管理员或者版主进行禁言、封禁等处理。",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_white
                    : os_black,
              ),
            ),
          ),
          Container(height: 15),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 10),
                child: myInkWell(
                  tap: () {
                    Navigator.pop(context);
                  },
                  color:
                      Provider.of<ColorProvider>(context, listen: false).isDark
                          ? os_white_opa
                          : Color(0x16004DFF),
                  widget: Container(
                    width: (MediaQuery.of(context).size.width - 60) / 2 - 5,
                    height: 40,
                    child: Center(
                      child: Text(
                        "取消",
                        style: TextStyle(
                          color: Provider.of<ColorProvider>(context).isDark
                              ? os_dark_dark_white
                              : os_deep_blue,
                        ),
                      ),
                    ),
                  ),
                  radius: 12.5,
                ),
              ),
              Container(
                child: myInkWell(
                  tap: () async {
                    Navigator.pop(context);
                    widget.confirm();
                  },
                  color: os_deep_blue,
                  widget: Container(
                    width: (MediaQuery.of(context).size.width - 60) / 2 - 5,
                    height: 40,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "确认搬运",
                            style: TextStyle(
                              color: os_white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  radius: 12.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
