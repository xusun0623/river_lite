import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/data.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/components/byxusun.dart';
import 'package:offer_show/components/occu.dart';
import 'package:offer_show/page/home_component/HomeSearchRect.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

import 'HomeFilter.dart';

class HomeSecondPage extends StatefulWidget {
  @override
  _HomeSecondPageState createState() => _HomeSecondPageState();
}

class _HomeSecondPageState extends State<HomeSecondPage> {
  var salaryData = [];

  @override
  void initState() {
    super.initState();
    new Future.delayed(Duration.zero, () {
      Provider.of<HomePartSalarys>(context, listen: false)
          .getPartSalary(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    FilterSchool provider = Provider.of<FilterSchool>(context);
    HomePartSalarys providerPartHome = Provider.of<HomePartSalarys>(context);

    return Container(
      color: os_back,
      child: EasyRefresh(
        header: MaterialHeader(),
        onRefresh: () async {
          Provider.of<FilterSchool>(context, listen: false).close();
          Provider.of<FilterSchool>(context, listen: false).mainIndex = 0;
          Provider.of<FilterSchool>(context, listen: false).tipIndex1 = 0;
          Provider.of<FilterSchool>(context, listen: false).tipIndex2 = 0;
          return await Provider.of<HomePartSalarys>(context, listen: false)
              .getPartSalary(context);
        },
        child: ListView(
          children: [
            HomeSearchRect(),
            provider.isOpen
                ? HomeFilter(
                    filter: () {
                      providerPartHome.getPartSalary(context);
                      provider.close();
                    },
                  )
                : Container(),
            os_svg(
              show: !providerPartHome.getDone,
              width: os_width * 0.98,
              height: os_width * 1.96,
              path: "lib/img/home-skelon.svg",
            ),
            providerPartHome.column,
            byxusun(show: true, txt: "数据有限，更多复杂查询请使用+号来组合查询。"),
            occu(),
          ],
        ),
      ),
    );
  }
}
