import 'package:flutter/material.dart';

class page2 extends StatefulWidget {
  @override
  _page2State createState() => _page2State();
}

class _page2State extends State<page2> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(),
        Container(
          child: Center(
            child: Text(
              "$_index",
            ),
          ),
        ),
        ElevatedButton(
            onPressed: () {
              setState(() {
                _index++;
              });
            },
            child: Text("+"))
      ],
    );
  }
}
