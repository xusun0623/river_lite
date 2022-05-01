import 'package:flutter/material.dart';

class TabShowProvider extends ChangeNotifier {
  bool isShowExplore;
  int index = 0;
  List<int> loadIndex = [0, 2, 3];

  refresh() {
    notifyListeners();
  }
}

class UserInfoProvider extends ChangeNotifier {
  Map data;

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
