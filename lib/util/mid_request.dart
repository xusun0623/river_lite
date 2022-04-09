import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:offer_show/asset/modal.dart';

class ServerConfig {
  String url = "https://bbs.uestc.edu.cn/mobcent/app/web/index.php";
}

bool isLog = false;

class XHttp {
  netWorkRequest({
    String url = "",
    Map header,
    Map param, //参数
  }) async {
    var dio = Dio();
    dio.options.baseUrl = ServerConfig().url;
    dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.options.responseType = ResponseType.plain;
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 10000;
    if (isLog) print("地址:$url入参:$param");
    Response response = await dio
        .request(url, data: param, options: Options(method: "POST"))
        .catchError(
      (err) {
        if (isLog) print("${err}");
      },
    );
    if (response != null) {
      Map<String, dynamic> user = jsonDecode(response.toString());
      if (isLog) print("地址:$url入参:$param回参:$user");
      return user;
    } else {
      return new Map();
    }
  }

  postWithGlobalToken({
    Map param,
    String url,
  }) async {
    // final prefs = await SharedPreferences.getInstance();
    // final String accessToken = prefs.getString('accessToken');
    // final String accessSecret = prefs.getString('accessSecret');
    // if (accessToken == "" || accessSecret == "") {
    //   print("需要登录");
    //   return new Map();
    // }
    param.addAll({
      //肖坤
      "accessToken": "cb9c6e29e87b7963721083e5d2bf2",
      "accessSecret": "bb1d53d63486c01b120e1585e044c",
    });
    // param.addAll({
    //   //许孙
    //   "accessToken": "e9f49ac6acace2b9f6582800f32ff",
    //   "accessSecret": "8aef222107fcd2cedcc5f60b4edd1",
    // });
    return await netWorkRequest(
      url: url,
      param: param,
      header: {"Content-Type": "application/x-www-form-urlencoded"},
    );
  }

  //发起POST请求
  post({
    String url,
    Map header,
    Map param,
  }) async {
    return netWorkRequest(
      url: url,
      header: header,
      param: param,
    );
  }
}
