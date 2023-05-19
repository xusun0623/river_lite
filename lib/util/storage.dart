/*
 * @Author: xusun000「xusun000@foxmail.com」 
 * @Date: 2022-08-03 10:38:47 
 * @Last Modified by: xusun000
 * @Last Modified time: 2022-09-06 14:40:33
 */
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

getStorage({required String key, String initData = ""}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? s = await prefs.getString(key);
  if (s == null) {
    await prefs.setString(key, initData);
    return initData;
  } else {
    return s;
  }
}

setStorage({required String key, required String value}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? _ = await prefs.getString(key);
  return await prefs.setString(key, value);
}
