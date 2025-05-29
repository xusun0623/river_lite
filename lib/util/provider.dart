/*
 * @Author: xusun000「xusun000@foxmail.com」 
 * @Date: 2022-08-03 10:38:43 
 * @Last Modified by:   xusun000 
 * @Last Modified time: 2022-08-03 10:38:43 
 */
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:offer_show/asset/bigScreen.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/storage.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

class LoginedProvider extends ChangeNotifier {
  bool isLogined = false;

  getLoginStatus() async {
    String myinfo = await getStorage(key: "myinfo", initData: "");
    if (myinfo == "") {
      isLogined = false;
    } else {
      isLogined = true;
    }
    refresh();
  }

  refresh() {
    notifyListeners();
  }
}

class FontSizeProvider extends ChangeNotifier {
  double fraction = 1;

  getFontScaleFrac() async {
    var tmp = await getStorage(
      key: "font_frac",
      initData: Platform.isAndroid ? "1.0" : "1.0",
    );
    fraction = double.parse(tmp);
    refresh();
  }

  setFontScaleFrac(double frac) async {
    fraction = frac;
    refresh();
    await setStorage(key: "font_frac", value: frac.toString());
  }

  refresh() {
    notifyListeners();
  }
}

class SettingConfigProvider extends ChangeNotifier {
  Map? LiteConfig;

  refresh() {
    notifyListeners();
  }
}

class AutoQuestionProvider extends ChangeNotifier {
  bool isAuto = false;

  switchMode() async {
    isAuto = !isAuto;
    notifyListeners();
  }

  refresh() async {
    await setStorage(key: "auto", value: isAuto ? "1" : "");
    notifyListeners();
  }
}

class ShowPicProvider extends ChangeNotifier {
  bool isShow = false;

  switchMode() async {
    // isShow = !isShow;
    notifyListeners();
  }

  refresh() {
    // setStorage(key: "pic", value: isShow ? "1" : "");
    notifyListeners();
  }
}

class ColorProvider extends ChangeNotifier {
  bool isDark = false;

  switchMode() async {
    await setStorage(key: "dark", value: isDark ? "1" : "");
    notifyListeners();
  }

  refresh() {
    notifyListeners();
  }
}

class BlackProvider extends ChangeNotifier {
  List? black = [];

  refresh() {
    notifyListeners();
  }
}

class AdShowProvider extends ChangeNotifier {
  bool? showAd;

  refresh() {
    notifyListeners();
  }
}

class MsgProvider extends ChangeNotifier {
  Map? msg;
  Map? _lastMsg; // 保存上一次的消息状态
  List? pmMsgArr = [];
  ScrollController scrollController = new ScrollController();
  bool? load_done = false;
  bool loading = false;
  Timer? _pollingTimer; // 定时器变量，用于轮询

  // 初始化通知插件
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  MsgProvider() {
    // 初始化通知配置
    if (Platform.isAndroid) {
      // AndroidInitializationSettings initializationSettingsAndroid =
      //     AndroidInitializationSettings('@mipmap/ic_launcher'); // 确保图标资源存在
      // var initializationSettings =
      //     InitializationSettings(android: initializationSettingsAndroid);
      // flutterLocalNotificationsPlugin.initialize(initializationSettings);
      // startPolling(); // 启动轮询
      print("启动轮询");
    }
  }
  clearMsg() async {
    msg = null;
    pmMsgArr = [];
    load_done = true;
    loading = false;
    refresh();
  }

  getMsg() async {
    int once_num = isDesktop() ? 20 : 10;
    var tmp = await Api().message_pmsessionlist({
      "json": {
        "page": 1,
        "pageSize": once_num,
      }.toString()
    });
    if (tmp != null && tmp["rs"] != 0 && tmp["body"] != null) {
      pmMsgArr = tmp["body"]["list"];
      load_done = tmp["body"]["list"].length < once_num;
    } else {
      pmMsgArr = [];
      load_done = true;
    }

    var data = await Api().message_heart({});
    if (data != null &&
        data["body"] != null &&
        data["body"]["atMeInfo"] != null) {
      msg = {
        "atMeInfoCount": data["body"]["atMeInfo"]["count"],
        "replyInfoCount": data["body"]["replyInfo"]["count"],
        "systemInfoCount": data["body"]["systemInfo"]["count"],
      };
    } else {
      msg = {
        "atMeInfoCount": 0,
        "replyInfoCount": 0,
        "systemInfoCount": 0,
      };
    }
    refresh();
  }

  // 展示系统通知
  // Future<void> _showNotification(msg) async {
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(
  //     'riverlite', // 通道 ID
  //     'riverlite', // 通道名称
  //     channelDescription: '河畔Lite通知', // 通道描述
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     showWhen: false,
  //   );
  //   print("展示通知");
  //   String notificationMsg = "";
  //   if (msg!["atMeInfoCount"] > 0) {
  //     notificationMsg += "有" + msg!["atMeInfoCount"].toString() + "条@我的消息\n";
  //   } else if (msg!["replyInfoCount"] > 0) {
  //     notificationMsg += "有" + msg!["replyInfoCount"].toString() + "条回复我的消息\n";
  //   } else if (msg!["systemInfoCount"] > 0) {
  //     notificationMsg += "有" + msg!["systemInfoCount"].toString() + "条系统消息\n";
  //   }
  //   const NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     '新消息',
  //     notificationMsg,
  //     platformChannelSpecifics,
  //   );
  // }

  getMore() async {
    if (load_done! || loading) return;
    loading = true;
    var tmp = await Api().message_pmsessionlist({
      "json": {
        "page": (pmMsgArr!.length / 10 + 1).toInt(),
        "pageSize": 10,
      }.toString()
    });
    if (tmp != null &&
        tmp["body"] != null &&
        int.parse(tmp["body"]["list"][0]["lastDateline"]) <
            int.parse(pmMsgArr![pmMsgArr!.length - 1]["lastDateline"])) {
      pmMsgArr!.addAll(tmp["body"]["list"]);
      load_done = tmp["body"]["list"].length < 10;
    } else {
      load_done = true;
    }
    loading = false;
    refresh();
  }

  refresh() {
    notifyListeners();
  }

  // 轮询方法
  startPolling() {
    _pollingTimer = Timer.periodic(Duration(seconds: 30), (timer) async {
      await getMsg();
      print("轮询");
      print("msg" + msg.toString());
      print(_lastMsg);
      if ((msg!["atMeInfoCount"] > 0 ||
              msg!["replyInfoCount"] > 0 ||
              msg!["systemInfoCount"] > 0) &&
          !mapEquals(msg, _lastMsg)) {
        // _showNotification(msg); // 只有首次或者有更新才进行通知
        _lastMsg = Map.from(msg!);
        ; // 更新上一次的消息状态

        print("_lastMsg" + _lastMsg.toString());
      }
    });
  }

  // 停止轮询
  stopPolling() {
    _pollingTimer?.cancel();
  }
}

class TabShowProvider extends ChangeNotifier {
  int index = 0;
  int desktopIndex = 0;

  changeIndex(int idx) {
    index = idx;
    notifyListeners();
  }

  changeDesktopIndex(int idx) {
    index = idx;
    notifyListeners();
  }

  refresh() {
    notifyListeners();
  }
}

class UserInfoProvider extends ChangeNotifier {
  Map? data;

  refresh() {
    notifyListeners();
  }
}

class HomeRefrshProvider extends ChangeNotifier {
  int index = 0;

  ScrollController send = new ScrollController();
  ScrollController reply = new ScrollController();
  ScrollController hot = new ScrollController();
  ScrollController essence = new ScrollController();

  void totop() {
    if (index == 0)
      send.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    if (index == 1)
      reply.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    if (index == 2)
      hot.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    if (index == 3)
      essence.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
  }

  void refresh() {
    notifyListeners();
  }
}
