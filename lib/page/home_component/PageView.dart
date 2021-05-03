import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/data.dart';
import 'package:offer_show/components/salary.dart';
import 'package:offer_show/page/home_component/HomeFilter.dart';
import 'package:offer_show/page/home_component/HomeSearchRect.dart';
import 'package:offer_show/page/home_component/HomeSecondPage.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

import 'HomeFirstPage.dart';

class HomePageView extends StatefulWidget {
  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  @override
  Widget build(BuildContext context) {
    FilterSchool provider_filter = Provider.of<FilterSchool>(context);
    HomeTabIndex provider = Provider.of<HomeTabIndex>(context);
    return PageView(
      physics: ClampingScrollPhysics(),
      controller: provider.controller,
      onPageChanged: (index) {
        provider.setIndex(index);
      },
      children: [
        HomeFirstPage(),
        HomeSecondPage(),
        Container(
          color: os_back,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.explore_rounded,
                  size: 100,
                  color: os_middle_grey,
                ),
                Container(height: 20),
                Text(
                  "关注「校招薪水」微信公众号\n获取一手薪资信息。",
                  style: TextStyle(
                    color: os_middle_grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
