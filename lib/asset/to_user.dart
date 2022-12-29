import 'package:flutter/material.dart';
import 'package:offer_show/asset/myinfo.dart';

toUserSpace(BuildContext context, int uid) async {
  int host_uid = await getUid();
  Navigator.pushNamed(context, "/person_center", arguments: {
    "uid": uid,
    "isMe": host_uid == uid,
  });
}
