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

class HomeFirstPage extends StatefulWidget {
  @override
  _HomeFirstPageState createState() => _HomeFirstPageState();
}

class _HomeFirstPageState extends State<HomeFirstPage> {
  var salaryData = [];

  @override
  void initState() {
    super.initState();
    new Future.delayed(Duration.zero, () {
      Provider.of<HomeSchoolSalarys>(context, listen: false)
          .getHomeSalary(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    FilterSchool provider = Provider.of<FilterSchool>(context);
    HomeSchoolSalarys provider_school_home =
        Provider.of<HomeSchoolSalarys>(context);

    return Container(
      color: os_back,
      child: EasyRefresh(
        header: MaterialHeader(),
        onRefresh: () async {
          Provider.of<FilterSchool>(context, listen: false).close();
          Provider.of<FilterSchool>(context, listen: false).mainIndex = 0;
          Provider.of<FilterSchool>(context, listen: false).tipIndex1 = 0;
          Provider.of<FilterSchool>(context, listen: false).tipIndex2 = 0;
          return await Provider.of<HomeSchoolSalarys>(context, listen: false)
              .getHomeSalary(context);
        },
        child: provider_school_home.column,
      ),
    );
  }
}
