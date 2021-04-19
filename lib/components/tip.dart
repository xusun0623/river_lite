import 'package:flutter/material.dart';

class tip extends StatefulWidget {
  String txt = "";
  tip({Key key, this.txt}) : super(key: key);
  @override
  _tipState createState() => _tipState();
}

class _tipState extends State<tip> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: new EdgeInsets.only(
        left: 15,
        top: 20,
        bottom: 5,
      ),
      child: Text(
        widget.txt == null ? "" : widget.txt,
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }
}
