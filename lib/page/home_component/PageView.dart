import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/page/home_component/HomeFilter.dart';
import 'package:offer_show/page/home_component/HomeSearchRect.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

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
        Container(
          color: os_color,
          child: EasyRefresh(
            header: MaterialHeader(),
            onRefresh: () {},
            child: ListView(
              children: [
                HomeSearchRect(),
                provider_filter.isOpen
                    ? HomeFilter(
                        filter: () {
                          print("Filter");
                          provider_filter.show();
                        },
                      )
                    : Container(),
              ],
            ),
          ),
        ),
        Container(
          color: os_red,
          child: EasyRefresh(
            header: MaterialHeader(),
            onRefresh: () {},
            child: ListView(
              children: [
                HomeSearchRect(),
              ],
            ),
          ),
        ),
        Container(
          color: os_deep_grey,
          child: Center(
            child: Text("hh"),
          ),
        ),
      ],
    );
  }
}
