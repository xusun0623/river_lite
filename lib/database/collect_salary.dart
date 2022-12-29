import 'package:shared_preferences/shared_preferences.dart';

/// 收藏的薪资
class CollectSalary {
  ///查看收藏
  lookCollect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(prefs.getString("collect-salary"));
  }

  clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  /// 删除收藏
  delCollect(String salaryID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("collect-salary")) {
      String tmp = prefs.get("collect-salary"); //按照"123,456,666"这种格式存储
      List<String> tmpArr = tmp.split(",");
      tmpArr.remove(salaryID);
      prefs.setString("collect-salary", tmpArr.join(",").toString());
    }
  }

  /// 增加收藏
  addCollect(String salaryID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("collect-salary")) {
      String tmp = prefs.get("collect-salary"); //按照"123,456,666"这种格式存储
      prefs.setString("collect-salary", tmp + "," + salaryID);
    } else {
      prefs.setString("collect-salary", salaryID);
    }
  }

  /// 查看收藏
  Future<List> getCollect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("collect-salary")) {
      String tmp = prefs.get("collect-salary"); //按照"123,456,666"这种格式存储
      return tmp.split(",");
    } else {
      return [];
    }
  }

  /// 是否被收藏
  Future<bool> isCollected(String salaryID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("collect-salary")) {
      String tmp = prefs.get("collect-salary"); //按照"123,456,666"这种格式存储
      return tmp.split(",").contains(salaryID);
    } else {
      return false;
    }
  }
}
