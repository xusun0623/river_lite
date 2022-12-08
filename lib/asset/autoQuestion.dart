/*
 * @Author: xusun000「xusun000@foxmail.com」 
 * @Date: 2022-11-07 21:59:02 
 * @Last Modified by: xusun000
 * @Last Modified time: 2022-11-07 22:06:50
 */

import 'dart:convert';

import 'package:offer_show/asset/cookie.dart';
import 'package:offer_show/page/question/answer.dart';
import 'package:offer_show/util/interface.dart';

int count = 0; //第几道题
int ret_value = 0; //勾选的答案value
bool isFinish = false;
bool no_answer = false; //没有匹配到答案
int status = 0; //0-正在答题 1-完成全部答题领取奖励 2-已参加答题 3-下一关 4-已领取奖励
String match_answer = "";
Map q_a = {};
/**
 * 自动答题
 * callback(Int) 
 *      -1  - 成功or失败(不显示)
 *      1~7 - 对应的进度
 */
autoQuestion(Function callback) async {
  // _getQuestion(callback: callback);
}

_getQuestion({Function callback}) async {
  await getWebCookie();
  String get_q_a = await Api().get_question();
  if (get_q_a == "") {
    //已参加答题
    status = 2; //0-正在答题 1-完成全部答题领取奖励 2-已参加答题 3-下一关
    if (callback != null) {
      callback(-1);
    }
  } else if (get_q_a == "1") {
    isFinish = true;
    status = 1; //0-正在答题 1-完成全部答题领取奖励 2-已参加答题 3-下一关
    Api().finish_question();
    if (callback != null) {
      callback(-1);
    }
  } else if (get_q_a == "3") {
    status = 3; //0-正在答题 1-完成全部答题领取奖励 2-已参加答题 3-下一关
    _next();
    if (callback != null) {
      callback(count);
    }
  } else {
    if (callback != null) {
      callback(count);
    }
    q_a = jsonDecode(get_q_a);
    count = int.parse(q_a["progress"][0].toString());
    match_answer = query_answer(q_a["q"]);
    if (match_answer != null && match_answer != "") {
      no_answer = false;
    } else {
      match_answer = "";
      no_answer = true;
    }
    if (q_a != null && q_a["a_list"] != null) {
      for (var i = 0; i < q_a["a_list"].length; i++) {
        String option = q_a["a_list"][i];
        if ("${option}" == "${match_answer}" || option.contains("屋大维")) {
          ret_value = q_a["v_list"][i];
        }
      }
    }
    _submit();
  }
}

_next() async {
  print("当前已答题数：${count}");
  if (count < 7) {
    //还在答题
    await Api().next_question();
    await _getQuestion();
    await Future.delayed(Duration(milliseconds: 50));
    _submit();
  } else {
    //已经答完了
    await _getQuestion();
    await Api().finish_question();
  }
}

_submit() async {
  if ((match_answer == "") || (match_answer == null)) {
  } else if ((match_answer == "") || (match_answer == null)) {
    //  机器没匹配到
    ret_value = 0;
    match_answer = "";
  } else {
    if (ret_value != 0 && match_answer != "") {
      await Api().submit_question(
        answer: ret_value,
        context: null,
      );
      ret_value = 0;
      match_answer = "";
      await _next();
    }
  }
}
