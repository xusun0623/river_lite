/*
 * @Author: xusun000「xusun000@foxmail.com」 
 * @Date: 2022-08-03 10:38:34 
 * @Last Modified by: xusun000
 * @Last Modified time: 2022-09-06 14:39:39
 */
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:html/dom.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offer_show/asset/cookie.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/util/mid_request.dart';
import 'package:http/http.dart' as http;
import 'package:offer_show/util/storage.dart';
import 'package:path_provider/path_provider.dart';

/// 接口文档：https://github.com/UESTC-BBS/API-Docs/wiki/Mobcent-API
class Api {
  buyItem(Map<String, dynamic> m) async {
    /**
     * formhash: aa6ff688
     * operation: buy
     * mid: namepost
     * magicnum: 0
     * operatesubmit: yes
     * operatesubmit: true
     */
    return await XHttp().pureHttpWithCookie(
      method: "POST",
      url:
          "https://bbs.uestc.edu.cn/home.php?mod=magic&action=shop&infloat=yes",
      param: m,
      hadCookie: true,
    );
  }

  post_append({
    int? tid,
    int? pid,
    String? message,
  }) async {
    // 补充帖子评论内容
    String html = (await XHttp().pureHttpWithCookie(
      url:
          "https://bbs.uestc.edu.cn/forum.php?mod=misc&action=postappend&tid=${tid}&pid=${pid}&extra=&page=1&infloat=yes&handlekey=postappend&inajax=1&ajaxtarget=fwin_content_postappend",
      hadCookie: true,
      method: "GET",
    ))
        .toString();
    Document html_doc = Document.html(html);
    String? formhash = html_doc.getElementById("formhash")!.attributes["value"];
    await XHttp().pureHttpWithCookie(
      url:
          "https://bbs.uestc.edu.cn/forum.php?mod=misc&action=postappend&tid=${tid}&pid=${pid}&extra=&page=1&postappendsubmit=yes&infloat=yes&inajax=1",
      hadCookie: true,
      param: {
        "formhash": formhash,
        "handlekey": "postappend",
        "postappendmessage": message,
        "postappendsubmit": true,
      },
    );
  }

  finish_question() async {
    String cookie = (await getStorage(key: "cookie", initData: "")).toString();
    String formhash =
        (await getStorage(key: "formhash", initData: "")).toString();
    var headers = {'Cookie': cookie};
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(base_url + 'plugin.php?id=ahome_dayquestion:pop'),
    );
    request.fields.addAll({'formhash': formhash, 'finish': 'true'});
    request.headers.addAll(headers);
    request.followRedirects = false;
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
    return;
  }

  next_question() async {
    String cookie = await getStorage(key: "cookie", initData: "");
    String formhash = await getStorage(key: "formhash", initData: "");
    var headers = {'Cookie': cookie};
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(base_url + 'plugin.php?id=ahome_dayquestion:pop'),
    );
    request.fields.addAll({'formhash': formhash, 'next': 'true'});
    request.headers.addAll(headers);
    request.followRedirects = false;
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
    } else {
      print(response.reasonPhrase);
    }
    return;
  }

  submit_question({int? answer, BuildContext? context}) async {
    String cookie = await getStorage(key: "cookie", initData: "");
    var headers = {'Cookie': cookie};
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(base_url + 'plugin.php?id=ahome_dayquestion:pop'),
    );
    request.fields.addAll(
      {
        'formhash':
            (await getStorage(key: "formhash", initData: "")).toString(),
        'answer': '${answer}',
        'submit': 'true',
      },
    );
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String html = await response.stream.bytesToString();
      if (html.contains("错误") && context != null) {
        showToast(context: context, type: XSToast.none, txt: "答题错误,扣除10水滴");
      }
    } else {
      print(response.reasonPhrase);
    }
    return;
  }

  get_question() async {
    String cookie = await getStorage(key: "cookie", initData: "");
    var headers = {'Cookie': cookie};
    var request = http.Request(
      'GET',
      Uri.parse(base_url + 'plugin.php?id=ahome_dayquestion:pop'),
    );
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String html = await response.stream.bytesToString();
      await setStorage(
        key: "formhash",
        value: html
            .split("formhash=")[1]
            .split(">")[0]
            .substring(0, html.split("formhash=")[1].split(">")[0].length - 1),
      );
      if (html.contains("您今天已经参加过答题")) {
        return "";
      } else if (html.contains("恭喜您完成了全部的挑战关卡")) {
        return "1";
      } else if (html.contains("您有勇气挑战下一关吗")) {
        return "2";
      } else {
        String tmp_q = html
            .split("【题目】</b>&nbsp;")[1]
            .split("</font>")[0]
            .toString(); //题目文本
        String progress = html.split("【关卡】</b>")[1].split("</font>")[0];
        List<String> tmp_a = []; //题目答案
        List<int> tmp_value = []; //题目答案值
        List<String> tmp_split = html.split("radio");
        int answer_num = tmp_split.length - 1; //有几个答案
        for (int i = 1; i <= answer_num; i++) {
          String tmp_tmp_radio = tmp_split[i];
          tmp_value.add(int.parse(tmp_tmp_radio
              .split("value=")[1]
              .split(">&nbsp;&nbsp")[0]
              .toString()[1]));
          tmp_a.add(
            tmp_tmp_radio
                .split("&nbsp;&nbsp;")[1]
                .split("</div><div")[0]
                .toString(),
          );
        }
        Map<String, dynamic> q_a = {
          "q": tmp_q, //题目
          "a_list": tmp_a, //题目的答案
          "v_list": tmp_value, //题目答案的值
          "progress": progress.replaceAll(" ", ""), //答题进度
        };
        return jsonEncode(q_a);
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  edit_avator({String? base64_1, String? base64_2, String? base64_3}) async {
    await getWebCookie();
    String cookie = await getStorage(key: "cookie", initData: "");
    if (cookie != "") {
      //换取网页的agent和input值
      var request1 = http.Request(
        'POST',
        Uri.parse(base_url + 'home.php?mod=spacecp&ac=avatar'),
      );
      request1.headers.addAll({'Cookie': cookie});
      http.StreamedResponse response1 = await request1.send();
      if (response1.statusCode == 200) {
        String web_txt = await response1.stream.bytesToString();
        String input = web_txt.split("appid=1&input=")[1].split("&agent=")[0];
        String agent = web_txt.split("&agent=")[1].split("&ucapi=")[0];
        var request2 = http.MultipartRequest(
          'POST',
          Uri.parse(
            base_url +
                'uc_server/index.php?m=user&a=rectavatar&base64=yes&appid=1&ucapi=bbs.uestc.edu.cn%2Fuc_server&avatartype=virtual&uploadSize=2048&input=${input}&agent=${agent}',
          ),
        );
        request2.fields.addAll({
          'avatar1': base64_1!,
          'avatar2': base64_2!,
          'avatar3': base64_3!,
        });
        request2.headers.addAll({'Cookie': cookie});
        http.StreamedResponse response2 = await request2.send();
        if (response2.statusCode == 200) {
          print(await response2.stream.bytesToString());
          return;
        } else {
          print(response2.reasonPhrase);
        }
      } else {
        print(response1.reasonPhrase);
      }
    }
  }

  user_login(Map<String, dynamic> m) async {
    Map<String, dynamic> tmp = {
      "r": "user/login",
    };
    setStorage(key: "name", value: m["username"]);
    setStorage(key: "pwd", value: m["password"]);
    tmp.addAll(m);
    return await XHttp().post(
      url: "",
      param: tmp,
    );
  }

  user_report(Map<String, dynamic> m) async {
    Map<String, dynamic> tmp = {
      "r": "user/report",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  user_userfavorite(Map<String, dynamic> m) async {
    Map<String, dynamic> tmp = {
      "r": "user/userfavorite",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  user_useradmin(Map<String, dynamic> m) async {
    Map<String, dynamic> tmp = {
      "r": "user/useradmin",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  user_userlist(Map<String, dynamic> m) async {
    Map<String, dynamic> tmp = {
      "r": "user/userlist",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  user_updateuserinfo(Map<String, dynamic> m) async {
    Map<String, dynamic> tmp = {
      "r": "user/updateuserinfo",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  user_topiclist(Map<String, dynamic> m) async {
    Map<String, dynamic> tmp = {
      "r": "user/topiclist",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  message_pmadmin(Map<String, dynamic> m) async {
    Map<String, dynamic> tmp = {
      "r": "message/pmadmin",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  user_userinfo(Map<String, dynamic> m) async {
    Map<String, dynamic> tmp = {
      "r": "user/userinfo",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  message_pmlist(Map<String, dynamic> m) async {
    Map<String, dynamic> tmp = {
      "r": "message/pmlist",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  message_notifylistex(Map<String, dynamic> m) async {
    Map<String, dynamic> tmp = {
      "r": "message/notifylistex",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  message_notifylist(Map<String, dynamic> m) async {
    Map<String, dynamic> tmp = {
      "r": "message/notifylist",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  message_pmsessionlist(Map<String, dynamic> m) async {
    Map<String, dynamic> tmp = {
      "r": "message/pmsessionlist",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  message_heart(Map<String, dynamic> m) async {
    Map<String, dynamic> tmp = {
      "r": "message/heart",
      "sdkVersion": "2.4.2",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  forum_atuserlist(Map<String, dynamic> m) async {
    Map<String, dynamic> tmp = {
      "r": "forum/atuserlist",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  Future<String> convertHeicToJpg(String heicPath) async {
    // 定义输出文件的路径，这里将文件存储在临时目录
    var tempDir = await getTemporaryDirectory();
    String jpgPath = '${tempDir.path}/output.jpg';

    // 使用flutter_image_compress来压缩并转换图片格式
    var result = await FlutterImageCompress.compressAndGetFile(
      heicPath,
      jpgPath,
      quality: 100, // 可以调整输出质量
      format: CompressFormat.jpeg,
    );

    if (result != null) {
      print('图片转换成功: $jpgPath');
      return jpgPath;
    } else {
      throw Exception("图片转换失败");
    }
  }

  //此处有
  uploadImage({List<XFile>? imgs}) async {
    print("上传图片 ${imgs}");
    String myinfo_txt = await getStorage(key: "myinfo", initData: "");
    if (myinfo_txt != "") {
      Map<String, dynamic> myinfo = jsonDecode(myinfo_txt);
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          base_url +
              'mobcent/app/web/index.php?r=forum/sendattachmentex&type=image&module=forum&accessToken=${myinfo["token"]}&accessSecret=${myinfo["secret"]}',
        ),
      );
      for (var i = 0; i < imgs!.length; i++) {
        String? tmp_jpg_path = imgs[i].path;
        if (imgs[i].path.split(".")[1] == "heic") {
          //支持苹果拍照格式
          tmp_jpg_path = await convertHeicToJpg(imgs[i].path);
        }
        request.files.add(
          await http.MultipartFile.fromPath(
            'uploadFile[]',
            tmp_jpg_path!,
            filename: "hello.png",
            /* 一定要写！！！！！！！！！！！！！！！！！！！！！！！*/
            contentType: MediaType("image", "jpeg"),
          ),
        );
      }
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String data = await response.stream.bytesToString();
        return jsonDecode(data)["body"]["attachment"];
      } else {
        print(response.reasonPhrase);
        return [];
      }
    }
  }

  //获取板块列表
  forum_forumlist(Map<String, dynamic> m) async {
    Map<String, dynamic> tmp = {
      "r": "forum/forumlist",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  //获得某一板块的帖子
  certain_forum_topiclist(Map<String, dynamic> m) async {
    Map<String, dynamic> tmp = {
      "r": "forum/topiclist",
      "isImageList": 1,
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  //回复
  forum_topicadmin(Map<String, dynamic> m) async {
    Map<String, dynamic> tmp = {
      "r": "forum/topicadmin",
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      param: tmp,
    );
  }

  //搜索
  forum_search(int select, Map<String, dynamic> m) async {
    Map<String, dynamic> tmp = {
      "r": ["forum/search", "user/searchuser"][select], //0-搜索帖子 1-搜索用户
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      noTimeOut: true,
      param: tmp,
    );
  }

  // 最新回复
  forum_topiclist(Map<String, dynamic> m) async {
    Map<String, dynamic> tmp = {
      "r": "forum/topiclist",
      "isImageList": 1,
    };
    tmp.addAll(m);
    return await XHttp().postWithGlobalToken(
      url: "",
      noTimeOut: true,
      param: tmp,
    );
  }

  forum_postlist(Map<String, dynamic> m) async {
    Map<String, dynamic> tmp = {
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
    return await XHttp().postWithGlobalToken(
      url: "",
      param: {
        "r": "portal/newslist",
        "moduleId": 2,
      },
    );
  }

  // 帖子投票
  forum_vote(Map<String, dynamic> m) async {
    m.addAll({"r": "forum/vote"});
    return await XHttp().postWithGlobalToken(
      url: "",
      param: m,
    );
  }

  // 点赞
  forum_support(Map<String, dynamic> m) async {
    m.addAll({"r": "forum/support"});
    return await XHttp().postWithGlobalToken(
      url: "",
      param: m,
    );
  }
}
