/*
 * @Author: xusun000「xusun000@foxmail.com」 
 * @Date: 2022-08-03 10:38:43 
 * @Last Modified by:   xusun000 
 * @Last Modified time: 2022-08-03 10:38:43 
 */
import 'package:flutter/material.dart';
import 'package:offer_show/asset/bigScreen.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/storage.dart';

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
    isShow = !isShow;
    notifyListeners();
  }

  refresh() {
    setStorage(key: "pic", value: isShow ? "1" : "");
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
  List? pmMsgArr = [];
  ScrollController scrollController = new ScrollController();
  bool? load_done = false;
  bool loading = false;

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
}

class TabShowProvider extends ChangeNotifier {
  int? index = 0;

  changeIndex(int idx) {
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
