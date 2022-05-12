import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/svg.dart';
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
    tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: os_back,
        foregroundColor: os_black,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/search");
            },
            icon: os_svg(
              path: "lib/img/search.svg",
              width: 24,
              height: 24,
            ),
          ),
          Container(width: 5),
        ],
        title: Container(
          width: 300,
          height: 60,
          child: TabBar(
            labelPadding: EdgeInsets.symmetric(horizontal: 12),
            isScrollable: true,
            splashBorderRadius: BorderRadius.all(Radius.circular(5)),
            labelColor: Colors.black87,
            unselectedLabelColor: Color(0xFF7A7A7A),
            unselectedLabelStyle: TextStyle(
              fontSize: 16,
            ),
            indicator: TabSizeIndicator(
              wantWidth: 20,
              borderSide: BorderSide(width: 3.0, color: Colors.black87),
            ),
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(text: "新发表"),
              Tab(text: "新回复"),
              Tab(text: "热门"),
              Tab(text: "精华"),
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
          ),
        ),
      ),
      backgroundColor: os_back,
      body: TabBarView(
        controller: tabController,
        children: [
          HomeNew(),
          HomeNewReply(),
          HotNoScaffold(),
          Essence(),
        ],
      ),
    );
  }
}
