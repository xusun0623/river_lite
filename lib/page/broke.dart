import 'package:flutter/material.dart';
import 'package:offer_show/components/scaffold.dart';
import 'package:offer_show/page/broke_component/brokeBody.dart';

class Broke extends StatefulWidget {
  @override
  _BrokeState createState() => _BrokeState();
}

class _BrokeState extends State<Broke> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          BrokeBody(),
        ],
      ),
    );
  }
}
