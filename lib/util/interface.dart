import 'package:offer_show/util/mid_request.dart';

/// 接口文档：https://github.com/UESTC-BBS/API-Docs/wiki/Mobcent-API

class Api {
  //获得某一板块的帖子
  certain_forum_topiclist(Map m) async {
    Map tmp = {
      "r": "forum/topiclist",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  //回复
  forum_topicadmin(Map m) async {
    Map tmp = {
      "r": "forum/topicadmin",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  //搜索
  forum_search(Map m) async {
    Map tmp = {
      "r": "forum/search",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  // 最新回复
  forum_topiclist(Map m) async {
    Map tmp = {
      "r": "forum/topiclist",
      // "sortby": "all",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

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

  // 热门
  portal_newslist() async {
    return await XHttp().post(
      url: "",
      param: {
        "r": "portal/newslist",
        "moduleId": 2,
      },
    );
  }

  // 帖子投票
  forum_vote(Map m) async {
    m.addAll({"r": "forum/vote"});
    return await XHttp().postWithGlobalToken(
      url: "",
      param: m,
    );
  }

  // 点赞
  forum_support(Map m) async {
    m.addAll({"r": "forum/support"});
    return await XHttp().postWithGlobalToken(
      url: "",
      param: m,
    );
  }
}
