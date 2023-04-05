import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/home_desktop_mode.dart';
import 'package:offer_show/asset/showPop.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/outer/cached_network_image/cached_image_widget.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/mid_request.dart';
import 'package:html/dom.dart' as dom;
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

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
  bool loading = true;

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
    setState(() {
      loading = false;
    });
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
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left_outlined,
            color: Provider.of<ColorProvider>(context).isDark
                ? os_dark_dark_white
                : os_black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "道具商店",
          style: TextStyle(
            color: Provider.of<ColorProvider>(context).isDark
                ? os_dark_white
                : os_black,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
        actions: [],
        backgroundColor:
            Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
      ),
      backgroundColor:
          Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
      body: loading
          ? ListView(
              children: [BottomLoading()],
            )
          : ListView(
              children: [
                ...(list_item.map((e) {
                  return GoodCard(data: e);
                }).toList()),
              ],
            ),
    );
  }
}

class PopChat extends StatefulWidget {
  ShopItem data;
  PopChat({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  State<PopChat> createState() => _PopChatState();
}

class _PopChatState extends State<PopChat> {
  int now_price = 0;
  int total_water = 0;
  int purchase_num = 1;
  int weight = 0;
  int available_space = 0;
  int remain_num = 0;
  String remark = "";
  String formhash = "";
  String item_sku = "";
  bool loading = true;

  buyItem() async {
    Map m = {
      "formhash": formhash,
      "operation": "buy",
      "mid": item_sku,
      "magicnum": purchase_num,
      "operatesubmit": "yes",
    };
    Response tmp = await Api().buyItem(m);
    dom.Document doc = dom.Document.html(tmp.data.toString());
    var msg = await doc
        .getElementById("messagetext")
        .getElementsByTagName("p")[0]
        .innerHtml
        .split("<script")[0];
    if (!msg.contains("抱歉")) {
      Navigator.pop(context);
    }
    Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.CENTER,
    );
    setState(() {});
  }

  getData() async {
    Response res = await XHttp().pureHttpWithCookie(
      url: widget.data.url,
      hadCookie: true,
    );
    Response formhash_res = await XHttp().pureHttpWithCookie(
      url: "https://bbs.uestc.edu.cn/home.php?mod=magic&action=shop",
      hadCookie: true,
    );
    try {
      String html_txt = res.data.toString();
      String formhash_res_txt = formhash_res.data.toString();

      dom.Document html_doc = dom.Document.html(html_txt);
      dom.Document formhash_res_doc = dom.Document.html(formhash_res_txt);

      now_price = int.parse(html_doc.getElementById("discountprice").innerHtml);
      total_water = int.parse(
        html_doc
            .getElementsByClassName("bbda")[0]
            .innerHtml
            .split("我目前有水滴 ")[1]
            .split(" 滴")[0],
      );
      weight = int.parse(html_doc.getElementById("magicweight").innerHtml);
      available_space = int.parse(
        html_doc
            .getElementsByClassName("bbda")[0]
            .innerHtml
            .split("我的道具包可用容量 ")[1]
            .split("</p>")[0],
      );
      html_doc.getElementsByTagName("p").forEach((element) {
        if (element.innerHtml.contains("库存")) {
          remain_num = int.parse(
            element.getElementsByTagName("span")[0].innerHtml,
          );
        }
      });
      remark = html_doc.getElementsByClassName("xi1 mtn")[0].innerHtml;
      formhash_res_doc.getElementsByTagName("input").forEach((element) {
        if (element.attributes["name"] == "formhash") {
          formhash = element.attributes["value"];
        }
      });
      item_sku = widget.data.img.split("magic/")[1].split(".gif")[0];
    } catch (e) {}
    setState(() {
      loading = false;
    });
    print(MediaQuery.of(context).size.height);
  }

  TextStyle titleStyle() {
    return TextStyle(
      color: Provider.of<ColorProvider>(context).isDark
          ? os_dark_dark_white
          : os_black,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
  }

  changeNum(int changeNum) {
    if (changeNum < 0 && purchase_num <= 1) {
      return;
    }
    if (changeNum > 0) {
      if (total_water - purchase_num * now_price < now_price) {
        return;
      }
      if (available_space - weight * purchase_num < weight) {
        return;
      }
      if (remain_num - purchase_num < 1) {
        return;
      }
    }
    purchase_num += changeNum;
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Container(
            padding: EdgeInsets.symmetric(vertical: 100),
            child: Center(
              child: CircularProgressIndicator(
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_dark_white
                    : os_dark_back,
              ),
            ),
          )
        : Container(
            height: MediaQuery.of(context).size.height - 100,
            child: ListView(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              children: getWidgets(),
            ),
          );
  }

  List<Widget> getWidgets() {
    return [
      Container(height: 30),
      Text(
        "请确认你的订单",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Provider.of<ColorProvider>(context).isDark
              ? os_dark_white
              : os_black,
          fontSize: 30,
          fontWeight: FontWeight.w900,
        ),
      ),
      Container(height: 15),
      Text(
        "水滴并非实体/数字货币，仅能在本论坛内流通，不能与实体/数字货币兑换",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Provider.of<ColorProvider>(context).isDark
              ? os_dark_white
              : os_black,
        ),
      ),
      Container(height: 20),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        decoration: BoxDecoration(
          color: Provider.of<ColorProvider>(context).isDark
              ? os_dark_back
              : os_grey,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: widget.data.img,
              width: 40,
              height: 40,
            ),
            Container(width: 10),
            DefaultTextStyle(
              style: TextStyle(
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_dark_white
                    : Color(0xff575757),
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.data.name, style: titleStyle()),
                  Container(height: 3),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        color: os_red,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.lineThrough,
                      ),
                      text: widget.data.price.toString(),
                      children: [
                        TextSpan(
                          text: " 水滴/张（原价）",
                          style: TextStyle(
                            color: Provider.of<ColorProvider>(context).isDark
                                ? os_dark_dark_white
                                : Color(0xff575757),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(height: 2),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        color: Provider.of<ColorProvider>(context).isDark
                            ? os_dark_white
                            : os_red,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      text: now_price.toString(),
                      children: [
                        TextSpan(
                          text: " 水滴/张（折扣价）",
                          style: TextStyle(
                            color: Color(0xff575757),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(height: 2),
                  Text(
                    "我目前有${total_water}水滴 -> ${total_water - purchase_num * now_price}水滴",
                  ),
                  Container(height: 12),
                  Text("重量", style: titleStyle()),
                  Container(height: 3),
                  Text("${weight}"),
                  Container(height: 12),
                  Text("背包剩余容量", style: titleStyle()),
                  Container(height: 3),
                  Text(
                    "${available_space} -> ${available_space - weight * purchase_num}",
                  ),
                  Container(height: 12),
                  Text("库存", style: titleStyle()),
                  Container(height: 3),
                  Text(
                    "${remain_num} -> ${remain_num - purchase_num}",
                  ),
                  Container(height: 12),
                  remark == "" ? Container() : Text("备注", style: titleStyle()),
                  remark == "" ? Container() : Container(height: 3),
                  remark == ""
                      ? Container()
                      : Text(
                          "${remark}",
                        )
                ],
              ),
            ),
          ],
        ),
      ),
      Container(height: 10),
      Row(
        children: [
          Bounce(
            onPressed: () {
              changeNum(-1);
            },
            duration: Duration(milliseconds: 100),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_back
                    : os_grey,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                Icons.remove,
                size: 18,
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_dark_white
                    : os_black,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              decoration: BoxDecoration(
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_back
                    : os_grey,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  purchase_num.toString(),
                  style: TextStyle(
                    color: Provider.of<ColorProvider>(context).isDark
                        ? os_dark_dark_white
                        : os_black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Bounce(
            onPressed: () {
              changeNum(1);
            },
            duration: Duration(milliseconds: 100),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_back
                    : os_grey,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                Icons.add,
                size: 18,
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_dark_white
                    : os_black,
              ),
            ),
          ),
        ],
      ),
      Container(height: 20),
      myInkWell(
        tap: buyItem,
        radius: 15,
        color: os_deep_blue,
        widget: Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              "确认",
              style: TextStyle(
                color: os_white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      Container(height: 20),
    ];
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
  showChat() async {
    showPop(context, [
      PopChat(data: widget.data),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
        child: myInkWell(
          radius: 15,
          color: Provider.of<ColorProvider>(context).isDark
              ? os_light_dark_card
              : os_white,
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
                                  color:
                                      Provider.of<ColorProvider>(context).isDark
                                          ? os_dark_white
                                          : Colors.black,
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
                                        color:
                                            Provider.of<ColorProvider>(context)
                                                    .isDark
                                                ? os_dark_white
                                                : os_red,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                      text: " 水滴/张",
                                      style: TextStyle(
                                        color:
                                            Provider.of<ColorProvider>(context)
                                                    .isDark
                                                ? os_dark_dark_white
                                                : os_black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    )
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
                      SizedBox(width: 93),
                      myInkWell(
                        radius: 15,
                        color:
                            widget.data.soldOut ? os_black_opa : os_deep_blue,
                        tap: () {
                          if (!widget.data.soldOut) showChat();
                        },
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
                                  color:
                                      Provider.of<ColorProvider>(context).isDark
                                          ? os_dark_white
                                          : (widget.data.soldOut
                                              ? os_light_dark_card
                                              : os_white),
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
                    color: Provider.of<ColorProvider>(context).isDark
                        ? Color(0x06ffffff)
                        : Color(0x06000000),
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
                              color: Provider.of<ColorProvider>(context).isDark
                                  ? os_white
                                  : Color(0xff646d80),
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
