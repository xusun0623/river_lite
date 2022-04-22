import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offer_show/util/mid_request.dart';
import 'package:heic_to_jpg/heic_to_jpg.dart';
import 'package:http/http.dart' as http;

/// 接口文档：https://github.com/UESTC-BBS/API-Docs/wiki/Mobcent-API

class Api {
  user_report(Map m) async {
    Map tmp = {
      "r": "user/report",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  user_userfavorite(Map m) async {
    Map tmp = {
      "r": "user/userfavorite",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  user_useradmin(Map m) async {
    Map tmp = {
      "r": "user/useradmin",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  user_userlist(Map m) async {
    Map tmp = {
      "r": "user/userlist",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  user_updateuserinfo(Map m) async {
    Map tmp = {
      "r": "user/updateuserinfo",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  user_topiclist(Map m) async {
    Map tmp = {
      "r": "user/topiclist",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  message_pmadmin(Map m) async {
    Map tmp = {
      "r": "message/pmadmin",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  user_userinfo(Map m) async {
    Map tmp = {
      "r": "user/userinfo",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  message_pmlist(Map m) async {
    Map tmp = {
      "r": "message/pmlist",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  message_notifylistex(Map m) async {
    Map tmp = {
      "r": "message/notifylistex",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  message_notifylist(Map m) async {
    Map tmp = {
      "r": "message/notifylist",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  message_pmsessionlist(Map m) async {
    Map tmp = {
      "r": "message/pmsessionlist",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  message_heart(Map m) async {
    Map tmp = {
      "r": "message/heart",
      "sdkVersion": "2.4.2",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  forum_atuserlist(Map m) async {
    Map tmp = {
      "r": "forum/atuserlist",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  //此处有
  uploadImage(List<XFile> imgs) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        'https://bbs.uestc.edu.cn/mobcent/app/web/index.php?r=forum/sendattachmentex&type=image&module=forum&accessToken=e9f49ac6acace2b9f6582800f32ff&accessSecret=8aef222107fcd2cedcc5f60b4edd1',
      ),
    );
    for (var i = 0; i < imgs.length; i++) {
      var tmp_jpg_path = imgs[i].path;
      if (imgs[i].path.split(".")[1] == "heic") {
        //支持苹果拍照格式
        tmp_jpg_path = await HeicToJpg.convert(imgs[i].path);
      }
      request.files.add(
        await http.MultipartFile.fromPath(
          'uploadFile[]',
          tmp_jpg_path,
          filename: "hello.png",
          contentType: MediaType("image", "jpeg"),
        ),
      );
    }
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String data = await response.stream.bytesToString();
      // {
      //    id: 2109629,
      //    urlName: https://bbs.uestc.edu.cn/data/attachment//forum/202203/07/231221mdoxxgxxxeou2j11.png
      // }
      return jsonDecode(data)["body"]["attachment"];
    } else {
      print(response.reasonPhrase);
      return [];
    }
    /** 
    var dio = new Dio();
    var formData = FormData();
    for (var i = 0; i < imgs.length; i++) {
      var tmp_jpg_path = imgs[i].path;
      if (imgs[i].path.split(".")[1] == "heic") {
        //支持苹果拍照格式
        tmp_jpg_path = await HeicToJpg.convert(imgs[i].path);
      }
      print(tmp_jpg_path);
      formData.files.addAll([
        MapEntry(
          'uploadFile[]',
          MultipartFile.fromFileSync(
            tmp_jpg_path,
            filename: 'upload.' + tmp_jpg_path.split(".")[1],
            /* 一定要写！！！！！！！！！！！！！！！！！！！！！！！*/
            contentType: MediaType(
              "image",
              tmp_jpg_path.split(".")[1] == "jpg"
                  ? "jepg"
                  : tmp_jpg_path.split(".")[1],
            ), //"image/png",
          ),
        ),
      ]);
    }
    var response = await dio.post(
      'https://bbs.uestc.edu.cn/mobcent/app/web/index.php?r=forum/sendattachmentex&type=image&module=forum&accessToken=e9f49ac6acace2b9f6582800f32ff&accessSecret=8aef222107fcd2cedcc5f60b4edd1',
      options: Options(headers: {
        "Content-Type": "multipart/form-data;",
      }),
      data: formData,
    );
    print(jsonDecode(response.data)["body"]["attachment"]);
    */
  }

  //获取板块列表
  forum_forumlist(Map m) async {
    Map tmp = {
      "r": "forum/forumlist",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

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
  forum_search(int select, Map m) async {
    Map tmp = {
      "r": ["forum/search", "user/searchuser"][select], //0-搜索帖子 1-搜索用户
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
