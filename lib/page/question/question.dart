import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/cookie.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/page/question/answer.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/storage.dart';

class Question extends StatefulWidget {
  Question({Key key}) : super(key: key);

  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  int count = 1; //第几道题
  int ret_value = 0; //勾选的答案value
  bool isFinish = false;
  String match_answer = "";
  Map q_a = {};
  //{
  //   "q": tmp_q,
  //   "a_list": tmp_a,
  //}

  List<Widget> _buildOption() {
    List<String> carry = ["A", "B", "C", "D", "E", "F", "G", "H", "I"];
    List<Widget> tmp = [Container()];
    if (q_a != null && q_a["a_list"] != null) {
      for (var i = 0; i < q_a["a_list"].length; i++) {
        String option = q_a["a_list"][i];
        if (option == match_answer) {
          ret_value = q_a["v_list"][i];
        }
        tmp.add(Text(
          "${carry[i]}. " + option,
          style: TextStyle(
            color: match_answer == option ? os_red : os_black,
          ),
        ));
      }
    }
    return tmp;
  }

  _getInitQuestion() async {
    await getWebCookie();
    String get_q_a = await Api().get_question();
    if (get_q_a == "") {
      showToast(context: context, type: XSToast.none, txt: "您已经参加过答题");
    } else if (get_q_a == "1") {
      setState(() {
        isFinish = true;
      });
      showToast(context: context, type: XSToast.none, txt: "恭喜您完成了全部的挑战关卡");
    } else {
      q_a = jsonDecode(get_q_a);
    }
    _queryAns();
    setState(() {});
  }

  _queryAns() async {
    match_answer = query_answer(q_a["q"]);
    print("查询结果: ${match_answer}");
    setState(() {});
    await Future.delayed(Duration(milliseconds: 50));
    print("查询Value: ${ret_value}");
  }

  _next() async {
    await Api().next_question();
  }

  _finish() async {
    await Api().finish_question();
  }

  _submit() async {
    await Api().submit_question(answer: ret_value);
  }

  @override
  void initState() {
    _getInitQuestion();
    super.initState();
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
      body: ListView(
        children: q_a == null || q_a["q"] == null
            ? [
                isFinish
                    ? ElevatedButton(
                        onPressed: () {
                          _finish();
                        },
                        child: Text("领取奖励"))
                    : Container(),
                ElevatedButton(
                  onPressed: () async {
                    _next();
                  },
                  child: Text("下一个问题"),
                )
              ]
            : [
                Text("${count}. " + q_a["q"]),
                ..._buildOption(),
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
                ),
              ],
      ),
    );
  }
}
