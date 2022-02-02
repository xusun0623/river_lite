import 'package:flutter/material.dart';

class Square extends StatefulWidget {
  @override
  _SquareState createState() => _SquareState();
}

class _SquareState extends State<Square> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
      ),
      body: Center(
        child: Text("广场二级"),
      ),
    );
  }
}
