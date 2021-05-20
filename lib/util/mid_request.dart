import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:offer_show/util/provider.dart';

class ServerConfig {
  String os_url = "https://www.ioffershow.com";
  String os_salt = "offershow762932334";
  String os_token = "\$ytkzhLIvv5+sYwytrpIDkg26d4HQpxjr6pCoffershowzju1qaz";
}

// class ServerConfig {
//   String os_url = "http://119.45.10.211/offershow";
//   String os_salt = "offershow";
//   String os_token = "123456";
// }

enum Method { GET, POST, PUT, DELETE, PATCH }
enum WithLoading { YES, NOOP }

class XHttp {
  //发起网络请求
  netWorkRequest({
    Method method = Method.GET, //网络请求的类型-可选POST GET PUT DELETE等
    String baseUrl = "api.apiopen.top", //默认的请求Host
    String url = "/singlePoetry", //请求的地址
    //header设置的请求头内容
    //"Content-Type": "application/x-www-form-urlencoded"
    //"Authorization": "JWT " + token
    Map header,
    Map param, //参数
  }) async {
    var dio = Dio();
    final Directory = ["http://", "HTTP://", "Http://"];
    final isHttp = Directory.indexOf(baseUrl.substring(0, 7)) > -1;

    dio.options.baseUrl = baseUrl;
    dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.options.responseType = ResponseType.plain;
    dio.options.connectTimeout = 5000; //5s
    dio.options.receiveTimeout = 3000;

    EasyLoading.instance..indicatorType = EasyLoadingIndicatorType.ring;
    EasyLoading.instance..maskType = EasyLoadingMaskType.black;
    if (loadingStatus) EasyLoading.show(status: '加载中…');
    Response response = await dio
        .request(
      url,
      data: param,
      options: Options(
        method: [
          "GET",
          "POST",
          "PUT",
          "DELETE",
          "PATCH",
        ][[
          Method.GET,
          Method.POST,
          Method.PUT,
          Method.DELETE,
          Method.PATCH,
        ].indexOf(method)],
      ),
    )
        .catchError(
      (err) {
        Fluttertoast.showToast(
          msg: "网络请求错误",
          gravity: ToastGravity.CENTER,
        );
      },
    );
    EasyLoading.dismiss();
    if (response != null) {
      Map<String, dynamic> user = jsonDecode(response.toString());
      print("地址:$url入参:$param回参:$user");
      loadingStatus = true;
      return user;
    } else {
      return new Map();
    }
  }

  //带Token
  postWithGlobalToken({
    Map param,
    String url,
  }) async {
    return await httpWithGlobalToken(
      param: param,
      url: url,
      method: Method.POST,
    );
  }

  //带Token
  getWithGlobalToken({
    Map param,
    String url,
  }) async {
    return await httpWithGlobalToken(
      param: param,
      url: url,
      method: Method.GET,
    );
  }

  //带Token
  putWithGlobalToken({
    Map param,
    String url,
  }) async {
    return await httpWithGlobalToken(
      param: param,
      url: url,
      method: Method.PUT,
    );
  }

  //带Token
  deleteWithGlobalToken({
    Map param,
    String url,
  }) async {
    return await httpWithGlobalToken(
      param: param,
      url: url,
      method: Method.DELETE,
    );
  }

  //带Token
  patchWithGlobalToken({
    Map param,
    String url,
  }) async {
    return await httpWithGlobalToken(
      param: param,
      url: url,
      method: Method.PATCH,
    );
  }

  httpWithGlobalToken({
    Map param,
    String url,
    Method method,
  }) async {
    var timeStamp = new DateTime.now().millisecondsSinceEpoch; // 时间戳
    var token = ServerConfig().os_token; //Token
    param = param == null ? {} : param;
    param.addAll({
      "access_token": "${token}.${timeStamp}." +
          md5
              .convert(utf8
                  .encode("${token}.${ServerConfig().os_salt}.${timeStamp}"))
              .toString()
    });
    return await netWorkRequest(
        method: method,
        baseUrl: ServerConfig().os_url,
        url: url,
        param: param,
        header: {
          "Content-Type": "application/x-www-form-urlencoded",
        });
  }

  //发起GET请求
  get({
    String baseUrl,
    String url,
    Map header,
    Map param,
  }) async {
    return netWorkRequest(
      method: Method.GET,
      baseUrl: baseUrl,
      url: url,
      header: header,
      param: param,
    );
  }

//发起POST请求
  post({
    String baseUrl,
    String url,
    Map header,
    Map param,
  }) async {
    return netWorkRequest(
      method: Method.POST,
      baseUrl: baseUrl,
      url: url,
      header: header,
      param: param,
    );
  }

  //将参数中的数字转化为数字
  convertToNumerc(Map param) {
    if (param == null) return param;
    var tmp = {};
    param.forEach((key, value) {
      if (value == null || isNumeric(value)) {
        tmp.addAll({key: value});
      } else {
        tmp.addAll({key: double.tryParse(value)});
      }
    });
    return tmp;
  }

  //判断是否是纯数字
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
}
