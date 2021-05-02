import 'package:flutter/material.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/svg.dart';

class Skelon extends StatefulWidget {
  final bool show;

  const Skelon({Key key, this.show}) : super(key: key);

  @override
  _SkelonState createState() => _SkelonState();
}

class _SkelonState extends State<Skelon> {
  @override
  Widget build(BuildContext context) {
    return widget.show
        ? Container()
        : Container(
            margin: EdgeInsets.only(bottom: 1000),
            child: os_svg(
              path: "lib/img/detail-skelon.svg",
              height: os_width * 1.84,
              width: os_width,
            ),
          );
  }
}
