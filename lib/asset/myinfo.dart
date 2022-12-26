import 'dart:convert';

import 'package:offer_show/util/storage.dart';

Future<int?> getUid() async {
  String myinfo_txt = await getStorage(key: "myinfo", initData: "");
  Map myinfo_map = jsonDecode(myinfo_txt);
  return myinfo_map["uid"];
}
