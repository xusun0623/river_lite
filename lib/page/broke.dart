import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offer_show/asset/color.dart';

class Broke extends StatefulWidget {
  @override
  _BrokeState createState() => _BrokeState();
}

class _BrokeState extends State<Broke> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: os_back,
        body: Center(
            child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/square");
                },
                child: Text("广场"))),
      ),
    );
  }
}
