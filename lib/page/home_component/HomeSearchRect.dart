import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/components/niw.dart';

class HomeSearchRect extends StatefulWidget {
  @override
  _HomeSearchRectState createState() => _HomeSearchRectState();
}

class _HomeSearchRectState extends State<HomeSearchRect> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          child: myInkWell(
            widget: Container(
              margin: EdgeInsets.symmetric(horizontal: os_padding * 1.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "华为+杭州",
                    style: TextStyle(
                      color: Color(0xFFC5C5C5),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(Icons.search, color: Color(0xFFC5C5C5)),
                ],
              ),
            ),
            width: os_width,
            height: 45,
            radius: 10,
          ),
          width: os_width - os_padding * 2,
          margin: EdgeInsets.only(
            left: os_padding,
            right: os_padding,
            top: 10,
          ),
          // padding: EdgeInsets.only(
          //   left: os_padding * 1.5,
          //   right: os_padding * 1.5,
          // ),
          decoration: BoxDecoration(
            color: os_white,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 45,
        ),
      ],
    );
  }
}
