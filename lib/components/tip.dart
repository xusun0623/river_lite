import 'package:flutter/material.dart';

class tip extends StatefulWidget {
  String txt = "";
  double size;
  double left;
  double top;
  tip({Key key, this.txt, this.left, this.size, this.top}) : super(key: key);
  @override
  _tipState createState() => _tipState();
}

class _tipState extends State<tip> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: new EdgeInsets.only(
        left: widget.left ?? 15,
        top: widget.top ?? 20,
        bottom: 5,
      ),
      child: Row(
        children: [
          Text(
            widget.txt == null ? "" : widget.txt,
            style: TextStyle(
              color: Colors.grey,
              fontSize: widget.size ?? null,
            ),
          ),
        ],
      ),
    );
  }
}
