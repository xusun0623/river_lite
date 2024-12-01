import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/dom.dart' as dom;
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/home_desktop_mode.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/showPop.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/asset/xs_textstyle.dart';
import 'package:offer_show/components/empty.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/util/mid_request.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class BagItem {
  String? img;
  String? name;
  late String desc;
  int? count;
  int? weight;
  String? drop_url;

  BagItem(
    String tmp_img,
    String tmp_name,
    String tmp_desc,
    int tmp_count,
    int tmp_weight,
    String? tmp_drop_url,
  ) {
    img = tmp_img;
    name = tmp_name;
    desc = tmp_desc;
    count = tmp_count;
    weight = tmp_weight;
    drop_url = tmp_drop_url;
  }
}

class MyBag extends StatefulWidget {
  const MyBag({Key? key}) : super(key: key);

  @override
  State<MyBag> createState() => _MyBagState();
}

class _MyBagState extends State<MyBag> {
  List<BagItem> bagItems = [];
  String? formhash = "";
  bool loading = true;

  getData() async {
    try {
      Response formhash_res = await XHttp().pureHttpWithCookie(
        url: "https://bbs.uestc.edu.cn/home.php?mod=magic&action=shop",
        hadCookie: true,
      );
      Response tmp = await XHttp().pureHttpWithCookie(
        url: "https://bbs.uestc.edu.cn/home.php?mod=magic&action=mybox",
        hadCookie: true,
      );
      String formhash_res_txt = formhash_res.data.toString();
      dom.Document doc = dom.Document.html(tmp.data.toString());

      dom.Document formhash_res_doc = dom.Document.html(formhash_res_txt);
      formhash_res_doc.getElementsByTagName("input").forEach((element) {
        if (element.attributes["name"] == "formhash") {
          formhash = element.attributes["value"];
        }
      });
      bagItems = [];
      doc.getElementsByClassName("mtm")[0].getElementsByTagName("li").forEach(
        (element) {
          bagItems.add(BagItem(
            "https://bbs.uestc.edu.cn/" +
                element.getElementsByTagName("img")[0].attributes["src"]!,
            element.getElementsByTagName("strong")[0].innerHtml,
            element.getElementsByClassName("tip_c")[0].innerHtml,
            int.parse(element.getElementsByTagName("font")[0].innerHtml),
            int.parse(element.getElementsByTagName("font")[1].innerHtml),
            element
                .getElementsByTagName(
                    "a")[element.getElementsByTagName("a").length - 1]
                .attributes["href"],
          ));
        },
      );
    } catch (e) {
      print("$e");
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
        centerTitle: true,
        title: Text(
          "我的背包",
          style: XSTextStyle(
            context: context,
            color: Provider.of<ColorProvider>(context).isDark
                ? os_dark_white
                : os_black,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.chevron_left_rounded,
            color: Provider.of<ColorProvider>(context).isDark
                ? os_dark_white
                : os_black,
          ),
        ),
        actions: [],
      ),
      backgroundColor:
          Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
      body: DismissiblePage(
        backgroundColor:
            Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
        direction: DismissiblePageDismissDirection.startToEnd,
        onDismissed: () {
          Navigator.of(context).pop();
        },
        child: Container(
          child: loading
              ? ListView(
                  children: [
                    BottomLoading(),
                  ],
                )
              : ListView(
                  children: [
                    bagItems.length == 0
                        ? Empty(txt: "这里是一颗空的星球")
                        : Container(),
                    ...(bagItems
                        .map((e) => BagWidget(
                              data: e,
                              formhash: formhash,
                              refresh: () {
                                getData();
                              },
                            ))
                        .toList()),
                  ],
                ),
        ),
      ),
    );
  }
}

class BagWidget extends StatefulWidget {
  BagItem? data;
  String? formhash;
  Function? refresh;
  BagWidget({
    Key? key,
    this.data,
    this.formhash,
    this.refresh,
  }) : super(key: key);

  @override
  State<BagWidget> createState() => _BagWidgetState();
}

class _BagWidgetState extends State<BagWidget> {
  showWaterNum(int cnt) async {
    showPop(
      context,
      [Celebration(count: cnt)],
    );
  }

  guagua() async {
    // showWaterNum(30);
    // return;
    String magicid = widget.data!.drop_url!.split("magicid=")[1];
    showToast(context: context, type: XSToast.loading);
    Response tmp = await XHttp().pureHttpWithCookie(
      hadCookie: true,
      url:
          "https://bbs.uestc.edu.cn/home.php?mod=magic&action=mybox&operation=use&magicid=3&infloat=yes&handlekey=magics&inajax=1&ajaxtarget=fwin_content_magics",
    );
    hideToast();
    dom.Document doc = dom.Document.html(tmp.data.toString());
    String remain = doc
        .getElementsByClassName("pns xw0 cl")[0]
        .getElementsByClassName("xi1")[0]
        .innerHtml;
    showModal(
      context: context,
      title: "请确认",
      cont: remain,
      confirmTxt: "刮开此卡",
      confirm: () async {
        Response tmp = await XHttp().pureHttpWithCookie(
          hadCookie: true,
          url:
              "https://bbs.uestc.edu.cn/home.php?mod=magic&action=mybox&infloat=yes&inajax=1",
          param: {
            "formhash": widget.formhash,
            "handlekey": "magics",
            "operation": "use",
            "magicid": 3,
            "usesubmit": true,
            "operatesubmit": "yes",
          },
        );
        String ret = tmp.data.toString();
        //<?xml version="1.0" encoding="utf-8"?>
        // <root><![CDATA[<script type="text/javascript" reload="1">if(typeof errorhandle_magics=='function') {errorhandle_magics('恭喜您获得 水滴 10 滴', {'credit':'水滴 10 滴'});}hideWindow('magics');showDialog('恭喜您获得 水滴 10 滴', 'right', null, null, 0, null, null, null, null, null, null);</script>]]></root>

        RegExp regExp = RegExp(r"恭喜您获得 水滴 (\d+) 滴");
        Match? match = regExp.firstMatch(ret);
        if (match != null) {
          int receive_water_num = int.parse(match.group(1)!);
          showWaterNum(receive_water_num);
        }else{
          showToast(context: context, type: XSToast.none, txt: "领取失败");
        }
        widget.refresh!();
      },
    );
  }

  dropItem() async {
    await XHttp().pureHttpWithCookie(
      hadCookie: true,
      url:
          "https://bbs.uestc.edu.cn/home.php?mod=magic&action=mybox&infloat=yes&inajax=1",
      param: {
        "formhash": widget.formhash,
        "handlekey": "magics",
        "operation": "drop",
        "magicid": widget.data!.drop_url!.split("magicid=")[1],
        "magicnum": 1,
        "operatesubmit": "yes",
      },
    );
    Fluttertoast.showToast(
      msg: "操作成功",
      gravity: ToastGravity.CENTER,
    );
    widget.refresh!();
  }

  @override
  void initState() {
    super.initState();
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 39.75,
                          height: 39.75,
                          child: CachedNetworkImage(
                            imageUrl: widget.data!.img!,
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.data!.name!,
                              style: XSTextStyle(
                                context: context,
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
                                text: "数量",
                                style: XSTextStyle(
                                  context: context,
                                  color:
                                      Provider.of<ColorProvider>(context).isDark
                                          ? os_dark_dark_white
                                          : os_black,
                                  fontWeight: FontWeight.normal,
                                ),
                                children: [
                                  TextSpan(
                                    text: "${widget.data!.count}",
                                    style: XSTextStyle(
                                      context: context,
                                      color: Provider.of<ColorProvider>(context)
                                              .isDark
                                          ? os_white
                                          : os_red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "张，总重量",
                                    style: XSTextStyle(
                                      context: context,
                                      color: Provider.of<ColorProvider>(context)
                                              .isDark
                                          ? os_dark_dark_white
                                          : os_black,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${widget.data!.weight}",
                                    style: XSTextStyle(
                                      context: context,
                                      color: Provider.of<ColorProvider>(context)
                                              .isDark
                                          ? os_white
                                          : os_red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              style: XSTextStyle(
                                context: context,
                                color: os_black,
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    myInkWell(
                      radius: 15,
                      color: Provider.of<ColorProvider>(context).isDark
                          ? os_white_opa
                          : os_grey,
                      tap: () {
                        showModal(
                          confirm: dropItem,
                          context: context,
                          title: "请确认",
                          cont: "你是否要丢弃一张该道具，此操作不可逆，请谨慎操作（免得水货两空）",
                        );
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
                              "丢弃",
                              textAlign: TextAlign.right,
                              style: XSTextStyle(
                                context: context,
                                color:
                                    Provider.of<ColorProvider>(context).isDark
                                        ? os_dark_dark_white
                                        : os_dark_back,
                                fontSize: 14,
                                fontFamily: "PingFang SC",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    widget.data!.name != "刮刮卡"
                        ? Container()
                        : Container(width: 10),
                    widget.data!.name != "刮刮卡"
                        ? Container()
                        : myInkWell(
                            radius: 15,
                            color: Color(0xfff1bf65),
                            tap: guagua,
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
                                    "刮一刮",
                                    textAlign: TextAlign.right,
                                    style: XSTextStyle(
                                      context: context,
                                      color: Color(0xff571F11),
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
                            widget.data!.desc +
                                (widget.data!.name == "刮刮卡"
                                    ? "\n你将获得的水滴数量最少为1，最高为购买价格的1.5倍"
                                    : ""),
                            style: XSTextStyle(
                              context: context,
                              color: Provider.of<ColorProvider>(context).isDark
                                  ? os_dark_dark_white
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

class Celebration extends StatefulWidget {
  int? count;
  Celebration({
    Key? key,
    this.count,
  }) : super(key: key);

  @override
  State<Celebration> createState() => _CelebrationState();
}

class _CelebrationState extends State<Celebration> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: Dance(
            duration: Duration(seconds: 2),
            infinite: true,
            child: os_svg(
              width: 227,
              height: 321,
              path: "lib/img/celebration/ball.svg",
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 100,
          child: Bounce(
            duration: Duration(seconds: 2),
            infinite: true,
            child: os_svg(
              width: 136,
              height: 192,
              path: "lib/img/celebration/gift.svg",
            ),
          ),
        ),
        Positioned(
          top: 320,
          child: Pulse(
            duration: Duration(seconds: 2),
            infinite: true,
            child: os_svg(
              width: 192,
              height: 275,
              path: "lib/img/celebration/plane.svg",
            ),
          ),
        ),
        Positioned(
          top: 370,
          left: 160,
          child: Swing(
            duration: Duration(seconds: 2),
            infinite: true,
            child: os_svg(
              width: 143,
              height: 202,
              path: "lib/img/celebration/bag.svg",
            ),
          ),
        ),
        Positioned(
          top: 290,
          right: 0,
          child: Roulette(
            duration: Duration(seconds: 3),
            infinite: true,
            child: os_svg(
              width: 149,
              height: 210,
              path: "lib/img/celebration/camera.svg",
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 100,
          child: Column(
            children: [
              Container(height: 15),
              Container(
                width: 25,
                height: 3,
                decoration: BoxDecoration(
                  color: os_middle_grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(height: 50),
              Text(
                "恭喜你获得水滴数",
                style: XSTextStyle(
                  context: context,
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_white
                      : os_black,
                  fontSize: 22,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Container(height: 100),
              Text(
                widget.count.toString(),
                style: XSTextStyle(
                  context: context,
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_white
                      : os_black,
                  fontSize: 120,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
