import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/asset/to_user.dart';
import 'package:offer_show/outer/cached_network_image/cached_image_widget.dart';

class Collection extends StatefulWidget {
  Map data = {
    "name": "甜甜的狗粮铺", //专辑的名称
    "desc": "愿每日的心酸在青春与岁月证明的爱情中融化，愿你憧憬爱情相信爱情并拥有爱情。", //专辑的描述
    "user": "xusun000", //专辑的创建者姓名
    "head":
        "https://bbs.uestc.edu.cn/uc_server/avatar.php?uid=240329&size=middle", //专辑的创建者头像
    "user_id": 240329, //专辑的创建者ID
    "list_id": 240329, //专辑ID
    "tags": ["社会", "人物", "故事", "人性", "爱与和平"], //专辑的标签
    "type": 2, //0-黑 1-红 2-白
    "isShadow": false, //true-阴影 false-无阴影
  };
  Collection({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  State<Collection> createState() => _CollectionState();
}

class _CollectionState extends State<Collection> {
  List<Widget> _buildTag() {
    List<Widget> tmp = [];
    widget.data["tags"].forEach((element) {
      tmp.add(Container(
        padding: EdgeInsets.symmetric(horizontal: 11, vertical: 4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
            stops: [0, 1],
            colors: widget.data["type"] == 2
                ? [Color(0xFFF6F6F6), Color(0xFFF6F6F6)]
                : [
                    Color.fromRGBO(255, 255, 255, 0.08),
                    Color.fromRGBO(255, 255, 255, 0.1)
                  ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
        child: Text(
          element,
          style: TextStyle(
            color: widget.data["type"] == 2
                ? Color(0xFF313131)
                : Color.fromRGBO(255, 255, 255, 0.8),
            fontSize: 14,
          ),
        ),
      ));
    });
    return tmp;
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.data["name"] + widget.data["list_id"].toString(), //Hero标志
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            boxShadow: widget.data["isShadow"]
                ? [
                    widget.data["type"] == 2
                        ? BoxShadow(
                            //白卡片阴影
                            color: Color.fromRGBO(0, 0, 0, 0.1),
                            blurRadius: 23,
                            spreadRadius: -2,
                            offset: Offset(10, 18),
                          )
                        : BoxShadow(
                            //黑卡片阴影
                            color: Color.fromRGBO(0, 0, 0, 0.3),
                            blurRadius: 23,
                            spreadRadius: -2,
                            offset: Offset(10, 18),
                          ),
                  ]
                : [],
            borderRadius: BorderRadius.all(Radius.circular(20)),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.centerRight,
                stops: [0, 1],
                colors: [
                  [Color(0xFF262B37), Color(0xFF536174)],
                  [Color(0xFFE83C2D), Color(0xFFFA6E54)],
                  [Color(0xFFFFFFFF), Color(0xFFFFFFFF)],
                ][widget.data["type"]]),
          ),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 0,
                child: [
                  os_svg(path: "lib/img/quote.svg"),
                  Icon(
                    Icons.auto_awesome_sharp,
                    size: 80,
                    color: Color.fromRGBO(255, 255, 255, 0.15),
                  ),
                  os_svg(path: "lib/img/quote_dark.svg"),
                ][widget.data["type"]],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        child: Text(
                          widget.data["name"].toString(),
                          style: TextStyle(
                            color: widget.data["type"] == 2
                                ? Color(0xFF272C38)
                                : os_white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(width: 7.5),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 7.5, vertical: 3),
                        decoration: BoxDecoration(
                          color: widget.data["type"] == 2
                              ? Color(0xFF646464)
                              : Color.fromRGBO(255, 255, 255, 0.15),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Text(
                          "订阅",
                          style: TextStyle(
                            color: os_white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(height: 5),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      widget.data["desc"],
                      style: TextStyle(
                        color: widget.data["type"] == 2
                            ? Color(0xFF526073)
                            : Color.fromRGBO(255, 255, 255, 0.8),
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Container(height: 7.5),
                  Transform.translate(
                    offset: const Offset(-3, 0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Wrap(
                        spacing: 5,
                        runAlignment: WrapAlignment.start,
                        children: _buildTag(),
                      ),
                    ),
                  ),
                  Container(height: 12.5),
                  GestureDetector(
                    onTap: () {
                      toUserSpace(context, widget.data["user_id"]);
                    },
                    child: Container(
                      color: Color.fromRGBO(0, 0, 0, 0.001),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                child: CachedNetworkImage(
                                  imageUrl: widget.data["head"],
                                  width: 20,
                                  height: 20,
                                  placeholder: (context, url) => Container(
                                    color: Color.fromRGBO(255, 255, 255, 0.6),
                                  ),
                                ),
                              ),
                              Container(width: 7.5),
                              Text(
                                widget.data["name"],
                                style: TextStyle(
                                  color: widget.data["type"] == 2
                                      ? Color(0xFF767676)
                                      : Color.fromRGBO(255, 255, 255, 0.8),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Transform.translate(
                            offset: Offset(7.5, 0),
                            child: Row(
                              children: [
                                Text(
                                  "个人首页",
                                  style: TextStyle(
                                    color: widget.data["type"] == 2
                                        ? Color(0xFF9a9a9a)
                                        : Color.fromRGBO(255, 255, 255, 0.5),
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: widget.data["type"] == 2
                                      ? Color(0xFF9a9a9a)
                                      : Color.fromRGBO(255, 255, 255, 0.5),
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
