import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/components/niw.dart';

class HomeBtn extends StatefulWidget {
  HomeBtn({Key key}) : super(key: key);

  @override
  State<HomeBtn> createState() => _HomeBtnState();
}

class _HomeBtnState extends State<HomeBtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: os_white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      margin: EdgeInsets.only(left: 15, right: 15),
      padding: EdgeInsets.symmetric(horizontal: 5),
      width: MediaQuery.of(context).size.width - 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Btn(txt: "专栏", img: "lib/img/home/1.svg", url: ""),
          Btn(
            txt: "淘二手",
            img: "lib/img/home/2.svg",
            url: "/column",
            board_id: 61,
          ),
          Btn(
            txt: "失物",
            img: "lib/img/home/3.svg",
            url: "/column",
            board_id: 305,
          ),
          Btn(txt: "入站必看", img: "lib/img/home/4.svg", url: ""),
          Btn(txt: "专辑", img: "lib/img/home/5.svg", url: ""),
        ],
      ),
    );
  }
}

class Btn extends StatefulWidget {
  String txt;
  String img;
  String url;
  int board_id;
  Btn({
    Key key,
    @required this.txt,
    @required this.img,
    @required this.url,
    this.board_id,
  }) : super(key: key);

  @override
  State<Btn> createState() => _BtnState();
}

class _BtnState extends State<Btn> {
  @override
  Widget build(BuildContext context) {
    return myInkWell(
      tap: () {
        if (widget.url != "") {
          Navigator.pushNamed(context, widget.url, arguments: widget.board_id);
        }
      },
      widget: Container(
        width: (MediaQuery.of(context).size.width - 40) / 5,
        padding: EdgeInsets.only(top: 20, bottom: 15),
        child: Column(
          children: [
            os_svg(path: widget.img, width: 35, height: 35),
            Container(height: 7.5),
            Text(
              widget.txt,
              style: TextStyle(
                fontSize: 13,
                color: Color.fromARGB(255, 52, 52, 52),
              ),
            ),
          ],
        ),
      ),
      radius: 5,
    );
  }
}
