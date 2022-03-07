import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:offer_show/asset/modal.dart';

class ServerConfig {
  String url = "https://bbs.uestc.edu.cn/mobcent/app/web/index.php";
}

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
    // print("地址:$url入参:$param");
    Response response = await dio
        .request(url, data: param, options: Options(method: "POST"))
        .catchError((err) {});
    if (response != null) {
      // hideToast();
      Map<String, dynamic> user = jsonDecode(response.toString());
      // print("地址:$url入参:$param回参:$user");
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
      "accessToken": "e9f49ac6acace2b9f6582800f32ff",
      "accessSecret": "8aef222107fcd2cedcc5f60b4edd1",
    });
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
