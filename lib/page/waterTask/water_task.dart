import 'dart:math';

import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/page/home/myhome.dart';
import 'package:offer_show/util/mid_request.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';
import 'package:html/parser.dart' show parse;

class WaterTask extends StatefulWidget {
  WaterTask({Key key}) : super(key: key);

  @override
  _WaterTaskState createState() => _WaterTaskState();
}

class _WaterTaskState extends State<WaterTask> with TickerProviderStateMixin {
  TabController tabController;
  List<Map> newTask = [];
  List<Map> doingTask = [
    {
      "name": "中红包",
      "desc": "通过发帖回帖完成任务，活跃论坛的氛围（24小时50贴）",
      "bouns": "积分 水滴 30 滴",
      "progress": 0,
      "apply_link": "https://bbs.uestc.edu.cn/home.php?mod=task&do=apply&id=6",
    }
  ];
  List<Map> doneTask = [];
  List<Map> failTask = [];

  _getNew() async {
    //获取新任务
    var document = parse((await XHttp().pureHttpWithCookie(
      url: "https://bbs.uestc.edu.cn/home.php?mod=task&item=new",
    ))
        .data
        .toString());
    var element = document.getElementsByTagName("table").first;
    List<Map> newTaskTmp = [];
    element.getElementsByTagName("tr").forEach((element1) {
      //每个任务单独的在此
      String name = "";
      String desc = "";
      String bouns = "";
      String apply_link = "";
      element1.getElementsByClassName("pbm").forEach((element2) {
        element2.getElementsByClassName("xi2").forEach((element3) {
          element3.getElementsByTagName("a").forEach((element4) {
            name += element4.innerHtml; //任务名称
          });
        });
      });
      desc = element1 //任务描述
          .getElementsByClassName("pbm")
          .first
          .getElementsByClassName("xg2")
          .last
          .innerHtml;
      bouns =
          element1.getElementsByClassName("hm").first.innerHtml.trim(); //任务奖励
      apply_link = element1
          .getElementsByTagName("td")
          .last
          .getElementsByTagName("a")
          .first
          .attributes["href"];
      newTaskTmp.add({
        "name": name,
        "desc": desc,
        "bouns": bouns,
        "apply_link": apply_link,
      });
    });
    setState(() {
      newTask = newTaskTmp;
    });
  }

  _getDoing() async {
    print("_getDoing");
  }

  _getDone() async {
    print("_getDone");
    //https://bbs.uestc.edu.cn/home.php?mod=task&item=done
    //获取已失败任务
    var document = parse((await XHttp().pureHttpWithCookie(
      url: "https://bbs.uestc.edu.cn/home.php?mod=task&item=done",
    ))
        .data
        .toString());
    var element = document.getElementsByTagName("table").first;
    List<Map> doneTaskTmp = [];
    element.getElementsByTagName("tr").forEach((element1) {
      //每个任务单独的在此
      String name = "";
      String desc = "";
      String bouns = "";
      String done_time = "";
      element1.getElementsByClassName("pbm").forEach((element2) {
        element2.getElementsByClassName("xi2").forEach((element3) {
          element3.getElementsByTagName("a").forEach((element4) {
            name += element4.innerHtml; //任务名称
          });
        });
      });
      desc = element1 //任务描述
          .getElementsByClassName("pbm")
          .first
          .getElementsByClassName("xg2")
          .last
          .innerHtml;
      bouns =
          element1.getElementsByClassName("hm").first.innerHtml.trim(); //任务奖励
      done_time = element1
          .getElementsByTagName("td")
          .last
          .getElementsByTagName("p")
          .first
          .innerHtml;
      doneTaskTmp.add({
        "name": name,
        "desc": desc,
        "bouns": bouns,
        "done_time": done_time,
      });
    });
    setState(() {
      doneTask = doneTaskTmp;
    });
  }

  _getFail() async {
    //https://bbs.uestc.edu.cn/home.php?mod=task&item=failed
    print("_getFail");
    //获取已失败任务
    var document = parse((await XHttp().pureHttpWithCookie(
      url: "https://bbs.uestc.edu.cn/home.php?mod=task&item=failed",
    ))
        .data
        .toString());
    var element = document.getElementsByTagName("table").first;
    List<Map> failTaskTmp = [];
    element.getElementsByTagName("tr").forEach((element1) {
      //每个任务单独的在此
      String name = "";
      String desc = "";
      String bouns = "";
      String done_time = "";
      element1.getElementsByClassName("pbm").forEach((element2) {
        element2.getElementsByClassName("xi2").forEach((element3) {
          element3.getElementsByTagName("a").forEach((element4) {
            name += element4.innerHtml; //任务名称
          });
        });
      });
      desc = element1 //任务描述
          .getElementsByClassName("pbm")
          .first
          .getElementsByClassName("xg2")
          .last
          .innerHtml;
      bouns =
          element1.getElementsByClassName("hm").first.innerHtml.trim(); //任务奖励
      done_time = element1
          .getElementsByTagName("td")
          .last
          .getElementsByTagName("p")
          .first
          .innerHtml
          .split("<br>")[0];
      failTaskTmp.add({
        "name": name,
        "desc": desc,
        "bouns": bouns,
        "done_time": done_time,
      });
    });
    setState(() {
      failTask = failTaskTmp;
    });
  }

  List<Widget> _buildCont(int index) {
    List<Widget> tmp = [];
    [newTask, doingTask, doneTask, failTask][index].forEach((element) {
      tmp.add([
        Card1(data: element),
        Card2(data: element),
        Card3(data: element),
        Card4(data: element),
      ][index]);
    });
    return tmp;
  }

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      if (tabController.index == 1) {
        _getDoing();
      }
      if (tabController.index == 2) {
        _getDone();
      }
      if (tabController.index == 3) {
        _getFail();
      }
    });
    _getNew();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
        foregroundColor: Provider.of<ColorProvider>(context).isDark
            ? os_dark_white
            : os_black,
        elevation: 0,
        title: TabBar(
          controller: tabController,
          labelColor: Provider.of<ColorProvider>(context).isDark
              ? os_dark_white
              : os_black,
          tabs: [
            Tab(text: "新任务"),
            Tab(text: "进行中"),
            Tab(text: "已完成"),
            Tab(text: "已失败"),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor:
          Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
      body: TabBarView(
        physics: CustomTabBarViewScrollPhysics(),
        controller: tabController,
        children: [
          ListView(
            children: _buildCont(0),
            physics: BouncingScrollPhysics(),
          ),
          ListView(
            children: _buildCont(1),
            physics: BouncingScrollPhysics(),
          ),
          ListView(
            children: _buildCont(2),
            physics: BouncingScrollPhysics(),
          ),
          ListView(
            children: _buildCont(3),
            physics: BouncingScrollPhysics(),
          ),
        ],
      ),
    );
  }
}

class Card4 extends StatefulWidget {
  Map data;
  Function refresh;
  Card4({
    Key key,
    this.data,
    this.refresh,
  }) : super(key: key);

  @override
  State<Card4> createState() => _Card4State();
}

class _Card4State extends State<Card4> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: os_edge, vertical: 5),
      child: myInkWell(
        radius: 10,
        widget: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.data["name"],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(height: 10),
              Text(
                "水滴任务：" + widget.data["desc"],
                style: TextStyle(
                  fontSize: 14,
                  color: os_deep_grey,
                ),
              ),
              Container(height: 7.5),
              Text(
                "奖励：" + widget.data["bouns"],
                style: TextStyle(
                  color: Color(0xFF898989),
                  fontSize: 14,
                ),
              ),
              Container(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}

class Card3 extends StatefulWidget {
  Map data;
  Function refresh;
  Card3({
    Key key,
    this.data,
    this.refresh,
  }) : super(key: key);

  @override
  State<Card3> createState() => _Card3State();
}

class _Card3State extends State<Card3> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: os_edge, vertical: 5),
      child: myInkWell(
        radius: 10,
        widget: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.data["name"],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(height: 10),
              Text(
                "水滴任务：" + widget.data["desc"],
                style: TextStyle(
                  fontSize: 14,
                  color: os_deep_grey,
                ),
              ),
              Container(height: 7.5),
              Text(
                "奖励：" + widget.data["bouns"],
                style: TextStyle(
                  color: Color(0xFF898989),
                  fontSize: 14,
                ),
              ),
              Container(height: 10),
              GestureDetector(
                onTap: () async {
                  // 申请链接
                  // await XHttp().pureHttpWithCookie(url: widget.data["apply_link"]);
                },
                child: Text(
                  "立即申请",
                  style: TextStyle(
                    color: os_color,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Card2 extends StatefulWidget {
  Map data;
  Function refresh;
  Card2({
    Key key,
    this.data,
    this.refresh,
  }) : super(key: key);

  @override
  State<Card2> createState() => _Card2State();
}

class _Card2State extends State<Card2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: os_edge, vertical: 5),
      child: myInkWell(
        radius: 10,
        widget: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.data["name"],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(height: 10),
              Text(
                "水滴任务：" + widget.data["desc"],
                style: TextStyle(
                  fontSize: 14,
                  color: os_deep_grey,
                ),
              ),
              Container(height: 7.5),
              Text(
                "奖励：" + widget.data["bouns"],
                style: TextStyle(
                  color: Color(0xFF898989),
                  fontSize: 14,
                ),
              ),
              Container(height: 10),
              GestureDetector(
                onTap: () async {
                  // 申请链接
                  // await XHttp().pureHttpWithCookie(url: widget.data["apply_link"]);
                },
                child: Text(
                  "立即申请",
                  style: TextStyle(
                    color: os_color,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Card1 extends StatefulWidget {
  Map data;
  Function refresh;
  Card1({
    Key key,
    this.data,
    this.refresh,
  }) : super(key: key);

  @override
  State<Card1> createState() => _Card1State();
}

class _Card1State extends State<Card1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: os_edge, vertical: 5),
      child: myInkWell(
        radius: 10,
        widget: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.data["name"],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(height: 10),
              Text(
                "水滴任务：" + widget.data["desc"],
                style: TextStyle(
                  fontSize: 14,
                  color: os_deep_grey,
                ),
              ),
              Container(height: 7.5),
              Text(
                "奖励：" + widget.data["bouns"],
                style: TextStyle(
                  color: Color(0xFF898989),
                  fontSize: 14,
                ),
              ),
              Container(height: 10),
              GestureDetector(
                onTap: () async {
                  // 申请链接
                  // await XHttp().pureHttpWithCookie(url: widget.data["apply_link"]);
                },
                child: Text(
                  "立即申请",
                  style: TextStyle(
                    color: os_color,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
