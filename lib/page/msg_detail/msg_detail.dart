import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/components/niw.dart';

class MsgDetail extends StatefulWidget {
  int fromUid;
  MsgDetail({
    Key key,
    this.fromUid,
  }) : super(key: key);

  @override
  MsgDetailState createState() => MsgDetailState();
}

class MsgDetailState extends State<MsgDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: os_white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: os_white,
        foregroundColor: os_black,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.chevron_left_rounded, color: os_black),
        ),
        centerTitle: true,
        actions: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: myInkWell(
              color: Color(0xFFEEEEEE),
              widget: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.5),
                child: Center(child: Text("查看空间")),
              ),
              radius: 100,
            ),
          ),
          Container(width: 15),
        ],
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "北冥小鱼",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 7.5,
                  height: 7.5,
                  decoration: BoxDecoration(
                    color: Color(0xFF1AE316),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                Container(width: 5),
                Text(
                  "该用户当前在线",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFADADAD),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Center(
        child: Text((widget.fromUid ?? 0).toString()),
      ),
    );
  }
}
