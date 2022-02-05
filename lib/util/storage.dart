import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

getStorage({@required String key, String initData = ""}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String s = await prefs.getString(key);
  if (s == null) {
    await prefs.setString(key, initData);
    print("获得数据:$key-$initData");
    return initData;
  } else {
    print("获得数据:$key-$s");
    return s;
  }
}

setStorage({@required String key, @required String value}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String s = await prefs.getString(key);
  print("存储数据:$key-$value");
  return await prefs.setString(key, value);
}
