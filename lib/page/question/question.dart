import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/cookie.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/page/question/answer.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/util/interface.dart';

class Question extends StatefulWidget {
  Question({Key key}) : super(key: key);

  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  int count = 0; //第几道题
  int ret_value = 0; //勾选的答案value
  bool isFinish = false;
  bool no_answer = false; //没有匹配到答案
  bool load_done = false; //是否首次加载完成
  int status = 0; //0-正在答题 1-完成全部答题领取奖励 2-已参加答题 3-下一关 4-已领取奖励
  String match_answer = "";
  String selected_option = "";
  Map q_a = {};

  List<Widget> _buildOption() {
    List<String> carry = ["A", "B", "C", "D", "E", "F", "G", "H", "I"];
    List<Widget> tmp = [Container()];
    if (q_a != null && q_a["a_list"] != null) {
      for (var i = 0; i < q_a["a_list"].length; i++) {
        String option = q_a["a_list"][i];
        if (option == match_answer) {
          ret_value = q_a["v_list"][i];
          selected_option = "${carry[i]}. " + option;
        }
        tmp.add(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7.5),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  no_answer = true;
                  match_answer = option;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: match_answer == option ? os_color : os_white,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: match_answer == option ? os_color_opa : os_white,
                ),
                child: Text(
                  "${carry[i]}. " + option,
                  style: TextStyle(
                    color: match_answer == option ? os_color : os_black,
                    fontSize: 16,
                    fontWeight: match_answer == option
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }
    return tmp;
  }

  _getQuestion() async {
    await getWebCookie();
    String get_q_a = await Api().get_question();
    if (get_q_a == "") {
      setState(() {
        status = 2; //0-正在答题 1-完成全部答题领取奖励 2-已参加答题 3-下一关
      });
    } else if (get_q_a == "1") {
      setState(() {
        isFinish = true;
        status = 1; //0-正在答题 1-完成全部答题领取奖励 2-已参加答题 3-下一关
      });
    } else if (get_q_a == "3") {
      setState(() {
        status = 3; //0-正在答题 1-完成全部答题领取奖励 2-已参加答题 3-下一关
      });
    } else {
      q_a = jsonDecode(get_q_a);
      count = int.parse(q_a["progress"][0].toString());
      _queryAns();
    }
    setState(() {
      load_done = true;
    });
  }

  _queryAns() async {
    match_answer = query_answer(q_a["q"]);
    await Future.delayed(Duration(milliseconds: 50));
    if (match_answer != null && match_answer != "") {
      setState(() {
        no_answer = false;
      });
      // _submit();
    } else {
      setState(() {
        match_answer = "";
        no_answer = true;
      });
    }
  }

  _next() async {
    print("当前已答题数：${count}");
    if (count < 7) {
      await Api().next_question();
      _getQuestion();
    } else {
      _getQuestion();
    }
  }

  _finish() async {
    await Api().finish_question();
    showToast(
      context: context,
      type: XSToast.success,
      txt: "领取9水滴",
    );
    await Future.delayed(Duration(milliseconds: 500));
    hideToast();
    Navigator.pop(context);
  }

  _submit() async {
    if (match_answer == "") {
      showToast(
        context: context,
        type: XSToast.none,
        txt: "请选择一个选项",
      );
    } else {
      showToast(context: context, type: XSToast.loading, txt: "请稍后…");
      await Api().submit_question(answer: ret_value);
      await _next();
      hideToast();
    }
  }

  @override
  void initState() {
    _getQuestion();
    super.initState();
  }

  List<Widget> doing() {
    return q_a == null || q_a["q"] == null
        ? []
        : [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                q_a["progress"].toString().replaceAll(" ", ""),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text(
                q_a["q"],
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(height: 10),
            ..._buildOption(),
            match_answer == "" || no_answer
                ? Container()
                : Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 7.5,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color(0xFFE4EAF1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "已匹配到答案，已自动勾选",
                            style: TextStyle(color: Color(0xFF677D9B)),
                          ),
                          Container(height: 5),
                          Text(
                            selected_option,
                            style: TextStyle(
                              color: Color(0xFF677D9B),
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ];
  }

  List<Widget> bouns() {
    return [
      Container(
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Container(
          child: Column(
            children: [
              Icon(
                Icons.done,
                color: os_deep_blue,
                size: 60,
              ),
              Container(height: 10),
              Text(
                "任务完成",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(height: 5),
              Container(
                width: MediaQuery.of(context).size.width - 100,
                child: Text(
                  "您已完成今日水滴答题,点击下方按钮领取今日奖励吧",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Container(height: 150),
              myInkWell(
                tap: () {
                  _finish();
                },
                color: Color(0x22004DFF),
                radius: 10,
                widget: Container(
                  width: 150,
                  height: 46,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Center(
                    child: Text(
                      "领取奖励",
                      style: TextStyle(
                        color: os_deep_blue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> done() {
    return [
      Container(
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Container(
          child: Column(
            children: [
              Icon(
                Icons.info,
                color: os_wonderful_color[1],
                size: 60,
              ),
              Container(height: 10),
              Text(
                "已完成今日答题",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(height: 5),
              Container(
                width: MediaQuery.of(context).size.width - 100,
                child: Text(
                  "您已完成今日水滴答题,明天再来吧",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Container(height: 150),
              myInkWell(
                tap: () {
                  Navigator.pop(context);
                },
                color: os_white,
                radius: 10,
                widget: Container(
                  width: 150,
                  height: 46,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Center(
                    child: Text(
                      "返回",
                      style: TextStyle(
                        color: os_deep_grey,
                        fontSize: 16,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> haveNext() {
    return [
      Container(
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Container(
          child: Column(
            children: [
              Icon(
                Icons.arrow_right_alt_rounded,
                color: os_wonderful_color[1],
                size: 60,
              ),
              Container(height: 10),
              Text(
                "开启下一关",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(height: 5),
              Container(
                width: MediaQuery.of(context).size.width - 100,
                child: Text(
                  "您尚未完成所有关卡,是否立即开启下一关",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Container(height: 150),
              myInkWell(
                tap: () {
                  _next();
                },
                color: os_white,
                radius: 10,
                widget: Container(
                  width: 150,
                  height: 46,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Center(
                    child: Text(
                      "下一关",
                      style: TextStyle(
                        color: os_deep_grey,
                        fontSize: 16,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> bottom() {
    return [
      myInkWell(
        color: os_white,
        radius: 10,
        widget: Container(
          width: (MediaQuery.of(context).size.width - 60) * 0.4,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
              child: Text(
            "机器接管",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          )),
        ),
      ),
      Container(width: 10),
      myInkWell(
        tap: () {
          _submit();
        },
        color: os_color,
        radius: 10,
        widget: Container(
          width: (MediaQuery.of(context).size.width - 60) * 0.6,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
            child: Text(
              "下一题",
              style: TextStyle(
                color: os_white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: os_back,
        foregroundColor: os_black,
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "水滴答题",
          style: TextStyle(
            color: os_black,
            fontSize: 16,
          ),
        ),
      ),
      backgroundColor: os_back,
      body: Column(
        children: [
          load_done ? Container() : BottomLoading(color: Colors.transparent),
          Container(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                250,
            child: ListView(
              physics: BouncingScrollPhysics(),
              //0-正在答题 1-完成全部答题领取奖励 2-已参加答题 3-下一关
              children: status == 0
                  ? doing()
                  : status == 1
                      ? bouns()
                      : status == 2
                          ? done()
                          : haveNext(),
            ),
          ),
          status == 0 && load_done
              ? Container(
                  height: 150,
                  color: os_back,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: bottom(),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
