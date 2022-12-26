import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/components/niw.dart';

class HomeBtnCollect extends StatefulWidget {
  const HomeBtnCollect({Key? key}) : super(key: key);

  @override
  _HomeBtnCollectState createState() => _HomeBtnCollectState();
}

class _HomeBtnCollectState extends State<HomeBtnCollect> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - os_edge * 2,
      margin: EdgeInsets.only(left: os_edge, right: os_edge, top: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: os_white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Btn(img: "1-loss", txt: "失物招领", board_id: 305),
          Btn(img: "2-second", txt: "二手专区", board_id: 61),
          BtnAll(),
        ],
      ),
    );
  }
}

class BtnAll extends StatefulWidget {
  const BtnAll({Key? key}) : super(key: key);

  @override
  State<BtnAll> createState() => _BtnAllState();
}

class _BtnAllState extends State<BtnAll> {
  @override
  Widget build(BuildContext context) {
    return myInkWell(
      tap: () {},
      widget: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        width: (MediaQuery.of(context).size.width - 30 - 20) / 3,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            os_svg(
              path: "lib/collect_btn/0-all.svg",
              width: 24,
              height: 24,
            ),
            Container(width: 3),
            Text(
              "全部分类",
              style: TextStyle(
                color: Color(0xFF676767),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      radius: 0,
    );
  }
}

class Btn extends StatefulWidget {
  String img;
  String txt;
  int board_id;
  Btn({
    Key? key,
    required this.img,
    required this.txt,
    required this.board_id,
  }) : super(key: key);

  @override
  State<Btn> createState() => _BtnState();
}

class _BtnState extends State<Btn> {
  /**  { img: 0-all, txt: 全部分类, board_id: 25,  } */
  @override
  Widget build(BuildContext context) {
    return myInkWell(
      tap: () {
        Navigator.pushNamed(
          context,
          "/column",
          arguments: widget.board_id,
        );
      },
      widget: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        width: (MediaQuery.of(context).size.width - os_edge * 2 - 20) / 3,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            os_svg(
              path: "lib/collect_btn/${widget.img}.svg",
              width: 24,
              height: 24,
            ),
            Container(width: 3),
            Text(
              "${widget.txt}",
              style: TextStyle(
                color: Color(0xFF676767),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      radius: 0,
    );
  }
}
