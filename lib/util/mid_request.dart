import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class ServerConfig {
  String url = "https://bbs.uestc.edu.cn/mobcent/app/web/index.php";
  // String url = "http://124.223.79.175:8000";
}

bool isLog = true;

class XHttp {
  // 有代理
  // netWorkRequest({
  //   String url = "",
  //   Map header,
  //   Map param, //参数
  // }) async {
  //   param.forEach((key, value) {
  //     if (value is int) {
  //       param[key] = "$value";
  //     }
  //   });
  //   print("${param}");

  //   var request = http.Request('GET', Uri.parse('http://124.223.79.175:8000'));
  //   request.bodyFields = new Map<String, String>.from(param);
  //   request.followRedirects = false;

  //   http.StreamedResponse response = await request.send();

  //   if (response != null) {
  //     Map<String, dynamic> user =
  //         jsonDecode(await response.stream.bytesToString());
  //     if (isLog) print("地址:$url入参:$param回参:$user");
  //     return user;
  //   } else {
  //     print(response.reasonPhrase);
  //     return new Map();
  //   }
  // }

  // 无代理
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
    // param.addAll({
    //   //肖坤
    //   "accessToken": "cb9c6e29e87b7963721083e5d2bf2",
    //   "accessSecret": "bb1d53d63486c01b120e1585e044c",
    // });
    param.addAll({
      //许孙
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
