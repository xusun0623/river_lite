import 'package:flutter/material.dart';

class UserInfoProvider extends ChangeNotifier {
  Map data;

  refresh() {
    notifyListeners();
  }
}

class HomeRefrshProvider extends ChangeNotifier {
  GlobalKey<RefreshIndicatorState> homeRefreshIndicator =
      GlobalKey<RefreshIndicatorState>();
  GlobalKey<RefreshIndicatorState> recentRefreshIndicator =
      GlobalKey<RefreshIndicatorState>();
  GlobalKey<RefreshIndicatorState> msgRefreshIndicator =
      GlobalKey<RefreshIndicatorState>();
  GlobalKey<RefreshIndicatorState> meRefreshIndicator =
      GlobalKey<RefreshIndicatorState>();

  ScrollController homeScrollController = new ScrollController();
  ScrollController recentScrollController = new ScrollController();
  ScrollController msgScrollController = new ScrollController();
  ScrollController meScrollController = new ScrollController();

  void invoke(int index) {
    [
      homeRefreshIndicator,
      recentRefreshIndicator,
      msgRefreshIndicator,
      meRefreshIndicator
    ][index]
        .currentState
        .show();
    [
      homeScrollController,
      recentScrollController,
      msgScrollController,
      meScrollController
    ][index]
        .animateTo(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
    notifyListeners();
  }
}
