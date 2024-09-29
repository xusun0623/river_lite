import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/cookie.dart';
import 'package:offer_show/asset/home_desktop_mode.dart';
import 'package:offer_show/asset/xs_textstyle.dart';
import 'package:offer_show/components/newNaviBar.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class WaterTotal extends StatefulWidget {
  WaterTotal({Key? key}) : super(key: key);

  @override
  State<WaterTotal> createState() => _WaterTotalState();
}

class _WaterTotalState extends State<WaterTotal> {
  @override
  void initState() {
    getWebCookie();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Baaaar(
      color:
          Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Provider.of<ColorProvider>(context).isDark
              ? os_dark_back
              : os_back,
          elevation: 0,
          foregroundColor: Provider.of<ColorProvider>(context).isDark
              ? os_dark_white
              : os_black,
          centerTitle: true,
          title: Text(
            "水滴",
            style: XSTextStyle(
              context: context,
              fontSize: 16,
            ),
          ),
          actions: [],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.chevron_left_rounded,
              color: Provider.of<ColorProvider>(context).isDark
                  ? os_dark_dark_white
                  : os_dark_back,
            ),
          ),
        ),
        backgroundColor:
            Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
        body: DismissiblePage(
          backgroundColor: Provider.of<ColorProvider>(context).isDark
              ? os_dark_back
              : os_back,
          direction: DismissiblePageDismissDirection.startToEnd,
          onDismissed: () {
            Navigator.of(context).pop();
          },
          child: ListView(
            children: [
              NavigatorCard(
                title: "水滴答题",
                tip: "自动答题，水滴多多",
                url: "/question",
                icon: Icons.question_answer_outlined,
                color: os_wonderful_color[0],
              ),
              NavigatorCard(
                title: "水滴任务",
                tip: "领取、查看任务进度",
                url: "/water_task",
                icon: Icons.task_alt_outlined,
                color: os_wonderful_color[1],
              ),
              NavigatorCard(
                title: "积分记录",
                tip: "水滴收支详情",
                url: "/water_inout_detail",
                icon: Icons.format_list_bulleted_sharp,
                color: os_wonderful_color[4],
              ),
              Container(height: 20),
              NavigatorCard(
                title: "我的背包",
                tip: "点击查看所有物品",
                url: "/bag",
                icon: Icons.shopping_bag_outlined,
                color: os_wonderful_color[2],
              ),
              NavigatorCard(
                title: "道具商店",
                tip: "购买道具",
                url: "/shop",
                icon: Icons.shopping_cart_outlined,
                color: os_wonderful_color[1],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavigatorCard extends StatefulWidget {
  String? title;
  String? tip;
  String? url;
  IconData? icon;
  Color? color;
  NavigatorCard({
    Key? key,
    this.title,
    this.tip,
    this.url,
    this.icon,
    this.color,
  }) : super(key: key);

  @override
  State<NavigatorCard> createState() => _NavigatorCardState();
}

class _NavigatorCardState extends State<NavigatorCard> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, widget.url!);
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          decoration: BoxDecoration(
              color: Provider.of<ColorProvider>(context).isDark
                  ? os_light_dark_card
                  : os_white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Color(0x07000000),
                  blurRadius: 10,
                  offset: Offset(3, 3),
                ),
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    widget.icon,
                    size: 30,
                    color: widget.color,
                  ),
                  Container(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title!,
                        style: XSTextStyle(
                          context: context,
                          fontSize: 16,
                          color: Provider.of<ColorProvider>(context).isDark
                              ? os_dark_white
                              : Color(0xFF333344),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(height: 5),
                      Text(
                        widget.tip!,
                        style: XSTextStyle(
                          context: context,
                          fontSize: 14,
                          color: Provider.of<ColorProvider>(context).isDark
                              ? os_dark_dark_white
                              : os_deep_grey,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Container(width: 5),
                  Icon(
                    Icons.chevron_right,
                    size: 24,
                    color: Provider.of<ColorProvider>(context).isDark
                        ? os_dark_dark_white
                        : os_light_light_dark_card,
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
