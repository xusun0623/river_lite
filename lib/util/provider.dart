import 'package:flutter/material.dart';

class UserInfoProvider extends ChangeNotifier {
  Map data;

  refresh() {
    notifyListeners();
  }
}
