import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/home_desktop_mode.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/refreshIndicator.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/components/empty.dart';
import 'package:offer_show/components/newNaviBar.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/page/home/myhome.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/util/mid_request.dart';
import 'package:offer_show/util/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:html/parser.dart' show parse;

class WaterTask extends StatefulWidget {
  WaterTask({Key? key}) : super(key: key);

  @override
  _WaterTaskState createState() => _WaterTaskState();
}

class _WaterTaskState extends State<WaterTask> with TickerProviderStateMixin {
  TabController? tabController;
  List<Map> newTask = [];
  List<Map> doingTask = [];
  List<Map> doneTask = [];
  List<Map> failTask = [];

  bool load_done1 = false;
  bool load_done2 = false;
  bool load_done3 = false;
  bool load_done4 = false;

  _getNew() async {
    print("_getNew");
    //获取新任务
    var document = parse((await XHttp().pureHttpWithCookie(
      url: base_url + "home.php?mod=task&item=new",
    ))
        .data
        .toString());
    try {
      var element = document.getElementsByTagName("table").first;
      List<Map> newTaskTmp = [];
      element.getElementsByTagName("tr").forEach((element1) {
        //每个任务单独的在此
        String name = "";
        String desc = "";
        String bouns = "";
        String? apply_link = "";
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
        load_done1 = true;
      });
    } catch (e) {
      setState(() {
        newTask = [];
        load_done1 = true;
      });
    }
  }

  _getDoing() async {
    print("_getDoing");
    //获取正在进行中的任务
    var document = parse((await XHttp().pureHttpWithCookie(
      url: base_url + "home.php?mod=task&item=doing",
    ))
        .data
        .toString());
    try {
      var element = document.getElementsByTagName("table").first;
      List<Map> doingTaskTmp = [];
      element.getElementsByTagName("tr").forEach((element1) {
        //每个任务单独的在此
        String name = "";
        String desc = "";
        String bouns = "";
        String progress = "";
        String? apply_link = "";
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
        progress = (double.parse(element1
                    .getElementsByClassName("xs0")
                    .first
                    .getElementsByTagName("span")
                    .first
                    .innerHtml) /
                100)
            .toString();
        apply_link = element1
            .getElementsByTagName("td")
            .last
            .getElementsByTagName("a")
            .first
            .attributes["href"];
        doingTaskTmp.add({
          "name": name,
          "desc": desc,
          "bouns": bouns,
          "progress": progress,
          "apply_link": apply_link,
        });
      });
      setState(() {
        doingTask = doingTaskTmp;
        load_done2 = true;
      });
    } catch (e) {
      setState(() {
        doingTask = [];
        load_done2 = true;
      });
    }
  }

  _getDone() async {
    print("_getDone");
    //https://bbs.uestc.edu.cn/home.php?mod=task&item=done
    //获取已失败任务
    var document = parse((await XHttp().pureHttpWithCookie(
      url: base_url + "home.php?mod=task&item=done",
    ))
        .data
        .toString());
    try {
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
        load_done3 = true;
      });
    } catch (e) {
      setState(() {
        doneTask = [];
        load_done3 = true;
      });
    }
  }

  _getFail() async {
    //https://bbs.uestc.edu.cn/home.php?mod=task&item=failed
    print("_getFail");
    //获取已失败任务
    var document = parse((await XHttp().pureHttpWithCookie(
      url: base_url + "home.php?mod=task&item=failed",
    ))
        .data
        .toString());
    try {
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
        load_done4 = true;
      });
    } catch (e) {
      setState(() {
        failTask = [];
        load_done4 = true;
      });
    }
  }

  List<Widget> _buildCont(int index) {
    List<Widget> tmp = [];
    [newTask, doingTask, doneTask, failTask][index].forEach((element) {
      tmp.add([
        ResponsiveWidget(
          child: Card1(
            data: element,
            refresh: () {
              showToast(context: context, type: XSToast.success, txt: "领取任务成功");
              _getNew();
              _getDoing();
            },
          ),
        ),
        ResponsiveWidget(
          child: Card2(
            data: element,
            refresh: () {
              showToast(context: context, type: XSToast.success, txt: "领取奖励成功");
              _getDoing();
              _getDone();
            },
          ),
        ),
        ResponsiveWidget(child: Card3(data: element)),
        ResponsiveWidget(child: Card4(data: element)),
      ][index]);
    });
    tmp.add((!load_done1 && index == 0) ||
            (!load_done2 && index == 1) ||
            (!load_done3 && index == 2) ||
            (!load_done4 && index == 3)
        ? BottomLoading(color: Colors.transparent)
        : Container());
    tmp.add((load_done1 && index == 0 && newTask.length == 0) ||
            (load_done2 && index == 1 && doingTask.length == 0) ||
            (load_done3 && index == 2 && doneTask.length == 0) ||
            (load_done4 && index == 3 && failTask.length == 0)
        ? Empty(txt: "这里是一颗空的星球")
        : Container());
    tmp.add(Container(
      height: MediaQuery.of(context).size.height,
    ));
    return tmp;
  }

  @override
  void initState() {
    tabController = TabController(length: 5, vsync: this);
    tabController!.addListener(() {
      if (tabController!.index == 1) {
        _getDoing();
      }
      if (tabController!.index == 2) {
        _getDone();
      }
      if (tabController!.index == 3) {
        _getFail();
      }
    });
    _getNew();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Baaaar(
      color:
          Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Provider.of<ColorProvider>(context).isDark
              ? os_dark_back
              : os_back,
          foregroundColor: Provider.of<ColorProvider>(context).isDark
              ? os_dark_white
              : os_black,
          elevation: 0,
          title: TabBar(
            dividerColor: Colors.transparent,
            controller: tabController,
            unselectedLabelColor: Provider.of<ColorProvider>(context).isDark
                ? os_dark_dark_white
                : os_black,
            labelColor: Provider.of<ColorProvider>(context).isDark
                ? os_dark_white
                : os_black,
            indicatorColor: Colors.transparent,
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 16,
              color: Provider.of<ColorProvider>(context).isDark
                  ? os_dark_dark_white
                  : os_deep_grey,
              fontFamily: "微软雅黑",
            ),
            isScrollable: true,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Provider.of<ColorProvider>(context).isDark
                  ? os_dark_dark_white
                  : os_black,
              fontFamily: "微软雅黑",
            ),
            tabs: [
              // Tab(text: "积分记录"),
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
            // TaskList(),
            getMyRrefreshIndicator(
              context: context,
              onRefresh: () async {
                await _getNew();
                return;
              },
              child: ListView(
                children: _buildCont(0),
                //physics: BouncingScrollPhysics(),
              ),
            ),
            getMyRrefreshIndicator(
              context: context,
              onRefresh: () async {
                await _getDoing();
                return;
              },
              child: ListView(
                children: _buildCont(1),
                //physics: BouncingScrollPhysics(),
              ),
            ),
            getMyRrefreshIndicator(
              context: context,
              onRefresh: () async {
                await _getDone();
                return;
              },
              child: ListView(
                children: _buildCont(2),
                //physics: BouncingScrollPhysics(),
              ),
            ),
            getMyRrefreshIndicator(
              context: context,
              onRefresh: () async {
                await _getFail();
                return;
              },
              child: ListView(
                children: _buildCont(3),
                //physics: BouncingScrollPhysics(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Card4 extends StatefulWidget {
  Map? data;
  Function? refresh;
  Card4({
    Key? key,
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
        color: Provider.of<ColorProvider>(context).isDark
            ? os_light_dark_card
            : os_white,
        widget: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.data!["name"],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_dark_white
                      : os_black,
                ),
              ),
              Container(height: 10),
              Text(
                "水滴任务：" + widget.data!["desc"],
                style: TextStyle(
                  fontSize: 14,
                  color: os_deep_grey,
                ),
              ),
              Container(height: 7.5),
              Text(
                "奖励：" + widget.data!["bouns"],
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
  Map? data;
  Function? refresh;
  Card3({
    Key? key,
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
        color: Provider.of<ColorProvider>(context).isDark
            ? os_light_dark_card
            : os_white,
        widget: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.data!["name"],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_dark_white
                      : os_black,
                ),
              ),
              Container(height: 10),
              Text(
                "水滴任务：" + widget.data!["desc"],
                style: TextStyle(
                  fontSize: 14,
                  color: os_deep_grey,
                ),
              ),
              Container(height: 7.5),
              Text(
                "奖励：" + widget.data!["bouns"],
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

class Card2 extends StatefulWidget {
  Map? data;
  Function? refresh;
  Card2({
    Key? key,
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
        color: Provider.of<ColorProvider>(context).isDark
            ? os_light_dark_card
            : os_white,
        tap: () async {
          // 申请链接
          if (widget.data!["progress"] == "1.0") {
            // print("申请链接：${widget.data["apply_link"]}");
            showToast(context: context, type: XSToast.loading, txt: "加载中…");
            await XHttp().pureHttpWithCookie(url: widget.data!["apply_link"]);
            hideToast();
            if (widget.refresh != null) {
              widget.refresh!();
            }
          } else if (widget.data!["desc"].toString().contains("新手导航")) {
            showToast(
                context: context,
                type: XSToast.none,
                txt: "请在网页端-论坛服务-水滴小任务完成此任务");
          } else {
            print("未达完成条件");
          }
          // await XHttp().pureHttpWithCookie(url: widget.data["apply_link"]);
        },
        widget: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.data!["name"],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_dark_white
                      : os_black,
                ),
              ),
              Container(height: 10),
              Text(
                "水滴任务：" + widget.data!["desc"],
                style: TextStyle(
                  fontSize: 14,
                  color: os_deep_grey,
                ),
              ),
              Container(height: 7.5),
              Text(
                "奖励：" + widget.data!["bouns"],
                style: TextStyle(
                  color: Color(0xFF898989),
                  fontSize: 14,
                ),
              ),
              Container(height: 10),
              LinearPercentIndicator(
                padding: EdgeInsets.symmetric(horizontal: 0),
                backgroundColor: os_grey,
                progressColor: os_color,
                percent: double.parse(
                  double.parse(widget.data!["progress"]).toStringAsFixed(2),
                ),
                barRadius: Radius.circular(10),
                trailing: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    (double.parse(widget.data!["progress"]) * 100)
                            .toStringAsFixed(0) +
                        "%",
                    style: TextStyle(
                      color: os_deep_grey,
                    ),
                  ),
                ),
              ),
              Container(height: 10),
              Text(
                "领取奖励",
                style: TextStyle(
                  color: widget.data!["progress"] == "1.0"
                      ? os_color
                      : os_middle_grey,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
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
  Map? data;
  Function? refresh;
  Card1({
    Key? key,
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
        color: Provider.of<ColorProvider>(context).isDark
            ? os_light_dark_card
            : os_white,
        tap: () async {
          showToast(context: context, type: XSToast.loading, txt: "加载中…");
          String html = (await XHttp()
                  .pureHttpWithCookie(url: widget.data!["apply_link"]))
              .data
              .toString();
          hideToast();
          if (widget.refresh != null && !html.contains("另一个任务")) {
            widget.refresh!();
          } else {
            showToast(context: context, type: XSToast.none, txt: "领取失败");
          }
        },
        widget: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.data!["name"],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_dark_white
                      : os_black,
                ),
              ),
              Container(height: 10),
              Text(
                "水滴任务：" + widget.data!["desc"],
                style: TextStyle(
                  fontSize: 14,
                  color: os_deep_grey,
                ),
              ),
              Container(height: 7.5),
              Text(
                "奖励：" + widget.data!["bouns"],
                style: TextStyle(
                  color: Color(0xFF898989),
                  fontSize: 14,
                ),
              ),
              Container(height: 10),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: os_color,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        "立即申请",
                        style: TextStyle(
                          color: os_white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
