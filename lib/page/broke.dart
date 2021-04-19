import 'package:flutter/material.dart';

class Broke extends StatefulWidget {
  @override
  _BrokeState createState() => _BrokeState();
}

class _BrokeState extends State<Broke> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          "Broke",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        child: Center(
          child: Text(
            "内容",
          ),
        ),
      ),
    );
  }
}
