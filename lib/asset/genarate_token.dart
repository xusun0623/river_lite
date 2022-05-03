import 'dart:convert';

import 'package:offer_show/util/storage.dart';

//访问网页的时候把Token带上
Future<String> attachWebToken() async {
  String myinfo_txt = await getStorage(key: "myinfo", initData: "");
  if (myinfo_txt == "") return "";
  try {
    Map myinfo = jsonDecode(myinfo_txt);
    return "&accessToken=${myinfo["token"]}&accessSecret=${myinfo["secret"]}";
  } catch (e) {
    return "";
  }
}
