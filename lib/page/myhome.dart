import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Center(
        child: GestureDetector(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: os_color,
              borderRadius: BorderRadius.all(Radius.circular(10000)),
            ),
            child:
                Center(child: Text("Hello", style: TextStyle(color: os_white))),
          ),
          onTap: () => {
            Navigator.pushNamed(
              context,
              "/search",
            )
          },
        ),
      ),
    );
  }
}
