import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
import 'package:provider/provider.dart';

removeBlackWord(String t, BuildContext context) async {
  //新增拉黑关键词
  String tmp = await getStorage(key: "black", initData: "[]");
  List tmp_arr = jsonDecode(tmp);
  if (tmp_arr.contains(t)) tmp_arr.remove(t);
  await setStorage(key: "black", value: jsonEncode(tmp_arr));
  Provider.of<BlackProvider>(context, listen: false).black = tmp_arr;
  Provider.of<BlackProvider>(context, listen: false).refresh();
  return;
}

setBlackWord(String? t, BuildContext context) async {
  //新增拉黑关键词
  String tmp = await getStorage(key: "black", initData: "[]");
  List tmp_arr = jsonDecode(tmp);
  if (!tmp_arr.contains(t)) tmp_arr.add(t);
  await setStorage(key: "black", value: jsonEncode(tmp_arr));
  Provider.of<BlackProvider>(context, listen: false).black = tmp_arr;
  Provider.of<BlackProvider>(context, listen: false).refresh();
  return;
}
