import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/components/occu.dart';
import 'package:offer_show/components/scaffold.dart';

class Broke extends StatefulWidget {
  @override
  _BrokeState createState() => _BrokeState();
}

class _BrokeState extends State<Broke> {
  @override
  Widget build(BuildContext context) {
    return OSScaffold(
      // headerHeight: 200.0,
      onLoad: () async {
        print("onLoad");
        await Future.delayed(Duration(milliseconds: 300));
        return false;
      },
      onRefresh: () async {
        print("Refresh");
        return Future.delayed(Duration(milliseconds: 300));
      },
      body: Container(
        child: Column(
          children: [
            Card(),
            Card(),
            Card(),
            Card(),
          ],
        ),
      ),
    );
  }
}

class Card extends StatelessWidget {
  const Card({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: os_width,
      height: 200,
      decoration: BoxDecoration(
        color: os_color,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: new EdgeInsets.only(
        left: os_padding,
        right: os_padding,
        top: 5,
        bottom: 5,
      ),
    );
  }
}
