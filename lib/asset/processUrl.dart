import 'package:flutter/material.dart';
import 'package:offer_show/asset/to_user.dart';

//判断是不是特殊的链接
bool specialUrl(String url) {
  if (url == "" ||
      url.contains("https://bbs.uestc.edu.cn/forum.php?mod=viewthread&tid=") ||
      url.contains("https://bbs.uestc.edu.cn/home.php?mod=space&uid=") ||
      url.contains("https://bbs.uestc.edu.cn/thread/") ||
      url.contains("https://bbs.uestc.edu.cn/user/") ||
      url.contains("https://bbs.uestc.edu.cn/user/at:")) {
    return true;
  } else {
    return false;
  }
}

//处理特殊的链接
processUrl(String url, BuildContext context) {
  if (url.contains("https://bbs.uestc.edu.cn/forum.php?mod=viewthread&tid=")) {
    int tid_tmp = int.parse(
      url.split("mod=viewthread&tid=")[1].split("&")[0],
    );
    Navigator.pushNamed(context, "/topic_detail", arguments: tid_tmp);
  } else if (url.contains("https://bbs.uestc.edu.cn/thread/")) {
    String tmp_suffix = url.toString().split("thread/")[1];
    Navigator.pushNamed(
      context,
      "/topic_detail",
      arguments: int.parse(
        tmp_suffix.contains("/") ? tmp_suffix.split("/")[0] : tmp_suffix,
      ),
    );
  } else if (url.contains("https://bbs.uestc.edu.cn/user/at:")) {
    String tmp_suffix = url.toString().split("at:")[1];

    toUserSpace(
      context,
      int.parse(
        tmp_suffix.contains("/") ? tmp_suffix.split("/")[0] : tmp_suffix,
      ),
    );
  } else if (url.contains("https://bbs.uestc.edu.cn/user/")) {
    String tmp_suffix = url.toString().split("user/")[1];

    toUserSpace(
      context,
      int.parse(
        tmp_suffix.contains("/") ? tmp_suffix.split("/")[0] : tmp_suffix,
      ),
    );
  } else if (url.contains("https://bbs.uestc.edu.cn/home.php?mod=space&uid=")) {
    int uid_tmp = int.parse(
      url.split("mod=space&uid=")[1].split("&")[0],
    );
    toUserSpace(context, uid_tmp);
  }
}
