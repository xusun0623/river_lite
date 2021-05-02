import 'package:flutter/material.dart';

class TestTxtField extends StatefulWidget {
  @override
  _TestTxtFieldState createState() => _TestTxtFieldState();
}

class _TestTxtFieldState extends State<TestTxtField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        maxLines: 5,
        //maxLines:null 不限制行数
      ),
    );
  }
}
