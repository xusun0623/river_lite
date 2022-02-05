import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 3000;
    EasyLoading.instance..indicatorType = EasyLoadingIndicatorType.ring;
    EasyLoading.instance..maskType = EasyLoadingMaskType.black;
    print("地址:$url入参:$param");
    Response response = await dio
        .request(url, data: param, options: Options(method: "POST"))
        .catchError((err) {
      Fluttertoast.showToast(msg: "网络请求错误", gravity: ToastGravity.CENTER);
    });
    EasyLoading.dismiss();
    if (response != null) {
      Map<String, dynamic> user = jsonDecode(response.toString());
      print("地址:$url入参:$param回参:$user");
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
