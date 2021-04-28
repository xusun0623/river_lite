import 'package:flutter/material.dart';

class MainProvider extends ChangeNotifier {
  int curNum = 0;
  add() {
    curNum++;
    notifyListeners();
  }

  minus() {
    curNum--;
    notifyListeners();
  }
}
