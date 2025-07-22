/*
 * @Author: xusun000「xusun000@foxmail.com」 
 * @Date: 2022-08-03 10:38:39 
 * @Last Modified by:   xusun000 
 * @Last Modified time: 2022-08-03 10:38:39 
 */
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:offer_show/asset/cookie.dart';
import 'package:offer_show/global_key/app.dart';
import 'package:offer_show/util/storage.dart';

const bbs_host = 'bbs.uestc.edu.cn';
const base_url = "https://$bbs_host/";
const vpn_host = 'webvpn.uestc.edu.cn';
const vpn_root = 'https://${vpn_host}/';
const vpn_login_prefix = 'https://webvpn.uestc.edu.cn/https/77726476706e69737468656265737421f9f3408f69256d436a0bc7a99c406d3652/authserver/login';
const vpn_base_url = 'https://${vpn_host}/https/77726476706e69737468656265737421f2f552d232357b447d468ca88d1b203b/';
const vpn_cookie_name = 'wengine_vpn_ticketwebvpn_uestc_edu_cn';
const vpn_cookie_api = '${vpn_root}wengine-vpn/cookie';

class ServerConfig {
  String url = base_url + "mobcent/app/web/index.php";
}

bool isLog = true; //控制是否打印网络输出日志

final baseUrlRegEx = RegExp('^${RegExp.escape(base_url)}', caseSensitive: false);

Future<bool> isVPNEnabled() async {
  vpnEnabled = (await getStorage(key: 'uestc_webvpn')) == "1";
  return vpnEnabled;
}

Future<String> getVPNCookie() async {
  final value =  await getStorage(key: 'uestc_webvpn_ticket');
  if (value?.isNotEmpty) {
    vpnCookie = value;
    return '${vpn_cookie_name}=${value}';
  }
  return '';
}

Future<String> getServerOrigin() async {
  if (await isVPNEnabled()) {
    return vpn_base_url;
  }
  return base_url;
}
Future<String> rebaseUrl(String url) async {
  final origin = await getServerOrigin();
  if (origin == base_url) {
    return url;
  }
  return url.replaceFirst(baseUrlRegEx, origin);
}
String rebaseUrlSync(String url) {
  if (vpnEnabled) {
    return url.replaceFirst(baseUrlRegEx, vpn_base_url);
  }
  return url;
}

class XHttp {
  pureHttpWithCookie(
      {required String url,
      Map<String, dynamic>? param,
      bool hadCookie = false,
      String? method}) async {
    var dio = Dio();
    String cookie = "";
    if (hadCookie) {
      cookie = await getStorage(key: "cookie", initData: "");
    } else {
      cookie = await getWebCookie();
    }
    if (await isVPNEnabled()) {
      final vpnCookie = await getVPNCookie();
      if (vpnCookie.isNotEmpty) {
        cookie = vpnCookie;
      }
    }
    dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.options.responseType = ResponseType.plain;
    dio.options.connectTimeout = Duration(milliseconds: 10000);
    dio.options.receiveTimeout = Duration(milliseconds: 10000);
    Response response = await dio
        .request(await rebaseUrl(url),
            data: param,
            options: Options(
              method: method ?? "POST",
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

  pureHttp(
      {required String url,
      Map<String, dynamic>? param,
      String? method}) async {
    var dio = Dio();
    dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.options.responseType = ResponseType.plain;
    dio.options.connectTimeout = Duration(milliseconds: 10000);
    dio.options.receiveTimeout = Duration(milliseconds: 10000);
    if (isLog) print("地址:$url入参:$param");
    Map<String, dynamic>? headers = null;
    if (await isVPNEnabled()) {
      final vpnCookie = await getVPNCookie();
      if (vpnCookie.isNotEmpty) {
        headers = {'Cookie': vpnCookie};
      }
    }
    Response response = await dio
        .request(await rebaseUrl(url), data: param, options: Options(method: method ?? "POST", headers: headers))
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
    Map<String, dynamic>? header,
    Map<String, dynamic>? param, //参数
  }) async {
    var dio = Dio();
    dio.options.baseUrl = await rebaseUrl(ServerConfig().url);
    dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.options.responseType = ResponseType.plain;
    dio.options.connectTimeout =
        Duration(milliseconds: noTimeOut ?? false ? 10000000 : 10000);
    dio.options.receiveTimeout =
        Duration(milliseconds: noTimeOut ?? false ? 10000000 : 10000);
    if (await isVPNEnabled()) {
      final vpnCookie = await getVPNCookie();
      if (vpnCookie.isNotEmpty) {
        if (header == null) {
          header = {'Cookie': vpnCookie};
        } else if (header.containsKey("Cookie") && header["Cookie"] != "") {
          header["Cookie"] = header["Cookie"] + '; $vpnCookie';
        } else {
          header['Cookie'] = vpnCookie;
        }
      }
    }
    if (isLog) print("地址:$url入参:$param");
    Response response = await dio
        .request(url, data: param, options: Options(method: "POST", headers: header))
        .catchError(
      (err) {
        if (err is DioException && err.response?.statusCode == 302 && err.response!.realUri.host == vpn_host && appNavigator.currentContext != null) {
          if (inWebView == 0) {
            print("open webview");
            ++inWebView;
            Navigator.pushNamed(appNavigator.currentContext!, "/webview", arguments: vpn_root);
          } else {
            print("webview already open");
          }
        }
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
    Map<String, dynamic>? param,
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
    Map<String, dynamic>? header,
    Map<String, dynamic>? param,
  }) async {
    return netWorkRequest(
      url: url,
      header: header,
      param: param,
    );
  }

  saveAuthCookieFromVpn() async {
    final cookies = await pureHttp(url: Uri.parse(vpn_cookie_api).replace(queryParameters: {
      'method': ['get'],
      'host': [bbs_host],
      'scheme': ['https'],
      'path': ['/'],
      'vpn_timestamp': [DateTime.timestamp().millisecondsSinceEpoch.toString()],
    }).toString(), method: 'GET');
    if (cookies?.data is String) {
      final authCookies = cookies.data.split(RegExp(r';\s*')).where((cookie) => cookie.startsWith('v3hW_2132_auth=') || cookie.startsWith('v3hW_2132_saltkey='));
      if (authCookies.isNotEmpty) {
        await setStorage(key: 'cookies_vpn', value: authCookies.join(';'));
      }
    }
  }
  restoreAuthCookieToVpn() async {
    final value = await getStorage(key: 'cookies_vpn');
    if (value is String && value.isNotEmpty) {
      value.split(RegExp(r';\s*')).forEach((cookie) => 
        pureHttp(url: Uri.parse(vpn_cookie_api).replace(queryParameters: {
          'method': ['set'],
          'host': [bbs_host],
          'scheme': ['https'],
          'path': ['/'],
          'ck_data': [cookie],
        }).toString(), method: 'POST')
      );
    }
  }
}
