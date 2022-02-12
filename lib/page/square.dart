import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Square extends StatefulWidget {
  @override
  _SquareState createState() => _SquareState();
}

class _SquareState extends State<Square> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Center(
        child: Text("广场二级"),
      ),
    );
  }
}
