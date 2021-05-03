import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/components/occu.dart';
import 'package:offer_show/page/home_component/HeadTab.dart';
import 'package:offer_show/page/home_component/PageView.dart';
import 'package:offer_show/util/interface.dart';

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: os_back,
        elevation: 0.0,
        title: HeadTab(),
        actions: [
          IconButton(
            icon: Icon(
              Icons.share,
              color: os_black,
            ),
            onPressed: () {
              print("Share");
            },
          )
        ],
        leading: IconButton(
          icon: Icon(
            Icons.list,
            color: os_black,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      body: HomePageView(),
    );
  }
}
