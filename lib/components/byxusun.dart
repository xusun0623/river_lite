import 'package:flutter/material.dart';

class byxusun extends StatefulWidget {
  @override
  _byxusunState createState() => _byxusunState();
}

class _byxusunState extends State<byxusun> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: new EdgeInsets.only(
        top: 20,
        bottom: 50,
      ),
      child: Center(
          child: Text(
        "Copied By xusun000 - 临摹Vant组件",
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey,
        ),
      )),
    );
  }
}
