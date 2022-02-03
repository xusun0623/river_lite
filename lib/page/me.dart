import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:offer_show/asset/svg.dart';

class Me extends StatefulWidget {
  @override
  _MeState createState() => _MeState();
}

class _MeState extends State<Me> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: os_svg(
          path: "lib/img/logo.svg",
        ),
      ),
    );
  }
}
