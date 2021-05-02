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

class KeyBoard extends ChangeNotifier {
  bool isOpen = false;
  bool isFocus = false;
  TextEditingController editingController = new TextEditingController();
  String nowSalaryId;
  FocusNode focusNode = new FocusNode();

  foucs(context) {
    focusNode.requestFocus();
    notifyListeners();
  }

  unfocus() {
    focusNode.unfocus();
    notifyListeners();
  }

  setNowSalaryId(String t) {
    nowSalaryId = t;
    notifyListeners();
  }

  getNowSalaryId() {
    return nowSalaryId;
  }

  open() {
    isOpen = true;
    notifyListeners();
  }

  close() {
    isOpen = false;
    notifyListeners();
  }
}
