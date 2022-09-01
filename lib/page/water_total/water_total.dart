import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/cookie.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class WaterTotal extends StatefulWidget {
  WaterTotal({Key key}) : super(key: key);

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
        elevation: 0,
        foregroundColor: Provider.of<ColorProvider>(context).isDark
            ? os_dark_white
            : os_black,
        centerTitle: true,
        title: Text(
          "水滴",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.chevron_left_rounded),
        ),
      ),
      backgroundColor:
          Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
      body: ListView(
        children: [
          NavigatorCard(
            title: "水滴答题",
            tip: "自动答题，水滴多多",
            url: "/question",
            img: "lib/img/water_total/1.svg",
          ),
          NavigatorCard(
            title: "水滴任务",
            tip: "进度查看，领取任务",
            url: "/water_task",
            img: "lib/img/water_total/2.svg",
          ),
          NavigatorCard(
            title: "积分记录",
            tip: "水滴明细，收支详情",
            url: "/water_inout_detail",
            img: "lib/img/water_total/3.svg",
          ),
        ],
      ),
    );
  }
}

class NavigatorCard extends StatefulWidget {
  String title;
  String tip;
  String url;
  String img;
  NavigatorCard({
    Key key,
    this.title,
    this.tip,
    this.url,
    this.img,
  }) : super(key: key);

  @override
  State<NavigatorCard> createState() => _NavigatorCardState();
}

class _NavigatorCardState extends State<NavigatorCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, widget.url);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
            color: Provider.of<ColorProvider>(context).isDark
                ? Color(0x33ffffff)
                : os_white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Provider.of<ColorProvider>(context).isDark
                        ? os_dark_white
                        : Color(0xFF333344),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(height: 3),
                Text(
                  widget.tip,
                  style: TextStyle(
                    fontSize: 14,
                    color: Provider.of<ColorProvider>(context).isDark
                        ? os_dark_dark_white
                        : os_deep_grey,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            os_svg(
              path: widget.img,
              // width: 80,
              height: 80,
            )
          ],
        ),
      ),
    );
  }
}
