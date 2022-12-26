// 帖子浏览量和时间
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/myinfo.dart';
import 'package:offer_show/asset/showPop.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/asset/time.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/mid_request.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class TopicDetailTime extends StatefulWidget {
  var data;
  Function? refresh;
  Function? capture;
  TopicDetailTime({
    Key? key,
    this.refresh,
    this.capture,
    required this.data,
  }) : super(key: key);

  @override
  State<TopicDetailTime> createState() => _TopicDetailTimeState();
}

class _TopicDetailTimeState extends State<TopicDetailTime> {
  String _value = "";

  _giveWater() async {
    showPop(context, [
      Container(height: 30),
      Text(
        "请给楼主加水",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Provider.of<ColorProvider>(context, listen: false).isDark
              ? os_dark_white
              : os_black,
        ),
      ),
      Container(height: 10),
      Text(
        "注意：会扣除你等量的水（扣水额外收税10%）",
        style: TextStyle(
          fontSize: 14,
          color: os_deep_grey,
        ),
      ),
      Container(height: 10),
      Container(
        height: 60,
        padding: EdgeInsets.symmetric(
          horizontal: 15,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Provider.of<ColorProvider>(context, listen: false).isDark
              ? os_white_opa
              : os_grey,
        ),
        child: Center(
          child: TextField(
            cursorColor: os_deep_blue,
            onChanged: (ele) {
              _value = ele;
            },
            style: TextStyle(
              color: Provider.of<ColorProvider>(context, listen: false).isDark
                  ? os_dark_white
                  : os_black,
            ),
            decoration: InputDecoration(
                hintText: "请输入水滴数，从-5~30",
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color:
                      Provider.of<ColorProvider>(context, listen: false).isDark
                          ? os_dark_dark_white
                          : os_deep_grey,
                )),
          ),
        ),
      ),
      Container(height: 10),
      Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: myInkWell(
              tap: () {
                Navigator.pop(context);
              },
              color: Provider.of<ColorProvider>(context, listen: false).isDark
                  ? os_white_opa
                  : Color(0x16004DFF),
              widget: Container(
                width: (MediaQuery.of(context).size.width - 60) / 2 - 5,
                height: 40,
                child: Center(
                  child: Text(
                    "取消",
                    style: TextStyle(
                      color: Provider.of<ColorProvider>(context, listen: false)
                              .isDark
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
                try {
                  int val_int = int.parse(_value);
                  if (val_int < -5 || val_int > 30) {
                    showToast(
                      context: context,
                      type: XSToast.none,
                      txt: "请输入-5~30的整数",
                    );
                  } else {
                    await XHttp().pureHttp(
                        url: widget.data["topic"]["extraPanel"][0]["action"]
                                .toString() +
                            "&modsubmit=确定",
                        param: {
                          "score2": "${val_int}",
                          "sendreasonpm": "on",
                          "reason": "水滴操作",
                        });
                    if (widget.refresh != null) widget.refresh!();
                    Navigator.pop(context);
                  }
                } catch (e) {
                  showToast(
                    context: context,
                    type: XSToast.none,
                    txt: "请输入整数",
                  );
                }
              },
              color: os_deep_blue,
              widget: Container(
                width: (MediaQuery.of(context).size.width - 60) / 2 - 5,
                height: 40,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.done, color: os_white, size: 18),
                      Container(width: 5),
                      Text(
                        "完成",
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
    ].toList());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                (RelativeDateFormat.format(DateTime.fromMillisecondsSinceEpoch(
                                int.parse(widget.data["topic"]["create_date"])))
                            .contains(" ")
                        ? RelativeDateFormat.format(DateTime.fromMillisecondsSinceEpoch(
                                int.parse(widget.data["topic"]["create_date"])))
                            .split(" ")[0]
                        : RelativeDateFormat.format(DateTime.fromMillisecondsSinceEpoch(
                            int.parse(widget.data["topic"]["create_date"])))) +
                    " · 浏览量${widget.data['topic']['hits'].toString()} · " +
                    (widget.data["topic"]["mobileSign"].toString().contains("苹果")
                        ? "iPhone客户端"
                        : (widget.data["topic"]["mobileSign"].toString().contains("安卓") ? "安卓客户端" : "网页版")),
                style: TextStyle(
                  fontSize: 13.5,
                  color: Color(0xFFAAAAAA),
                ),
              ),
            ],
          ),
          Row(children: [
            myInkWell(
                color: Colors.transparent,
                tap: () async {
                  if (widget.data["topic"]["user_id"] != (await getUid())) {
                    _giveWater();
                  }
                },
                widget: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        os_svg(
                          path: "lib/img/topic_water.svg",
                          width: 14,
                          height: 17,
                        ),
                        Padding(
                            padding: EdgeInsets.all(
                                widget.data["topic"]["reward"] != null
                                    ? 2.5
                                    : 0)),
                        widget.data["topic"]["reward"] != null
                            ? Text(
                                widget.data["topic"]["reward"]["score"][0]
                                        ["value"]
                                    .toString(),
                                style: TextStyle(color: os_deep_grey),
                              )
                            : Container()
                      ]),
                ),
                radius: 10),
            myInkWell(
                color: Colors.transparent,
                tap: () async {
                  showToast(
                    context: context,
                    type: XSToast.loading,
                    txt: "请稍后",
                  );
                  await Api().user_userfavorite({
                    "idType": "tid",
                    "action": [
                      "favorite",
                      "delfavorite"
                    ][widget.data["topic"]["is_favor"]],
                    "id": widget.data["topic"]["topic_id"],
                  });
                  setState(() {
                    widget.data["topic"]["is_favor"] =
                        1 - widget.data["topic"]["is_favor"];
                  });
                  hideToast();
                  showToast(
                    context: context,
                    type: XSToast.success,
                    txt: widget.data["topic"]["is_favor"] == 1
                        ? "收藏成功"
                        : "取消收藏成功",
                  );
                },
                widget: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    os_svg(
                        path: widget.data["topic"]["is_favor"] == 1
                            ? "lib/img/topic_collect_blue.svg"
                            : "lib/img/topic_collect.svg",
                        width: 14,
                        height: 17),
                  ]),
                ),
                radius: 10),
            !(Platform.isIOS || Platform.isAndroid)
                ? Container()
                : myInkWell(
                    color: Colors.transparent,
                    tap: () async {
                      if (widget.capture != null) {
                        showModal(
                            context: context,
                            title: "截图功能",
                            cont: "轻触确认以截取帖子和评论并保存到相册,如果长度过长可能会导致图片像素质量不佳",
                            confirm: () {
                              widget.capture!();
                            });
                      }
                    },
                    widget: Padding(
                      padding: EdgeInsets.only(
                          left: 8.0, right: 8, top: 9, bottom: 7),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            os_svg(
                              path: "lib/img/topic_capture.svg",
                              width: 17,
                              height: 17,
                            ),
                          ]),
                    ),
                    radius: 10),
          ])
        ],
      ),
    );
  }
}
