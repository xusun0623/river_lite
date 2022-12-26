/*
 * @Author: xusun000「xusun000@foxmail.com」 
 * @Date: 2022-08-03 10:38:39 
 * @Last Modified by:   xusun000 
 * @Last Modified time: 2022-08-03 10:38:39 
 */
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:offer_show/asset/cookie.dart';
import 'package:offer_show/util/storage.dart';

String base_url = "https://bbs.uestc.edu.cn/";

class ServerConfig {
  String url = base_url + "mobcent/app/web/index.php";
}

bool isLog = false; //控制是否打印网络输出日志

class XHttp {
  pureHttpWithCookie({required String url, Map? param, bool hadCookie = false}) async {
    var dio = Dio();
    String cookie = "";
    if (hadCookie) {
      cookie = await getStorage(key: "cookie", initData: "");
    } else {
      cookie = await getWebCookie();
    }
    dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.options.responseType = ResponseType.plain;
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 10000;
    Response response = await dio
        .request(url,
            data: param,
            options: Options(
              method: "POST",
              headers: {"Cookie": cookie},
            ))
        .catchError(
          (err) {},
        );
    if (response != null) {
      try {
        Map<String, dynamic>? data = jsonDecode(response.toString());
        if (isLog) print("地址:$url入参:$param回参:$data");
        return data;
      } catch (e) {
        return response;
      }
    } else {
      return {};
    }
  }

  pureHttp({required String url, Map? param}) async {
    var dio = Dio();
    dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.options.responseType = ResponseType.plain;
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 10000;
    if (isLog) print("地址:$url入参:$param");
    Response response = await dio
        .request(url, data: param, options: Options(method: "POST"))
        .catchError(
          (err) {},
        );
    if (response != null) {
      try {
        Map<String, dynamic>? data = jsonDecode(response.toString());
        if (isLog) print("地址:$url入参:$param回参:$data");
        return data;
      } catch (e) {
        return response;
      }
    } else {
      return {};
    }
  }

  netWorkRequest({
    bool? noTimeOut, //是否有超时
    String url = "",
    Map? header,
    Map? param, //参数
  }) async {
    var dio = Dio();
    dio.options.baseUrl = ServerConfig().url;
    dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.options.responseType = ResponseType.plain;
    dio.options.connectTimeout = noTimeOut ?? false ? 10000000 : 10000;
    dio.options.receiveTimeout = noTimeOut ?? false ? 10000000 : 10000;
    if (isLog) print("地址:$url入参:$param");
    Response response = await dio
        .request(url, data: param, options: Options(method: "POST"))
        .catchError(
      (err) {
        if (isLog) print("${err}");
      },
    );
    if (response != null) {
      Map<String, dynamic>? data = jsonDecode(response.toString());
      if (isLog) print("地址:$url入参:$param回参:$data");
      return data;
    } else {
      print(response.toString());
      return {};
    }
  }

  postWithGlobalToken({
    bool? noTimeOut,
    Map? param,
    required String url,
  }) async {
    String myinfo_txt = await getStorage(key: "myinfo", initData: "");
    if (myinfo_txt != "") {
      Map myinfo = jsonDecode(myinfo_txt);
      param!.addAll({
        "accessToken": myinfo["token"],
        "accessSecret": myinfo["secret"],
        "platType": Platform.isAndroid ? "" : 5,
      });
    }
    return await netWorkRequest(
      url: url,
      param: param,
      noTimeOut: noTimeOut,
      header: {"Content-Type": "application/x-www-form-urlencoded"},
    );
  }

  //发起POST请求
  post({
    required String url,
    Map? header,
    Map? param,
  }) async {
    return netWorkRequest(
      url: url,
      header: header,
      param: param,
    );
  }
}
