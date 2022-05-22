import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/cookie.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/page/me/me.dart';
import 'package:offer_show/page/question/answer.dart';
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
            child: Bounce(
              onPressed: () {},
              duration: Duration(milliseconds: 100),
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
    setState(() {});
  }

  _queryAns() async {
    match_answer = query_answer(q_a["q"]);
    setState(() {});
    await Future.delayed(Duration(milliseconds: 50));
    if (match_answer != null && match_answer != "") {
      print("OKKKKKK");
      // _submit();
    } else {
      match_answer = "";
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
    setState(() {
      status = 4;
    });
  }

  _submit() async {
    if (match_answer == "") {
      showToast(
        context: context,
        type: XSToast.none,
        txt: "请选择一个选项",
      );
    } else {
      await Api().submit_question(answer: ret_value);
      _next();
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
            match_answer == ""
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
            ElevatedButton(
              onPressed: () async {
                _next();
              },
              child: Text("下一个问题"),
            ),
            ElevatedButton(
              onPressed: () {
                _submit();
              },
              child: Text("按下"),
            )
          ];
  }

  List<Widget> bouns() {
    return [
      ElevatedButton(
        onPressed: () {
          _finish();
        },
        child: Text("领取奖励"),
      )
    ];
  }

  List<Widget> done() {
    return [
      Text("你已参加答题"),
    ];
  }

  List<Widget> haveNext() {
    return [
      GestureDetector(
        onTap: () {
          _next();
        },
        child: Text("下一关"),
      ),
    ];
  }

  List<Widget> gotBouns() {
    return [
      Text("已领取奖励"),
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
                          : status == 3
                              ? haveNext()
                              : gotBouns(),
            ),
          ),
          Container(
            height: 150,
            color: os_back,
            child: Row(
              children: [],
            ),
          ),
        ],
      ),
    );
  }
}
