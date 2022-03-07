import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offer_show/util/mid_request.dart';
import 'package:heic_to_jpg/heic_to_jpg.dart';
import 'package:http/http.dart' as http;

/// 接口文档：https://github.com/UESTC-BBS/API-Docs/wiki/Mobcent-API

class Api {
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
      return jsonDecode(jsonDecode(data)["body"]["attachment"]);
    } else {
      return [];
      print(response.reasonPhrase);
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
