import 'dart:math';

import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    SearchProvider provider = Provider.of<SearchProvider>(context);
    EdgeInsets padding = MediaQuery.of(context).padding;
    double top = max(padding.top, EdgeInsets.zero.top);
    return Material(
      color: os_back,
      child: Center(
          child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text("Content"))),
    );
  }
}
