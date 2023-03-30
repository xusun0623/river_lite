import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/home_desktop_mode.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/outer/cached_network_image/cached_image_widget.dart';
import 'package:offer_show/util/mid_request.dart';
import 'package:html/dom.dart' as dom;

class ShopItem {
  String url;
  String img;
  String name;
  String desc;
  int price;
  bool soldOut;
  ShopItem(
    String tmp_url,
    String tmp_img,
    String tmp_name,
    String tmp_desc,
    int tmp_price,
    bool tmp_soldOut,
  ) {
    url = tmp_url;
    img = tmp_img;
    name = tmp_name;
    desc = tmp_desc;
    price = tmp_price;
    soldOut = tmp_soldOut;
  }
}

class Shop extends StatefulWidget {
  const Shop({Key key}) : super(key: key);

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  List<ShopItem> list_item = [];

  getItems() async {
    Response res = await XHttp().pureHttpWithCookie(
      url: "https://bbs.uestc.edu.cn/home.php?mod=magic&action=shop",
    );
    String html_txt = res.data.toString();
    dom.Document html_doc = dom.Document.html(html_txt);
    dom.Element mtm = html_doc.getElementsByClassName("mtm")[0];
    List<dom.Element> lists = mtm.getElementsByTagName("li");
    list_item = [];
    lists.forEach((element) {
      bool soldOut =
          element.getElementsByClassName("mtn")[0].innerHtml.contains("此道具缺货");
      String url = soldOut
          ? "此道具缺货"
          : element
              .getElementsByClassName("mtn")[0]
              .getElementsByTagName("a")[0]
              .attributes["href"];
      String img = "https://bbs.uestc.edu.cn/" +
          element.getElementsByTagName("img")[0].attributes["src"];
      String name = element.getElementsByTagName("strong")[0].innerHtml;
      String desc = element.getElementsByClassName("tip_c")[0].innerHtml;
      int price = soldOut
          ? 0
          : int.parse(element.getElementsByClassName("xi1")[0].innerHtml);
      ShopItem i = ShopItem(url, img, name, desc, price, soldOut);
      list_item.add(i);
    });
    setState(() {});
    print("${list_item}");
  }

  @override
  void initState() {
    getItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: os_back,
      ),
      backgroundColor: os_back,
      body: ListView(
        children: [
          ...(list_item.map((e) {
            return GoodCard(data: e);
          }).toList()),
          Center(
            child: ElevatedButton(
              onPressed: () {
                getItems();
              },
              child: Text("测试"),
            ),
          ),
        ],
      ),
    );
  }
}

class GoodCard extends StatefulWidget {
  ShopItem data;
  GoodCard({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  State<GoodCard> createState() => _GoodCardState();
}

class _GoodCardState extends State<GoodCard> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
        child: myInkWell(
          radius: 15,
          tap: () {},
          widget: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 39.75,
                            height: 39.75,
                            child: CachedNetworkImage(
                              imageUrl: widget.data.img,
                              placeholder: (context, url) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0x11000000),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.data.name,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "${widget.data.price}",
                                      style: TextStyle(
                                        color: os_red,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(text: " 水滴/张")
                                  ],
                                ),
                                style: TextStyle(
                                  color: os_black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(width: 95),
                      myInkWell(
                        radius: 15,
                        color: widget.data.soldOut
                            ? Color(0xffb1b1b1)
                            : os_deep_blue,
                        tap: () {},
                        widget: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          height: 37,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.data.soldOut ? "此道具缺货" : "购买",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: "PingFang SC",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0x06000000),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SizedBox(
                          child: Text(
                            widget.data.desc,
                            style: TextStyle(
                              color: Color(0xff646d80),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
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
