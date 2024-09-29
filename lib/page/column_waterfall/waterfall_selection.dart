import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/xs_textstyle.dart';
import 'package:offer_show/page/column_waterfall/column_btn.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class ColumnWaterfallSelection extends StatefulWidget {
  int? fid;
  String? name;
  ColumnWaterfallSelection({
    Key? key,
    this.fid,
    this.name,
  }) : super(key: key);

  @override
  State<ColumnWaterfallSelection> createState() =>
      _ColumnWaterfallSelectionState();
}

class _ColumnWaterfallSelectionState extends State<ColumnWaterfallSelection> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Scaffold(
          backgroundColor: Provider.of<ColorProvider>(context).isDark
              ? os_dark_back
              : os_grey,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ColumnBtn(
                      hideArrow: true,
                      name: "水手之家",
                      fid: 25,
                    ),
                    ColumnBtn(
                      hideArrow: true,
                      name: "二手专区",
                      fid: 61,
                    ),
                    ColumnBtn(
                      hideArrow: true,
                      name: "吃喝玩乐",
                      fid: 370,
                    ),
                    ColumnBtn(
                      hideArrow: true,
                      name: "就业创业",
                      fid: 174,
                    ),
                    ColumnBtn(
                      hideArrow: true,
                      name: "成电锐评",
                      fid: 309,
                    ),
                    ColumnBtn(
                      hideArrow: true,
                      name: "电子数码",
                      fid: 66,
                    ),
                    ColumnBtn(
                      hideArrow: true,
                      name: "时政要闻",
                      fid: 44,
                    ),
                    ColumnBtn(
                      hideArrow: true,
                      name: "研究生交流",
                      fid: 124,
                    ),
                    ColumnBtn(
                      hideArrow: true,
                      name: "招聘信息",
                      fid: 214,
                    ),
                    ColumnBtn(
                      hideArrow: true,
                      name: "程序员之家",
                      fid: 70,
                    ),
                    ColumnBtn(
                      hideArrow: true,
                      name: "本科交流",
                      fid: 127,
                    ),
                    ColumnBtn(
                      hideArrow: true,
                      name: "学术交流",
                      fid: 20,
                    ),
                    ColumnBtn(
                      hideArrow: true,
                      name: "情感专区",
                      fid: 45,
                    ),
                    ColumnBtn(
                      hideArrow: true,
                      name: "天下足球",
                      fid: 157,
                    ),
                    ColumnBtn(
                      hideArrow: true,
                      name: "校园热点",
                      fid: 236,
                    ),
                    ColumnBtn(
                      hideArrow: true,
                      name: "音乐空间",
                      fid: 74,
                    ),
                    ColumnBtn(
                      hideArrow: true,
                      name: "保研考研",
                      fid: 199,
                    ),
                    ColumnBtn(
                      hideArrow: true,
                      name: "军事国防",
                      fid: 115,
                    ),
                    ColumnBtn(
                      hideArrow: true,
                      name: "篮球部落",
                      fid: 156,
                    ),
                    ColumnBtn(
                      hideArrow: true,
                      name: "房屋租赁",
                      fid: 255,
                    ),
                    ColumnBtn(
                      hideArrow: true,
                      name: "藏经阁",
                      fid: 395,
                    ),
                  ],
                ),
                Container(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Bounce(
                      duration: Duration(milliseconds: 100),
                      onPressed: () {
                        Navigator.of(context).pushNamed("/square");
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        color: Color(0x01ffffff),
                        child: Row(
                          children: [
                            Container(width: 18),
                            Text(
                              "查看全部板块",
                              style: XSTextStyle(
                                context: context,
                                color:
                                    Provider.of<ColorProvider>(context).isDark
                                        ? os_deep_grey
                                        : os_deep_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 18,
                              color: Provider.of<ColorProvider>(context).isDark
                                  ? os_deep_grey
                                  : os_deep_grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(height: 20),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Provider.of<ColorProvider>(context).isDark
                        ? os_light_dark_card
                        : os_white,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Icon(
                    Icons.close,
                    color: Provider.of<ColorProvider>(context).isDark
                        ? os_dark_dark_white
                        : os_deep_grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
