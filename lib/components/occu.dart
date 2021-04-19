import 'package:flutter/material.dart';

class occu extends StatefulWidget {
  var height;
  occu({Key key, this.height}) : super(key: key);
  @override
  _occuState createState() => _occuState();
}

class _occuState extends State<occu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 20,
    );
  }
}
