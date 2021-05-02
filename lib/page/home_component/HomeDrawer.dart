import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/logo.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/components/occu.dart';

class OfferShowDraw extends StatelessWidget {
  const OfferShowDraw({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          os_svg(
            path: "lib/img/draw-girl.svg",
            size: 120,
          ),
          occu(),
          Text(
            "你好",
            style: TextStyle(
              color: os_color,
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
          ),
          occu(),
          Text(
            "Hello",
            style: TextStyle(
              color: Color(0x886B8FE0),
              fontSize: 20,
              fontWeight: FontWeight.w100,
            ),
          ),
          occu(height: 5.0),
          Text(
            "Hola",
            style: TextStyle(
              color: Color(0x886B8FE0),
              fontSize: 20,
              fontWeight: FontWeight.w100,
            ),
          ),
          occu(height: 5.0),
          Text(
            "Bonjour",
            style: TextStyle(
              color: Color(0x886B8FE0),
              fontSize: 20,
              fontWeight: FontWeight.w100,
            ),
          ),
          occu(height: 5.0),
          Text(
            "안녕하세요",
            style: TextStyle(
              color: Color(0x886B8FE0),
              fontSize: 20,
              fontWeight: FontWeight.w100,
            ),
          ),
          occu(height: 5.0),
          Text(
            "Привет",
            style: TextStyle(
              color: Color(0x886B8FE0),
              fontSize: 20,
              fontWeight: FontWeight.w100,
            ),
          ),
          occu(height: 5.0),
          Text(
            "Olá",
            style: TextStyle(
              color: Color(0x886B8FE0),
              fontSize: 20,
              fontWeight: FontWeight.w100,
            ),
          ),
          occu(height: 50.0),
          Text(
            "我是OfferShow!\n欢迎你来探索",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0x886B8FE0),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
