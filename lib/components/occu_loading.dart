import 'package:flutter/material.dart';

class OccuLoading extends StatefulWidget {
  OccuLoading({Key key}) : super(key: key);

  @override
  _OccuLoadingState createState() => _OccuLoadingState();
}

class _OccuLoadingState extends State<OccuLoading> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 100),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.black26,
              ),
            ),
            Container(width: 10),
            Text(
              "加载中…",
              style: TextStyle(
                color: Colors.black38,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
