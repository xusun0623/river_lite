import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:offer_show/asset/bigScreen.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/page/collection_tab/collection_tab.dart';
import 'package:offer_show/page/column_waterfall/column_waterfall.dart';
import 'package:offer_show/page/essence/essence.dart';
import 'package:offer_show/page/home/homeNew.dart';
import 'package:offer_show/page/home/scale_tab.dart';
import 'package:offer_show/page/hot/homeHotNoScaffold.dart';
import 'package:offer_show/page/new_reply/homeNewReply.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> with TickerProviderStateMixin {
  TabController tabController;
  List<Tab> tabs = [
    Tab(text: "板块"),
    Tab(text: "最新"),
    Tab(text: "回复"),
    Tab(text: "热门"),
    Tab(text: "精华"),
    Tab(text: "专辑"),
  ];
  List<Tab> tabs_desktop = [
    Tab(
      child: Row(
        children: [
          Icon(
            Icons.view_array_outlined,
            size: 18,
          ),
          Container(width: 5),
          Text("板块"),
        ],
      ),
    ),
    Tab(
      child: Row(
        children: [
          Icon(
            Icons.comment_bank_outlined,
            size: 18,
          ),
          Container(width: 5),
          Text("最新"),
        ],
      ),
    ),
    Tab(
      child: Row(
        children: [
          Icon(
            Icons.reply_rounded,
            size: 18,
          ),
          Container(width: 5),
          Text("回复"),
        ],
      ),
    ),
    Tab(
      child: Row(
        children: [
          Icon(
            Icons.local_fire_department_outlined,
            size: 18,
          ),
          Container(width: 5),
          Text("热门"),
        ],
      ),
    ),
    Tab(
      child: Row(
        children: [
          Icon(
            Icons.verified_user_outlined,
            size: 18,
          ),
          Container(width: 5),
          Text("精华"),
        ],
      ),
    ),
    Tab(
      child: Row(
        children: [
          Icon(
            Icons.collections_bookmark_outlined,
            size: 18,
          ),
          Container(width: 5),
          Text("专辑"),
        ],
      ),
    ),
  ];

  @override
  void initState() {
    tabController = TabController(
      length: tabs.length,
      initialIndex: 1,
      vsync: this,
    );
    super.initState();
  }

  ScaleTabBar _getMyTabBar() {
    return ScaleTabBar(
      labelPadding: EdgeInsets.symmetric(horizontal: 8),
      isScrollable: true,
      splashBorderRadius: BorderRadius.all(Radius.circular(5)),
      labelColor: Provider.of<ColorProvider>(context).isDark
          ? os_dark_white
          : Colors.black87,
      unselectedLabelColor: Color(0xFF7A7A7A),
      indicator: TabSizeIndicator(
        wantWidth: 10,
        borderSide: BorderSide(
          width: 3.0,
          color: Provider.of<ColorProvider>(context).isDark
              ? os_dark_white
              : os_dark_back,
        ),
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 16,
        fontFamily: "微软雅黑",
      ),
      labelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        fontFamily: "微软雅黑",
      ),
      tabs: tabs,
      onTap: (index) {
        setState(() {
          Provider.of<HomeRefrshProvider>(
            context,
            listen: false,
          ).index = index;
          Provider.of<HomeRefrshProvider>(
            context,
            listen: false,
          ).refresh();
        });
      },
      controller: tabController,
    );
  }

  TabBar _getMyDesktopTabBar() {
    return TabBar(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      labelPadding: EdgeInsets.symmetric(horizontal: 18),
      isScrollable: true,
      labelColor: Provider.of<ColorProvider>(context).isDark
          ? os_dark_white
          : os_deep_blue,
      unselectedLabelColor: Color.fromARGB(255, 106, 114, 133),
      indicator: TabSizeIndicator(
        wantWidth: 90,
        borderSide: BorderSide(
          width: 37,
          color: Provider.of<ColorProvider>(context).isDark
              ? os_dark_white
              : os_deep_blue_opa,
        ),
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 16,
        fontFamily: "微软雅黑",
      ),
      labelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        fontFamily: "微软雅黑",
      ),
      tabs: tabs_desktop,
      onTap: (index) {
        setState(() {
          Provider.of<HomeRefrshProvider>(
            context,
            listen: false,
          ).index = index;
          Provider.of<HomeRefrshProvider>(
            context,
            listen: false,
          ).refresh();
        });
      },
      controller: tabController,
    );
  }

  AppBar _getAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor:
          Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
      foregroundColor:
          Provider.of<ColorProvider>(context).isDark ? os_dark_white : os_black,
      leading: Container(),
      leadingWidth: 0,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, "/search", arguments: 0);
          },
          icon: os_svg(
            path: Provider.of<ColorProvider>(context).isDark
                ? "lib/img/search_white.svg"
                : "lib/img/search.svg",
            width: 24,
            height: 24,
          ),
        ),
        Container(width: 5),
      ],
      centerTitle: isDesktop() ? true : null,
      title: Container(
        width: isDesktop() ? 600 : 300,
        height: 60,
        child: isDesktop() ? _getMyDesktopTabBar() : _getMyTabBar(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      backgroundColor:
          Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
      body: Container(
        child: TabBarView(
          physics: CustomTabBarViewScrollPhysics(),
          controller: tabController,
          children: [
            ColumnWaterfall(),
            HomeNew(),
            HomeNewReply(),
            HotNoScaffold(),
            Essence(),
            CollectionTab(),
          ],
        ),
      ),
    );
  }
}

class CustomTabBarViewScrollPhysics extends ScrollPhysics {
  const CustomTabBarViewScrollPhysics({ScrollPhysics parent})
      : super(parent: parent);

  @override
  CustomTabBarViewScrollPhysics applyTo(ScrollPhysics ancestor) {
    return CustomTabBarViewScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 50,
        stiffness: 100,
        damping: 0.8,
      );
}
