import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: os_back,
        elevation: 0.0,
        title: Text(
          "title",
          style: TextStyle(color: os_black),
        ),
      ),
      body: Center(
        child: Text("Hello"),
      ),
    );
  }
}
