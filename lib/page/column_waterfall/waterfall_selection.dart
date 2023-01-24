import 'package:flutter/material.dart';
import 'package:offer_show/page/column_waterfall/column_btn.dart';

class ColumnWaterfallSelection extends StatefulWidget {
  int fid;
  String name;
  ColumnWaterfallSelection({
    Key key,
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
          backgroundColor: Color(0x66000000),
          body: Center(
            child: Wrap(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
