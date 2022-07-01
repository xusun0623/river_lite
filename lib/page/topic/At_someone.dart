import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class AtSomeone extends StatefulWidget {
  Function tap;
  Function hide;
  Color backgroundColor;
  AtSomeone({
    Key key,
    @required this.tap,
    @required this.hide,
    this.backgroundColor,
  }) : super(key: key);

  @override
  State<AtSomeone> createState() => _AtSomeoneState();
}

class _AtSomeoneState extends State<AtSomeone> {
  var list = [];
  bool load_done = false;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    _getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getData();
      }
    });
    super.initState();
  }

  _getData() async {
    if (load_done) return;
    var pageSize = 20;
    var data = await Api().forum_atuserlist({
      "page": (list.length / pageSize + 1).ceil(),
      "pageSize": pageSize,
    });
    if (data != null &&
        data["rs"] != 0 &&
        data["list"] != null &&
        data["list"].length != 0) {
      list.addAll(data["list"]);
      load_done =
          (data["list"].length % pageSize != 0 || data["list"].length == 0);
    } else {
      load_done = true;
    }
    setState(() {});
  }

  List<Widget> _buildCont() {
    List<Widget> tmp = [];
    if (list.length != 0) {
      tmp.add(Container(
        margin: EdgeInsets.only(left: 5, top: 10, right: 5),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Text(
                "可以@的人",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_dark_white
                      : os_black,
                ),
              ),
              Container(width: 5),
              myInkWell(
                color: Colors.transparent,
                radius: 100,
                tap: () {
                  widget.hide();
                  Navigator.pushNamed(context, "/search", arguments: 1);
                },
                widget: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Icon(
                    Icons.search,
                    color: os_color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
    }
    list.forEach((element) {
      tmp.add(Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        child: myInkWell(
          color: Colors.transparent,
          tap: () {
            widget.tap(element["uid"], element["name"]);
          },
          widget: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                Icon(Icons.person, color: os_color),
                Container(width: 10),
                Text(
                  element["name"],
                  style: TextStyle(
                      fontSize: 16,
                      color: Provider.of<ColorProvider>(context).isDark
                          ? os_dark_dark_white
                          : os_black),
                ),
              ],
            ),
          ),
          radius: 5,
        ),
      ));
    });
    if (list.length != 0 && !load_done) {
      tmp.add(Container(
        padding: EdgeInsets.only(top: 15, bottom: 25),
        child: Center(
          child: Text("加载中…", style: TextStyle(color: os_deep_grey)),
        ),
      ));
    }
    if (list.length == 0 && load_done) {
      tmp.add(GestureDetector(
        onTap: () {
          widget.hide();
          Navigator.pushNamed(context, "/search", arguments: 1);
        },
        child: Container(
          height: 249,
          child: Center(
            child: Text(
              "暂无可以@的人,你可以关注ta,点击搜索>",
              style: TextStyle(
                fontSize: 14,
                color: os_deep_grey,
              ),
            ),
          ),
        ),
      ));
    }
    if (list.length == 0 && load_done == false) {
      tmp.add(Container(
        height: 230,
        child: Center(
          child: Text(
            "加载中…",
            style: TextStyle(
              fontSize: 14,
              color: os_deep_grey,
            ),
          ),
        ),
      ));
    }
    return tmp;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: widget.backgroundColor ??
            (Provider.of<ColorProvider>(context).isDark
                ? os_dark_card
                : os_grey),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: ListView(
        physics: BouncingScrollPhysics(),
        controller: _scrollController,
        children: _buildCont(),
      ),
    );
  }
}
