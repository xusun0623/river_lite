import 'dart:math';

import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/components/scaffold.dart';
import 'package:offer_show/page/search_component/SearchInput.dart';
import 'package:offer_show/page/search_component/SearchPlaceHolder.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class OSSearch extends StatefulWidget {
  @override
  _OSSearchState createState() => _OSSearchState();
}

class _OSSearchState extends State<OSSearch> {
  @override
  void initState() {
    super.initState();
    // new Future.delayed(Duration.zero, () {
    //   SearchProvider provider =
    //       Provider.of<SearchProvider>(context, listen: false);
    //   provider.getSearchSalary();
    // });
  }

  @override
  Widget build(BuildContext context) {
    SearchProvider provider = Provider.of<SearchProvider>(context);
    EdgeInsets padding = MediaQuery.of(context).padding;
    double top = max(padding.top, EdgeInsets.zero.top);
    return Material(
      color: os_back,
      child: ListView(
        children: [
          Container(height: top),
          SearchInput(),
          SearchPlaceholder(),
          provider.column,
        ],
      ),
    );
  }
}
