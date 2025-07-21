import 'package:offer_show/components/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/asset/to_user.dart';
import 'package:offer_show/asset/xs_textstyle.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class Collection extends StatefulWidget {
  Map? data = {
    // "name": "甜甜的狗粮铺", //专辑的名称
    // "desc": "愿每日的心酸在青春与岁月证明的爱情中融化，愿你憧憬爱情相信爱情并拥有爱情。", //专辑的描述
    // "user": "xusun000", //专辑的创建者姓名
    // "head": "", //专辑的创建者头像
    // "user_id": 240329, //专辑的创建者ID
    // "list_id": 240329, //专辑ID
    // "subs_num": 56, //专辑订阅数
    // "subs_txt": "主题", //专辑相关备注
    // "tags": ["社会", "人物", "故事", "人性", "爱与和平"], //专辑的标签
    // "type": 2, //0-黑 1-红 2-白
    // "isShadow": false, //true-阴影 false-无阴影
  };
  bool? removeMargin;
  Collection({
    Key? key,
    this.data,
    this.removeMargin,
  }) : super(key: key);

  @override
  State<Collection> createState() => _CollectionState();
}

class _CollectionState extends State<Collection> {
  List<Widget> _buildTag() {
    List<Widget> tmp = [];
    widget.data!["tags"].forEach((element) {
      tmp.add(Container(
        padding: EdgeInsets.symmetric(horizontal: 11, vertical: 4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
            stops: [0, 1],
            colors: widget.data!["type"] == 2
                ? (Provider.of<ColorProvider>(context).isDark
                    ? [Color(0x11F6F6F6), Color(0x18F6F6F6)]
                    : [Color(0xFFF6F6F6), Color(0xFFF6F6F6)])
                : [
                    Color.fromRGBO(255, 255, 255, 0.08),
                    Color.fromRGBO(255, 255, 255, 0.1)
                  ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
        child: Text(
          element,
          style: XSTextStyle(
            context: context,
            color: widget.data!["type"] == 2
                ? (Provider.of<ColorProvider>(context).isDark
                    ? os_dark_dark_white
                    : Color(0xFF313131))
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
      tag: widget.data!["list_id"].toString() +
          widget.data!["type"].toString(), //Hero标志
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: widget.removeMargin ?? true
              ? null
              : EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.centerRight,
                stops: [0, 1],
                colors: [
                  [
                    Provider.of<ColorProvider>(context).isDark
                        ? Color(0xFF262B37)
                        : Color(0xFF262B37),
                    (Provider.of<ColorProvider>(context).isDark
                        ? Color(0xFF262B37)
                        : Color(0xFF536174))
                  ],
                  [
                    (Provider.of<ColorProvider>(context).isDark
                        ? Color(0xFFEF3615)
                        : Color(0xFFE83C2D)),
                    (Provider.of<ColorProvider>(context).isDark
                        ? Color(0xFFFF5D41)
                        : Color(0xFFFA6E54))
                  ],
                  Provider.of<ColorProvider>(context).isDark
                      ? [Color(0xFF313131), Color(0xFF373737)]
                      : [Color(0xFFFFFFFF), Color(0xFFFFFFFF)],
                ][widget.data!["type"]]),
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
                  (Provider.of<ColorProvider>(context).isDark
                      ? os_svg(path: "lib/img/quote.svg")
                      : os_svg(path: "lib/img/quote_dark.svg")),
                ][widget.data!["type"]],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.data!["name"].toString(),
                            overflow: TextOverflow.ellipsis,
                            style: XSTextStyle(
                              context: context,
                              color: widget.data!["type"] == 2
                                  ? (Provider.of<ColorProvider>(context).isDark
                                      ? os_dark_white
                                      : Color(0xFF272C38))
                                  : os_white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Container(width: 7.5),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 7.5, vertical: 3),
                        decoration: BoxDecoration(
                          color: widget.data!["type"] == 2
                              ? (Provider.of<ColorProvider>(context).isDark
                                  ? Color(0x33FFFFFF)
                                  : Color.fromRGBO(0, 0, 0, 0.07))
                              : Color.fromRGBO(255, 255, 255, 0.15),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Text(
                          "${widget.data!["subs_txt"] ?? "主题数"}: ${widget.data!["subs_num"]}",
                          style: XSTextStyle(
                            context: context,
                            color: widget.data!["type"] == 2
                                ? (Provider.of<ColorProvider>(context).isDark
                                    ? os_dark_white
                                    : os_dark_back)
                                : os_white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(height: 5),
                  ...(widget.data!["desc"].toString().trim() == ""
                      ? []
                      : [
                          Container(height: 2.5),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              widget.data!["desc"],
                              style: XSTextStyle(
                                context: context,
                                color: widget.data!["type"] == 2
                                    ? (Provider.of<ColorProvider>(context)
                                            .isDark
                                        ? os_dark_dark_white
                                        : Color(0xFF526073))
                                    : Color.fromRGBO(255, 255, 255, 0.8),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ]),
                  Container(height: 7.5),
                  ...(_buildTag().length == 0
                      ? []
                      : [
                          Container(height: 2.5),
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
                        ]),
                  Container(
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
                                imageUrl: widget.data!["head"],
                                width: 20,
                                height: 20,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: widget.data!["type"] == 2
                                      ? Color.fromRGBO(0, 0, 0, 0.1)
                                      : Color.fromRGBO(255, 255, 255, 0.6),
                                ),
                              ),
                            ),
                            Container(width: 7.5),
                            Text(
                              widget.data!["user"],
                              style: XSTextStyle(
                                context: context,
                                color: widget.data!["type"] == 2
                                    ? (Provider.of<ColorProvider>(context)
                                            .isDark
                                        ? os_dark_dark_white
                                        : Color(0xFF767676))
                                    : Color.fromRGBO(255, 255, 255, 0.8),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            toUserSpace(context, widget.data!["user_id"]);
                          },
                          child: Transform.translate(
                            offset: Offset(7.5, 0),
                            child: Row(
                              children: [
                                Text(
                                  "个人首页",
                                  style: XSTextStyle(
                                    context: context,
                                    fontSize: 14,
                                    color: widget.data!["type"] == 2
                                        ? Color(0xFF9a9a9a)
                                        : Color.fromRGBO(255, 255, 255, 0.5),
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: widget.data!["type"] == 2
                                      ? Color(0xFF9a9a9a)
                                      : Color.fromRGBO(255, 255, 255, 0.5),
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
