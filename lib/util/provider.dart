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

  void toTop(List<int> loadIndex, int index) {
    [
      homeScrollController,
      recentScrollController,
      msgScrollController,
      meScrollController
    ][loadIndex[index]]
        .animateTo(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
    notifyListeners();
  }

  void invoke(List<int> loadIndex, int index) {
    if ([
          homeRefreshIndicator,
          recentRefreshIndicator,
          msgRefreshIndicator,
          meRefreshIndicator
        ][loadIndex[index]]
            .currentState !=
        null) {
      [
        homeRefreshIndicator,
        recentRefreshIndicator,
        msgRefreshIndicator,
        meRefreshIndicator
      ][loadIndex[index]]
          .currentState
          .show();
    }

    [
      homeScrollController,
      recentScrollController,
      msgScrollController,
      meScrollController
    ][loadIndex[index]]
        .animateTo(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
    notifyListeners();
  }
}
