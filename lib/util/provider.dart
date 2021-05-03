import 'package:flutter/material.dart';
import 'package:offer_show/asset/data.dart';
import 'package:offer_show/components/tip.dart';
import 'package:offer_show/util/interface.dart';
import 'package:provider/provider.dart';

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

class HomeSchoolSalarys extends ChangeNotifier {
  List<SalaryData> salarys = [];

  getHomeSalary(context) async {
    FilterSchool provider = Provider.of<FilterSchool>(context);
    final mapIndustry = [
      "全部",
      new DateTime.now().year.toString(),
      (new DateTime.now().year - 1).toString(),
    ];
    final mapEducation = ["全部", "博士", "硕士", "本科", "大专", "其他"];
    final res = await Api().webapi_v2_offers_4_lr(
      param: {
        "xueli": mapEducation[provider.tipIndex2],
        "salarytype": "校招",
        "limit": 5,
      },
    );
    final tmp = toLocalSalary(res['info']);
  }

  List<Widget> buildSalary() {}
}

class FilterSchool extends ChangeNotifier {
  bool isOpen = false;
  int mainIndex = 0;
  int tipIndex1 = 0;
  int tipIndex2 = 0;

  show() {
    print("mainIndex:${mainIndex},tipIndex:${tipIndex1},${tipIndex2}");
  }

  setMainIndex(index) {
    mainIndex = index;
    notifyListeners();
  }

  setTipIndex1(index) {
    tipIndex1 = index;
    notifyListeners();
  }

  setTipIndex2(index) {
    tipIndex2 = index;
    notifyListeners();
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

class HomeTabIndex extends ChangeNotifier {
  PageController controller = new PageController(initialPage: 0);
  int tabIndex = 0;
  setIndex(int index) {
    tabIndex = index;
    notifyListeners();
  }

  switchTab(int index) {
    tabIndex = index;
    controller.animateToPage(
      tabIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
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
