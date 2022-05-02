import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:offer_show/util/storage.dart';

class ServerConfig {
  String url = "https://bbs.uestc.edu.cn/mobcent/app/web/index.php";
}

bool isLog = true; //控制是否打印网络输出日志

class XHttp {
  pureHttp({String url, Map param}) async {
    var dio = Dio();
    dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.options.responseType = ResponseType.plain;
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 10000;
    if (isLog) print("地址:$url入参:$param");
    Response response = await dio
        .request(url, data: param, options: Options(method: "POST"))
        .catchError(
      (err) {
        // if (isLog) print("${err}");
      },
    );
    if (response != null) {
      Map<String, dynamic> data = jsonDecode(response.toString());
      if (isLog) print("地址:$url入参:$param回参:$data");
      return data;
    } else {
      return {};
    }
  }

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
        // if (isLog) print("${err}");
      },
    );
    if (response != null) {
      Map<String, dynamic> data = jsonDecode(response.toString());
      if (isLog) print("地址:$url入参:$param回参:$data");
      return data;
    } else {
      return {};
    }
  }

  postWithGlobalToken({
    Map param,
    String url,
  }) async {
    String myinfo_txt = await getStorage(key: "myinfo", initData: "");
    if (myinfo_txt != "") {
      Map myinfo = jsonDecode(myinfo_txt);
      param.addAll({
        "accessToken": myinfo["token"],
        "accessSecret": myinfo["secret"],
      });
    }
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
