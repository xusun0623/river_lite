import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/page/collection_tab/collection_tab.dart';
import 'package:offer_show/page/essence/essence.dart';
import 'package:offer_show/page/home/homeNew.dart';
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

  @override
  void initState() {
    tabController = TabController(
      length: 5,
      vsync: this,
    );
    super.initState();
  }

  TabBar _getMyTabBar() {
    return TabBar(
      labelPadding: EdgeInsets.symmetric(horizontal: 12),
      isScrollable: true,
      splashBorderRadius: BorderRadius.all(Radius.circular(5)),
      labelColor: Provider.of<ColorProvider>(context).isDark
          ? os_dark_white
          : Colors.black87,
      unselectedLabelColor: Color(0xFF7A7A7A),
      unselectedLabelStyle: TextStyle(
        fontSize: 16,
      ),
      indicator: TabSizeIndicator(
        wantWidth: 20,
        borderSide: BorderSide(
            width: 3.0,
            color: Provider.of<ColorProvider>(context).isDark
                ? os_dark_white
                : Colors.black87),
      ),
      labelStyle: TextStyle(
        fontWeight: FontWeight.bold,
      ),
      tabs: [
        Tab(text: "新发表"),
        Tab(text: "新回复"),
        Tab(text: "热门"),
        Tab(text: "精华"),
        Tab(text: "专辑"),
      ],
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
            Navigator.pushNamed(context, "/search");
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
      title: Container(
        width: 300,
        height: 60,
        child: _getMyTabBar(),
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
