import 'package:offer_show/util/mid_request.dart';

/// 接口文档：https://github.com/UESTC-BBS/API-Docs/wiki/Mobcent-API

class Api {
  forum_postlist(Map m) async {
    Map tmp = {
      "r": "forum/postlist",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  portal_newslist() async {
    return await XHttp().post(
      url: "",
      param: {
        "r": "portal/newslist",
        "moduleId": 2,
      },
    );
  }

  forum_vote(Map m) async {
    m.addAll({"r": "forum/vote"});
    return await XHttp().postWithGlobalToken(
      url: "",
      param: m,
    );
  }

  forum_support(Map m) async {
    m.addAll({"r": "forum/support"});
    return await XHttp().postWithGlobalToken(
      url: "",
      param: m,
    );
  }
}
