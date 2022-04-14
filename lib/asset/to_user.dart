import 'package:flutter/material.dart';

toUserSpace(BuildContext context, int uid) {
  Navigator.pushNamed(context, "/person_center", arguments: {
    "uid": uid,
    "isMe": false,
  });
}
