import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';

class About extends StatefulWidget {
  About({Key key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: os_white,
        elevation: 0,
        foregroundColor: os_black,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.chevron_left_rounded),
        ),
      ),
      backgroundColor: os_white,
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Image.asset("lib/img/about/1.png"),
        ],
      ),
    );
  }
}
