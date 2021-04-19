import 'dart:convert';
import 'dart:io';

var os_url = "http://119.45.10.211/offershow"; //请求后台地址
var os_salt = "offershow"; //测试盐值
var os_token = "123456"; //测试Token

class XHttp {
  //发起GET请求
  get({
    String baseUrl = "api.apiopen.top", //默认的请求Host
    String url = "/singlePoetry", //请求的地址
    Map param, //参数
  }) async {
    var httpClient = new HttpClient();
    var uri = new Uri.https(
      baseUrl,
      url,
      param,
    );

    var request = await httpClient.getUrl(uri);
    request.headers.set("test", "hh");
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    print("$request");
    print("$response");
    print("$responseBody");
  }

  post({
    String baseUrl = "api.apiopen.top", //默认的请求Host
    String url = "/singlePoetry", //请求的地址
    Map param, //参数
  }) async {
    var httpClient = new HttpClient();
    var uri = new Uri.https(
      baseUrl,
      url,
      param,
    );

    var request = await httpClient.postUrl(uri);
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    print("$request");
    print("$response");
    print("$responseBody");
  }
}
