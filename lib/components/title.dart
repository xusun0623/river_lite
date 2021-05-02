import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/components/tip.dart';

class OSTitle extends StatefulWidget {
  String title;
  String tip;
  OSTitle({Key key, @required this.title, @required this.tip})
      : super(key: key);
  @override
  _OSTitleState createState() => _OSTitleState();
}

class _OSTitleState extends State<OSTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: new EdgeInsets.only(
        left: os_padding,
        right: os_padding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 4,
                height: 15,
                decoration: BoxDecoration(
                  color: os_color,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              Container(
                width: 5,
              ),
              Container(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: os_black,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 2,
          ),
          (widget.tip.length == 0
              ? Container()
              : Row(
                  children: [
                    Container(
                      child: Text(
                        widget.tip,
                        style: TextStyle(
                          fontSize: 12,
                          color: os_subtitle,
                        ),
                      ),
                    )
                  ],
                ))
        ],
      ),
    );
  }
}
