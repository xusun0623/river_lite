import 'package:flutter/material.dart';

class OSSearch extends StatefulWidget {
  @override
  _OSSearchState createState() => _OSSearchState();
}

class _OSSearchState extends State<OSSearch> {
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
          "OSSearch",
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
